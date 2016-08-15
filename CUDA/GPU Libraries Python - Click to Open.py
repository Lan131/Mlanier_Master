# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <markdowncell>

# # Accelerating Python code with Libraries on GPUs
# 
# In this self-paced, hands-on lab, we will use GPU libraries to accelerate Python code on NVIDIA GPUs.
# 
# Lab created by Mark Ebersole (Follow [@CUDAHamster](https://twitter.com/@cudahamster) on Twitter)

# <markdowncell>

# The following timer counts down to a five minute warning before the lab instance shuts down.  You should get a pop up at the five minute warning reminding you to save your work!

# <markdowncell>

# <script src="files/countdown_v5.0/countdown.js"></script>
# <div id="clock" align="center"></div>
# <script>
# myDate = new Date();
# curTime = Date.UTC(myDate.getUTCFullYear(), 
#                    myDate.getUTCMonth(), 
#                    myDate.getUTCDate(), 
#                    myDate.getUTCHours(), 
#                    myDate.getUTCMinutes(),
#                    myDate.getUTCSeconds(),
#                    myDate.getUTCMilliseconds());
# 
# function countdownComplete(){
#   	alert("You only have five minutes left in the lab! Time to save your work - see the Post Lab section near the bottom.");
# }
# var myCD = new Countdown({
#                          time  	: (1471276901936+50*60000-curTime)/1000,
#                          target	 	: "clock",
#                          onComplete	: countdownComplete,
#                          rangeHi  : "minute",
#                          hideLine	: true,
#                          hideLabels	: false,
#                          height	 	: 60,
#                          width     : 150,
#                          style     : "boring",
#                     });
#  </script>

# <markdowncell>

# ---
# Before we begin, let's verify [WebSockets](http://en.wikipedia.org/wiki/WebSocket) are working on your system.  To do this, execute the cell block below by giving it focus (clicking on it with your mouse), and hitting Ctrl-Enter, or pressing the play button in the toolbar above.  If all goes well, you should see get some output returned below the grey cell.  If not, please consult the [Self-paced Lab Troubleshooting FAQ](https://developer.nvidia.com/self-paced-labs-faq#Troubleshooting) to debug the issue.

# <codecell>

print "The answer should be three: " + str(1+2)

# <markdowncell>

# Let's execute the cell below to display information about the GPUs running on the server.

# <codecell>

!nvidia-smi

# <markdowncell>

# ---
# <p class="hint_trigger">If you have never before taken an IPython Notebook based self-paced lab from NVIDIA, click this green box.
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">The following video will explain the infrastructure we are using for this self-paced lab, as well as give some tips on it's usage.  If you've never taken a lab on this system before, it's highly encourage you watch this short video first.<br><br>
# <div align="center"><iframe width="640" height="390" src="http://www.youtube.com/embed/ZMrDaLSFqpY" frameborder="0" allowfullscreen></iframe></div>
# <br>
# <h2 style="text-align:center;color:red;">Attention Firefox Users</h2><div style="text-align:center; margin: 0px 25px 0px 25px;">There is a bug with Firefox related to setting focus in any text editors embedded in this lab. Even though the cursor may be blinking in the text editor, focus for the keyboard may not be there, and any keys you press may be applying to the previously selected cell.  To work around this issue, you'll need to first click in the margin of the browser window (where there are no cells) and then in the text editor.  Sorry for this inconvenience, we're working on getting this fixed.</div></div></div></div></p>

# <markdowncell>

# ## Introduction to GPU Libraries
# 
# Let's get started! The following Python code is a simple Monte Carlo pricer in which the step function has been vectorized using the NumbaPro compiler to run on the GPU.  Without modifying the code, execute and verify the cell runs successfully - select the cell with your mouse and use Ctrl-Enter or the Play button on the toolbar to do this.
# 
# **NOTE:** The point of this lab will focus on the implementation of the `montecarlo` function only.  However, we'll be using code imported from a mc.py file which includes the `driver` and GPU-accelerated `step` function.  While it's not necessary to see or understand this code, there is a cell located at the bottom of this lab that will show you the code if you're interested, although I encourage you to finish the lab first.
# 
# You can also consult the <a href="#FAQ">FAQ</a> located at the bottom of this page.

# <codecell>

from mc import *  # Import our support functions

