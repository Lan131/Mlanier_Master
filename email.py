#http://www.pythonforbeginners.com/files/reading-and-writing-files-in-python
import smtplib
import os
import numpy as np
 
def sendemail(from_addr, to_addr_list, cc_addr_list,
              subject, message,
              login, password,
              smtpserver='smtp.gmail.com:587'):
    header  = 'From: %s\n' % from_addr
    header += 'To: %s\n' % ','.join(to_addr_list)
    header += 'Cc: %s\n' % ','.join(cc_addr_list)
    header += 'Subject: %s\n\n' % subject
    message = header + message
 
    server = smtplib.SMTP(smtpserver)
    server.starttls()
    server.login(login,password)
    problems = server.sendmail(from_addr, to_addr_list, message)
    server.quit()
    return problems
    
    
    sendemail(from_addr    = 'python@RC.net', 
          to_addr_list = ['RC@gmail.com'],
          cc_addr_list = ['RC@xx.co.uk'], 
          subject      = 'Howdy', 
          message      = 'Howdy from a python function', 
          login        = 'pythonuser', 
          password     = 'XXXXX')
          
          
          
          
files = [f for f in os.listdir('.') if os.path.isfile(f)]
most_current= max(os.path.getmtime())

