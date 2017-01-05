
   12 from __future__ import print_function
   13 from gams import *
   14 import threading
   15 import sys
   16 import os
   17 
   18 def get_model_text():
   19     return '''
   20 $title Warehouse.gms
   21 
   22 $eolcom //
   23 $SetDDList warehouse store fixed disaggregate // acceptable defines
   24 $if not set warehouse    $set warehouse   10
   25 $if not set store        $set store       50
   26 $if not set fixed        $set fixed       20
   27 $if not set disaggregate $set disaggregate 1 // indicator for tighter bigM constraint
   28 $ife %store%<=%warehouse% $abort Increase number of stores (>%warehouse)
   29 
   30 set res respond codes  / 0 Normal
   31                          1 License Error
   32                          2 No solution
   33                          3 Other Error   /
   34     ares(res)          / 3 /;
   35 
   36 Sets Warehouse  /w1*w%warehouse% /
   37      Store      /s1*s%store%     /
   38 Alias (Warehouse,w), (Store,s);
   39 Scalar
   40      fixed        fixed cost for opening a warehouse / %fixed% /
   41 Parameter
   42      capacity(WareHouse)
   43      supplyCost(Store,Warehouse);
   44 
   45 $eval storeDIVwarehouse trunc(card(store)/card(warehouse))
   46 capacity(w)     =   %storeDIVwarehouse% + mod(ord(w),%storeDIVwarehouse%);
   47 supplyCost(s,w) = 1+mod(ord(s)+10*ord(w), 100);
   48 
   49 Variables
   50     open(Warehouse)
   51     supply(Store,Warehouse)
   52     obj;
   53 Binary variables open, supply;
   54 
   55 Equations
   56     defobj
   57     oneWarehouse(s)
   58     defopen(w);
   59 
   60 defobj..  obj =e= sum(w, fixed*open(w)) + sum((w,s), supplyCost(s,w)*supply(s,w));
   61 
   62 oneWarehouse(s).. sum(w, supply(s,w)) =e= 1;
   63 
   64 defopen(w)..      sum(s, supply(s,w)) =l= open(w)*capacity(w);
   65 
   66 $ifthen %disaggregate%==1
   67 Equations
   68      defopen2(s,w);
   69 defopen2(s,w).. supply(s,w) =l= open(w);
   70 $endif
   71 
   72 model distrib /all/;
   73 solve distrib min obj using mip;
   74 
   75 $macro setResult(n) option clear=ares; ares(n) = yes;
   76 if (distrib.modelstat=%ModelStat.LicensingProblem% or
   77     distrib.solvestat=%Solvestat.LicensingProblems%,
   78   setResult('1');
   79   abort 'License Error';
   80 );
   81 if (distrib.solvestat<>%SolveStat.NormalCompletion% or
   82     distrib.modelstat<>%ModelStat.Optimal% and
   83     distrib.modelstat<>%ModelStat.IntegerSolution%,
   84   setResult('2');
   85   abort 'No solution';
   86 );
   87 setResult('0'); '''
   88 
   89 def solve_warehouse(workspace, number_of_warehouses, result, db_lock):
   90     global status
   91     global status_string
   92     try:
   93         # instantiate GAMSOptions and define some scalars
   94         opt = workspace.add_options()
   95         opt.all_model_types = "cplex"
   96         opt.defines["Warehouse"] = str(number_of_warehouses)
   97         opt.defines["Store"] = "65"
   98         opt.defines["fixed"] = "22"
   99         opt.defines["disaggregate"] = "0"
  100         opt.optcr = 0.0 # Solve to optimality
  101 
  102         # create a GAMSJob from string and write results to the result database
  103         job = workspace.add_job_from_string(get_model_text())
  104         job.run(opt)
  105 
  106         # need to lock database write operations
  107         db_lock.acquire()
  108         result["objrep"].add_record(str(number_of_warehouses)).value = job.out_db["obj"][()].level
  109         db_lock.release()
  110         for supply_rec in job.out_db["supply"]:
  111             if supply_rec.level > 0.5:
  112                 db_lock.acquire()
  113                 result["supplyMap"].add_record((str(number_of_warehouses), supply_rec.key(0), supply_rec.key(1)))
  114                 db_lock.release()
  115     except GamsExceptionExecution as e:
  116         # Check if we see a User triggered abort and look for the user defined result
  117         if e.rc == GamsExitCode.ExecutionError:
  118             db_lock.acquire()
  119             status_string = job.out_db["res"]
  120             status_string = status_string.find_record(job.out_db["ares"].first_record().key(0)).text
  121             db_lock.release()
  122         db_lock.acquire()
  123         status = e.rc
  124         db_lock.release()
  125     except GamsException as e:
  126         print(e)
  127         db_lock.acquire()
  128         status = -1
  129         db_lock.release()
  130     except Exception as e:
  131         print(e)
  132         db_lock.acquire()
  133         status = -2
  134         db_lock.release()
  135 
  136 if __name__ == "__main__":
  137     if len(sys.argv) > 1:
  138         ws = GamsWorkspace(system_directory = sys.argv[1])
  139     else:
  140         ws = GamsWorkspace()
  141     
  142     # create a GAMSDatabase for the results
  143     result_db = ws.add_database()
  144     result_db.add_parameter("objrep" ,1 ,"Objective value")
  145     result_db.add_set("supplyMap" ,3 ,"Supply connection with level")
  146     
  147     status_string = ""
  148     status = 0
  149 
  150     try:
  151         # run multiple parallel jobs
  152         db_lock = threading.Lock()
  153         threads = {}
  154         for i in range(10,22):
  155             threads[i] = threading.Thread(target=solve_warehouse, args=(ws, i, result_db, db_lock))
  156             threads[i].start()
  157         for t in threads.values():
  158             t.join()
  159         if status > 0:
  160             raise GamsExceptionExecution("Error when running GAMS: " + str(status) + " " + status_string, status);
  161         elif status == -1:
  162             raise GamsException("Error in GAMS API")
  163         elif status == -2:
  164             raise Exception()
  165 
  166         # export the result database to a GDX file
  167         result_db.export("/tmp/result.gdx")
  168     
  169     except GamsException as e:
  170         print("GamsException occured: " , e)
  171     except Exception as e:
  172         print(e)
  173 