# Inputs:
#   paths - a 100x3000000 array to store the 100 time steps of prices for each 3,000,000 paths
#   dt - A constant value needed in the Monte Carlo algorithm
#   interest - A constant value needed in the Monte Carlo algorithm
#   volatility - A constant value needed in the Monte Carlo algorithm
def montecarlo(paths, dt, interest, volatility):
    # c0 and c1 are two constants we need for the step calculation
    c0 = interest - 0.5 * volatility ** 2
    c1 = volatility * np.sqrt(dt)
    
    for j in xrange(1, paths.shape[1]):   # for each time step
        prices = paths[:, j - 1]          # last set of prices
        # Generate gaussian noises for simulation
        noises = np.random.normal(0., 1., prices.size)
        # Call the GPU-acclereated step function to calculate the next set of prices
        paths[:, j] = step(prices, dt, c0, c1, noises)

driver(montecarlo, do_plot=True) # Call the driver function to start the calcuations

# <markdowncell>

# When looking to speed-up code by moving portions to an accelerator, it's very important not to guess at what you think should be optimized first.  When I first looked at this code, I assumed the bottleneck would be data transfer across the PCI-Express bus before and after the `step` function was executed on the GPU.
# 
# Now, while guessing that data movement is the main bottleneck to performance in our code is a good guess, it's better to profile the code and see what's really going on.  It's an all too common mistake for people to spend lots of time trying to optimize the wrong piece of code.  Let's not make that same mistake, and we'll use some handy Python tools to profile our code.
# 
# We're going to use [cProfile](http://docs.python.org/2/library/profile.html#module-cProfile) to do this.  Given how simple this is, you won't have to do any work other than just executing the below cell.

# <codecell>

import cProfile as profile
profile.run("driver(montecarlo)", sort="time")

# <markdowncell>

# If you scroll to the top of the list of calls, the function dominating the runtime is not data movement between the device and host, it is the NumPy `random.normal` function used to generate random noise used in the `step` call.  Over half of the application runtime is spent simply generating random noise.
# 
# It so happens that the GPU is extremely efficient at generating large quantities of random data very rapidly.  In fact, there even exists a handy library for doing this called [cuRAND](https://developer.nvidia.com/cuRAND).  Since we've already moved some of our execution to the GPU (the `step` function), let's try moving a little bit more over and see what kind of speedup we can get.
# 
# The cuRAND library is included with the NumbaPro compiler under the numbapro.cudalib package.  Execute the below cell to import the library into our runtime.

# <codecell>

from numbapro.cudalib import curand

# <markdowncell>

# ### Task #1
# 
# Your first task in this lab is to modify the `montecarlo` function to use the cuRAND library to generate the noise values for our algorithm on the GPU.  The documentation for this in Python using NumbaPro can be found [here](http://docs.continuum.io/numbapro/cudalib.html).  There are hints provided if you get stuck, and the answer is given below for you to check your work.  
# 
# After you have modified the `montecarlo_curand` function below, run the application with the new function and/or use the cProfiler to see what kind of speedup has been achieved.
# 
# <p class="hint_trigger">Hint #1
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight">You will first use the cuRAND PRNG function to create a random number generator.</div></div></div></p>
# 
# <p class="hint_trigger">Hint #2
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight">For this exercise, don't worry about returning data in a CUDA Device Array; instead use a basic NumPy array.  You can create an empty one with:<pre>
# <code>noises = np.zeros(paths.shape[0], dtype=float)</code></pre></div></div></div></p>
# 
# <p class="hint_trigger">Hint #3
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight">Once you have a NumPy array to store the generated values in and have created a PRNG generator, use the <code>normal</code> function to actually generate the values on the GPU.</div></div></div></p>
# 
# <p class="hint_trigger">Hint #4
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight">There is no need to modify the <code>step</code> function call.</div></div></div></p>

# <codecell>

def montecarlo_curand(paths, dt, interest, volatility):
    c0 = interest - 0.5 * volatility ** 2
    c1 = volatility * np.sqrt(dt)

    prng = curand.PRNG(rndtype=curand.PRNG.XORWOW)
    noises = np.zeros(paths.shape[0], dtype=float)

    for j in xrange(1, paths.shape[1]):   # for each time step
        prices = paths[:, j - 1]          # last set of prices
        # Generate gaussian noises for simulation
        prng.normal(noises, 0., 1.)
        # Call the GPU-acclereated step function to calculate the next set of prices
        paths[:, j] = step(prices, dt, c0, c1, noises)

# <markdowncell>

# <p class="hint_trigger">Click to check your answer
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight"><pre><code>def montecarlo_curand(paths, dt, interest, volatility):
#     c0 = interest - 0.5 &#42; volatility ** 2
#     c1 = volatility &#42; np.sqrt(dt)
# 
#     prng = curand.PRNG(rndtype=curand.PRNG.XORWOW)
#     noises = np.zeros(paths.shape[0], dtype=float)
#     
#     for j in xrange(1, paths.shape[1]):   # for each time step
#         prices = paths[:, j - 1]          # last set of prices
#         # Generate gaussian noises for simulation
#         prng.normal(noises, 0., 1.)
#         # Call the GPU-acclereated step function to calculate the next set of prices
#         paths[:, j] = step(prices, dt, c0, c1, noises)</code></pre></div></div></div></p>

# <markdowncell>

# After modifying and executing the cell above to add the `montecarlo_curand` function to our runtime, execute the below cell to see how it affects our Monte Carlo pricing simulation.

# <codecell>

driver(montecarlo_curand, do_plot=True)

# <markdowncell>

# By simply replacing the random number generator with a host side GPU library call to cuRAND, our application has achieved a major speedup.  In my case it was **9.6x** over the version we started with at the beginning of this lab, and we only added or modified four lines of code to get it. 
# 
# Let's now re-run the profiler and see how things have changed.

# <codecell>

profile.run("driver(montecarlo_curand)", sort="time")

# <markdowncell>

# At this point, the top time consuming areas are the host_to_device and device_to_host function calls.  This is the PCI-Express data movement we originally thought was the top culprit.  We can now look at optimizing these areas, and this will be your goal for Task #2.
# 
# ### Task #2
# 
# In this task, we will make use of the CUDA Runtime library to optimize some data movement between the host (CPU) and the device (GPU).  The first thing we need to is import this library into our runspace - we can do this by executing the next cell.

# <codecell>

from numbapro import cuda

# <markdowncell>

# **IMPORTANT NOTE:** Once you start manually managing the data involved in a `'gpu'` targeted vectorized function such as our `step` function, the NumbaPro compiler assumes you'll be handling **ALL** of the device data movement.  This means any variables of type `DeviceNDArray` passed in to or returned from the `step` function need to be explicitly passed between the host and GPU using CUDA Runtime API calls.  So while we will be optimizing our `montecarlo` function in stages, we won't be able to actually test these stages until the very end.
# 
# ### Generate and Leave Random Noise Values on the GPU
# 
# The first source of excessive data movement across the PCI-Express bus we are going to fix is the generation of the `noises` data.  The current process is this:
# 
# 1. Call `prng.normal` to generate the random data
# 2. The cuRAND library uses the GPU to generate the data which is temporarily stored on the GPU
# 3. The library then copies the data from the GPU to the host copy of `noises`
# 4. When the `montecarlo` function calls the GPU-accelerated `step` function, the `noises` data is passed *back* across the PCIE bus to be used on the GPU
# 
# So we have two excessive copies of `NumPaths` worth of data across the PCI-Express bus.  Let's fix that.  The [documentation](http://docs.continuum.io/numbapro/cudalib.html) for cuRAND says the prng.normal function can accept either a host or a device array.  So the new process needed is this:
# 
# 1. Allocate an empty `DeviceNDArray` on the GPU using the `cuda.device_array` API call (see the [documentation](http://docs.continuum.io/numbapro/CUDAJit.html#memory-transfer)).
# 2. Change the `prng.normal` call to accept this new array.
# 3. Modify the `step` funtion call to use this device side array.
# 
# Perform these steps in the below cell and execute the cell to check for syntax errors.  If you get stuck, you can look ahead to the next section as the work has been completed there.
# 
# **TIP:** It's good practice to precede the variable name of any device-side arrays with `d_`

# <codecell>

def montecarlo_datamgmt(paths, dt, interest, volatility):
    c0 = interest - 0.5 * volatility ** 2
    c1 = volatility * np.sqrt(dt)

    prng = curand.PRNG(rndtype=curand.PRNG.XORWOW)
    noises = np.zeros(paths.shape[0], dtype=float)

    for j in xrange(1, paths.shape[1]):   # for each time step
        prices = paths[:, j - 1]          # last set of prices
        # Generate gaussian noises for simulation
        prng.normal(noises, 0., 1.)
        # Call the GPU-acclereated step function to calculate the next set of prices
        paths[:, j] = step(prices, dt, c0, c1, noises)

# <markdowncell>

# ### Optimize current and generated `prices` Data Transfers
# 
# The next data transfers to optimize has to do with sending the current set of stock prices to the GPU and returning the calculated set of next prices back to the host.  This is the current process:
# 
# 1. Within the `for` loop, we set `prices` equal to the current or known set of stock prices, which is stored in `paths[:, j - 1]`
# 2. The `prices` array is then sent to the GPU when the `step` function is called
# 3. The GPU executes the `step` function and generates the next set of stock prices
# 4. This new set of stock prices is then transferred back to the host and stored in `paths[:, j]`
# 5. The `for` loop starts over and the next set of stock prices, which we just copied from the GPU->host, becomes our current set of stock prices and are then transferred **back** to the GPU and the process repeats
# 
# So in this process, we have an extra transfer of `NumPaths` number of price data across the PCIE bus in all but the first time through the `for` loop.  When we call `step` to generate the new stock prices, the data is already on the GPU, so we can optimize by using this data instead of having to re-copy it back from the host each time.  
# 
# There are a few ways to do this, see what you can come up with by modifying the cell below.  If done correctly, this will be the final step in optimizing the data transfers in our `montecarlo_datamgmt` function.  So when you are done, you can execute the function and see if you get the correct results.  There are hints provided as well as the final answer hidden below the cell.
# 
# <p class="hint_trigger">Hint #1
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight">You can swap two variables in Python quickly with <code>x, y = y, x</code></div></div></div></p>
# 
# <p class="hint_trigger">Hint #2
#     <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight">The <code>step</code> function call should only work with device arrays, it should not reference the <code>paths</code> array either in its arguments or in what it returns</div></div></div></p>

# <codecell>

def montecarlo_datamgmt(paths, dt, interest, volatility):
    c0 = interest - 0.5 * volatility ** 2
    c1 = volatility * np.sqrt(dt)

    prng = curand.PRNG(rndtype=curand.PRNG.XORWOW)
    d_noises = cuda.device_array(paths.shape[0])

    d_curLast = cuda.to_device(paths[:,0]) # Copy first set of stock prices to the GPU
    d_curNext = cuda.device_array(paths.shape[0]) # Create an empty array to hold the next set of calculated prices

    for j in xrange(1, paths.shape[1]):   # for each time step
        # Generate gaussian noises for simulation
        prng.normal(d_noises, 0., 1.)
        # Call the GPU-acclereated step function to calculate the next set of prices
        d_curNext = step(d_curLast, dt, c0, c1, d_noises)
        # Copy calculated prices to host
        d_curNext.copy_to_host(paths[:,j])
        # Swap the prices so the "last" prices was the one we just copied 
        # to the host.
        d_curNext, d_curLast = d_curLast, d_curNext

# <markdowncell>

# <p class="hint_trigger">Click to check your answer
# <div class="toggle_container"><div class="input_area box-flex1"><div class="highlight"><pre><code>def montecarlo_datamgmt(paths, dt, interest, volatility):
#     c0 = interest - 0.5 &#42; volatility ** 2
#     c1 = volatility &#42; np.sqrt(dt)
# 
#     prng = curand.PRNG(rndtype=curand.PRNG.XORWOW)
#     d_noises = cuda.device_array(paths.shape[0])
#     
#     d_curLast = cuda.to_device(paths[:,0]) # Copy first set of stock prices to the GPU
#     d_curNext = cuda.device_array(paths.shape[0]) # Create an empty array to hold the next set of calculated prices
# 
#     for j in xrange(1, paths.shape[1]):   # for each time step
#         # Generate gaussian noises for simulation
#         prng.normal(d_noises, 0., 1.)
#         # Call the GPU-acclereated step function to calculate the next set of prices
#         d_curNext = step(d_curLast, dt, c0, c1, d_noises)
#         # Copy calculated prices to host
#         d_curNext.copy_to_host(paths[:,j])
#         # Swap the prices so the "last" prices was the one we just copied 
#         # to the host.
#         d_curNext, d_curLast = d_curLast, d_curNext</code></pre></div></div></div></p>

# <markdowncell>

# Once you have successfully got the new `montecarlo_datamgmt` function working, you can profile it below and see what our optimizations have achieved.

# <codecell>

import cProfile as profiler
profiler.run("driver(montecarlo_datamgmt)", sort="time")

# <markdowncell>

# At this point, using only host side library calls (cuRAND, and CUDA Runtime) - we did not write any GPU-side CUDA Python code - my system showed a 23x speedup over the pure single-threaded CPU version using NumPy.  This is even more impressive when you consider this simple Monte Carlo pricer is very computationally light and barley makes use of the massive parallel power of the GPU.  All of this and we only added or modified less than 10 lines of code.
# 
# In addition, there are further optimizations to be had in this application.  Such as overlapping memory transfers and computations and running concurrent kernels on the GPU at the same time - like generating the next set of `noises` data concurrently with the GPU calculating the next set of stock prices.

# <markdowncell>

# Finally, if you wish to see the supporting functions used in this lab to run the Monte Carlo simulation, just execute the cell below.

# <codecell>

%load mc.py

# <codecell>

import numpy as np                         # numpy namespace
from timeit import default_timer as timer  # for timing
from matplotlib import pyplot              # for plotting
import math
from numbapro import vectorize

@vectorize(['float64(float64, float64, float64, float64, float64)'], target='gpu')
def step(price, dt, c0, c1, noise):
    return price * math.exp(c0 * dt + c1 * noise)

# Stock information parameters
StockPrice = 20.83
StrikePrice = 21.50
Volatility = 0.021
InterestRate = 0.20
Maturity = 5. / 12.

# monte-carlo simulation parameters
NumPath = 3000000
NumStep = 100

# plotting
MAX_PATH_IN_PLOT = 50

def driver(pricer, do_plot=False):
    paths = np.zeros((NumPath, NumStep + 1), order='F')
    paths[:, 0] = StockPrice
    DT = Maturity / NumStep

    ts = timer()
    pricer(paths, DT, InterestRate, Volatility)
    te = timer()
    elapsed = te - ts

    ST = paths[:, -1]
    PaidOff = np.maximum(paths[:, -1] - StrikePrice, 0)
    print 'Result'
    fmt = '%20s: %s'
    print fmt % ('stock price', np.mean(ST))
    print fmt % ('standard error', np.std(ST) / np.sqrt(NumPath))
    print fmt % ('paid off', np.mean(PaidOff))
    optionprice = np.mean(PaidOff) * np.exp(-InterestRate * Maturity)
    print fmt % ('option price', optionprice)

    print 'Performance'
    NumCompute = NumPath * NumStep
    print fmt % ('Mstep/second', '%.2f' % (NumCompute / elapsed / 1e6))
    print fmt % ('time elapsed', '%.3fs' % (te - ts))
    
    if do_plot:
        pathct = min(NumPath, MAX_PATH_IN_PLOT)
        for i in xrange(pathct):
            pyplot.plot(paths[i])
        print 'Plotting %d/%d paths' % (pathct, NumPath)
        pyplot.show()

# <markdowncell>

# ## Learn More
# 
# If you are interested in learning more, you can use the following resources:
# 
# * Learn more at the [CUDA Developer Zone](https://developer.nvidia.com/category/zone/cuda-zone).
# * Install [Anaconda Accelerate](https://store.continuum.io/cshop/accelerate/) from Continuum Analytics.  You can also watch the [CUDACast](http://www.youtube.com/watch?v=jKV1m8APttU) on this process.
# * Take the fantastic online and **free** Udacity [Intro to Parallel Programming](https://www.udacity.com/course/cs344) course which uses CUDA C.
# * Search or ask questions on [Stackoverflow](http://stackoverflow.com/questions/tagged/cuda) using the cuda tag

# <markdowncell>

# <a id="post-lab"></a>
# ## Post-Lab
# 
# Finally, don't forget to save your work from this lab before time runs out and the instance shuts down!!
# 
# 1. Save this IPython Notebook by going to `File -> Download as -> IPython (.ipynb)` at the top of this window

# <markdowncell>

# <a id="FAQ"></a>
# ---
# # Lab FAQ
# 
# Q: I'm encountering issues executing the cells, or other technical problems?<br>
# A: Please see [this](https://developer.nvidia.com/self-paced-labs-faq#Troubleshooting) infrastructure FAQ.

# <markdowncell>

# <style>
# p.hint_trigger{
#   margin-bottom:7px;
#   margin-top:-5px;
#   background:#64E84D;
# }
# .toggle_container{
#   margin-bottom:0px;
# }
# .toggle_container p{
#   margin:2px;
# }
# .toggle_container{
#   background:#f0f0f0;
#   clear: both;
#   font-size:100%;
# }
# </style>
# <script>
# $("p.hint_trigger").click(function(){
#    $(this).toggleClass("active").next().slideToggle("normal");
# });
#    
# $(".toggle_container").hide();
# </script>

