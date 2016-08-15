# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <markdowncell>

# # Accelerating Python code with CUDA on GPUs
# 
# In this self-paced, hands-on lab, we will use CUDA Python to accelerate code on NVIDIA GPUs.
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
#                          time  	: (1471279017530+50*60000-curTime)/1000,
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
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">The following video will explain the infrastructure we are using for this self-paced lab, as well as give some tips on it's usage.  If you've never taken a lab on this system before, it's highly encourage you watch this short video first.
# <div align="center"><iframe width="640" height="390" src="http://www.youtube.com/embed/ZMrDaLSFqpY" frameborder="0" allowfullscreen></iframe></div>
# </div></div></div></p>

# <markdowncell>

# ## Introduction to CUDA Python
# 
# In this lab, we will learn how to write GPU code using Python, one of the fastest growing CUDA enabled languages.  By learning just a few new API calls, we'll be able to unlock the massively parallel capability of an NVIDIA GPU.
# 
# Watch the following short video introduction to Grids, Blocks, and Threads:<br><br>
# 
# <div align="center"><iframe width="640" height="390" src="http://www.youtube.com/embed/KM-zbhyz9f4" frameborder="0" allowfullscreen></iframe></div>
# 
# This lab consists of three tasks that will require you to modify some code and execute it.  For each task, a solution is provided so you can check your work or take a peek if you get lost.
# 
# If you are still confused now, or at any point in this lab, you can consult the <a href="#FAQ">FAQ</a> located at the bottom of this page.

# <markdowncell>

# ## Hello Parallelism
# 
# For the first task, we are going to be using the following concepts:
# 
# * <code style="color:green">@cuda.autojit</code> - this Python function decorator (goes on the line above a function definition) is used to tell the NumbaPro Python compiler that the function is to be compiled for the GPU, and is callable from both the host or the GPU itself.
# * <code style="color:green">cuda.blockIdx.x</code> - this is a read-only variable that is defined for you.  It is used within a GPU kernel to determine the ID of the block which is currently executing code.  Since there will be many blocks running in parallel, we need this ID to help determine which chunk of data that particular block will work on.
# * <code style="color:green">cuda.threadIdx.x</code> - this is a read-only variable that is defined for you.  It is used within a GPU kernel to determine the ID of the thread which is currently executing code in the active block.
# * <code style="color:green">cuda.blockDim.x</code> - this is a read-only variable that is defined for you.  It simply returns a value indicating the number of threads there are per block.  Remember that all the blocks scheduled to execute on the GPU are identical, except for the <code style="color:green">cuda.blockIdx.x</code> value.
# * <code style="color:green">myKernel [ number_of_blocks, threads_per_block ] (...)</code> -  this is the syntax used to launch a kernel on the GPU.  Inside the square brackets we set two values.  The first is the total number of blocks we want to run on the GPU, and the second is the number of threads there are per block.  It's possible, and in fact recommended, for one to schedule more blocks than the GPU can actively run in parallel.  In this case, the system will just continue executing blocks until they have all run.
# 
# Let's explore the above concepts by doing a simple example.
# 
# There is nothing you need to do to the code to get this example to work.  Before you do anything else, select the next cell down and hit Ctrl-Enter (or the play button in the toolbar) to run the code.  If everything is working, you should see the following: <code>[ 0.]</code>

# <codecell>

from numbapro import cuda # Import the CUDA Runtime API
import numpy as np # Import NumPy for creating data arrays

@cuda.autojit
def hello(ary):
    ary[cuda.threadIdx.x] = cuda.threadIdx.x + cuda.blockIdx.x
    
def main():
    threads_per_block = 1
    number_of_blocks = 1
    ary = np.empty(threads_per_block) # Create an array of threads_per_block elements
    hello[number_of_blocks,threads_per_block] (ary)
    
    print ary # Print out the values filled in by the GPU
    
main()

# <markdowncell>

# ### Task #1
# 
# Your first task in this lab is to play around with the number of blocks, and threads per block by modifying the values `threads_per_block` and `number_of_blocks`. To make these changes, simply click on the cell below this one and edit the code.
# 
# * What do you expect to see if you do `number_of_blocks = 2` and `threads_per_block = 1`?
# * What do you expect to see if you do `number_of_blocks = 100` and `threads_per_block = 5`?
# * Can you make the values arbitrarily large?
# 
# After making a change, simply execute the cell with Ctrl-Enter and see the result.

# <codecell>

from numbapro import cuda # Import the CUDA Runtime API
import numpy as np # Import NumPy for creating data arrays

@cuda.autojit
def hello(ary):
    ary[cuda.threadIdx.x] = cuda.threadIdx.x + cuda.blockIdx.x
    
def main():
    threads_per_block = 2
    number_of_blocks = 1
    ary = np.empty(threads_per_block)
    hello[number_of_blocks,threads_per_block] (ary)
    
    print ary # Print out the values filled in by the GPU
    
main()

# <markdowncell>

# Congrats!  You have successfully modified and executed your first program on the GPU!
# 
# Besides just getting our hands dirty compiling and executing code on the GPU, task1 was meant to enforce a fundamental principle.  If you set the number of threads per block to 5 and the number of blocks to 100, you should have noticed the values printed at the end were not from the last block - some randomness started to creep in.  The reason for this is we're executing these blocks & threads on a massively parallel GPU.  So there will be 100's if not 1000's of threads all executing simultaneously with respect to each other.  It's basically a race condition to see which block or threads got to write their values to our array first.
# 
# In a more realistic example, like we'll work on below, we need to ensure there is enough memory allocated to hold the results from all our threads.

# <markdowncell>

# ### Task #2
# 
# For our second task, we're going to be accelerating the ever popular SAXPY (**S**ingle-precision **A** times **X** **P**lus **Y**) function on the GPU using CUDA.
# 
# Unlike Task #1, you are going to have to do some of work yourself!  In this example, the `saxpy` function has already been moved to the GPU, but it expects three arrays, `a`, `b`, and, `c`, to be passed to it.  So we need to handle getting the three arrays to the GPU version of `saxpy`.
# 
# It is important to realize here that the GPU has it's own physical memory, just like the CPU uses system RAM for it's memory.  When executing code on the GPU, we have to ensure any data it needs is first copied across the PCI-Express bus to the GPU's memory before we launch the `saxpy` kernel.  For this task, we will manage the GPU memory with the following API calls (detailed documentation [here](http://docs.continuum.io/numbapro/CUDAJit.html#memory-transfer)).  It should also be noted that CUDA Python makes heavy use of NumPy's N-dimensional array objects.  You do not need an understanding of NumPy to work on this lab, but if you're interested in reading more, you can start [here](http://www.numpy.org/).
# 
# * `d_ary = cuda.to_device(ary)` - this API call is used to allocate and copy memory to the GPU.  After it completes successfully, d_ary will point to a copy of the NumPy array data on the GPU.
# * `d_ary = cuda.device_array(number_of_elements)` - this API call creates an empty NumPy array on the GPU of size number_of_elements
# * `d_ary.copy_to_host(ary)` - this API call will copy the data in d_ary which is on the GPU, to the NumPy array on the host
# 
# You may have noticed in Task #1, the NumbaPro compiler was smart enough to handle transferring the `ary` data itself.  For this task, we'll be doing it manually so you are aware of how it's done.
# 
# In the cell below, your objective is to replace the `## FIXME: ... ##` sections of code. Using the above calls, move the data to the GPU before the `saxpy` function is called, as well as copy the resulting `c` array back.  
# 
# To make sure you are getting the correct answer, the program prints out the first 5 and last 5 elements of `c`.  If everything was done correctly, the values should all be **5**.  The cells to compile and execute the program are located below the editor.  If you get stuck, there are a number of hints provided - just click on the green box to see what they are.
# 
# Finally, you can click the green solution box below the code to check your work.

# <markdowncell>

# <p class="hint_trigger">Hint #1
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">To figure out the number_of_blocks, we want to divide the number of elements we're processing, by the number of threads_per_block.</div></div></div></p>

# <markdowncell>

# <p class="hint_trigger">Hint #2
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">A kernel running on the GPU (indicated with <code>@cuda.autojit</code>) decorator cannot use host arrays, so make sure you are passing the device arrays into the <code>saxpy</code> function.</div></div></div></p>

# <codecell>

from numbapro import cuda
import numpy as np

@cuda.autojit
def saxpy(a, b, c):
    # Determine our unique global thread ID, so we know which element to process
    tid = cuda.blockIdx.x * cuda.blockDim.x + cuda.threadIdx.x;

    if ( tid < c.size ): # Make sure we don't do more work than we have data!
        c[tid] = 2 * a[tid] + b[tid];

def main():
    N = 2048 * 2048

    # Allocate host memory arrays
    a = np.empty(N)
    b = np.empty(N)
    c = np.empty(N)

    # Initialize host memory
    a.fill(2)
    b.fill(1)
    c.fill(0)

    # Allocate and copy GPU/device memory
    d_a = cuda.to_device(a)
    d_b = cuda.to_device(b)
    d_c = cuda.to_device(c)

    threads_per_block = 128
    number_of_blocks = N / 128 + 1

    saxpy [ number_of_blocks, threads_per_block ] ( d_a, d_b, d_c )

    d_c.copy_to_host(c)

    # Print out the first and last 5 values of c for a quality check
    print c[:5]
    print c[-5:]

main() # Execute the program

# <markdowncell>

# <p class="hint_trigger">Click to check your solution
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\"><pre>from numbapro import cuda
# import numpy as np
# 
# @cuda.autojit
# def saxpy(a, b, c):
#     # Determine our unique global thread ID, so we know which element to process
#     tid = cuda.blockIdx.x &#42; cuda.blockDim.x + cuda.threadIdx.x;
#     
#     if ( tid &lt; c.size ): # Make sure we don't do more work than we have data!
#         c[tid] = 2 &#42; a[tid] + b[tid];
# 
# def main():
#     N = 2048 * 2048
# 
#     # Allocate host memory arrays
#     a = np.empty(N)
#     b = np.empty(N)
#     c = np.empty(N)
# 
#     # Initialize host memory
#     a.fill(2)
#     b.fill(1)
#     c.fill(0)
# 
#     # Allocate and copy GPU/device memory
#     d_a = cuda.to_device(a)
#     d_b = cuda.to_device(b)
#     d_c = cuda.to_device(c)
# 
#     threads_per_block = 128
#     number_of_blocks = N / 128 + 1
# 
#     saxpy [ number_of_blocks, threads_per_block ] ( d_a, d_b, d_c )
# 
#     d_c.copy_to_host(c)
# 
#     # Print out the first and last 5 values of c for a quality check
#     print c[:5]
#     print c[-5:]
#     
# main() # Execute the program</pre></div></div></div></p>

# <markdowncell>

# The output of your program should be all 5's.  If you got this, you have successfully done the following:
# 
# 1. Allocated space in GPU memory
# 2. Copied data from the CPU to the GPU
# 3. Launched the `saxpy` function on the GPU
# 4. Copied the resulting data back to the CPU
# 
# If you are still not able to get the correct output, please have a look at the solution hidden in the green box above and see if you can figure out what you were missing!

# <markdowncell>

# ### Task #3
# 
# Your final task in this lab will be to accelerate a basic matrix multiplication function on the GPU.  In this simplified example, we'll assume our matrices are all square - they have the same number of rows and columns.
# 
# In this task, all the data movement has already been completed for you.  Your goal is to modify the `matrixMulGPU` function with CUDA so it will run on the GPU.  However, there is a new twist!  Instead of just using one-dimensional blocks of threads and blocks, we'll be using two dimensions; x and y.  In the `main` function of Task #3, these are set with the following:
# 
#     threads_per_block = (16, 16) # A 16 x 16 block threads
#     number_of_blocks = ((N / threads_per_block[0]) + 1, (N / threads_per_block[1]) + 1)
#     
# So, in addition to using `cuda.blockIdx.x`, `cuda.blockDim.x`, and `cuda.threadIdx.x`, you'll also need to use <code>cuda.blockIdx.<span style="color:orange">**y**</span></code>, <code>cuda.blockDim.<span style="color:orange">**y**</span></code>, and <code>cuda.threadIdx.<span style="color:orange">**y**</span></code>. As usual, please make use of the hints provided if you get stuck, and you can always check the green box below the code to see the answer.
# 
# **Note**: do not modify the CPU version `matrixMulCPU`.  This is used to verify the results of the GPU version.

# <markdowncell>

# <p class="hint_trigger">Hint #1
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">You only need to modify the `matrixMulGPU` function.  No other code needs to be modified for this task.</div></div></div></p>

# <markdowncell>

# <p class="hint_trigger">Hint #2
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">You'll be using a single thread to calculate one element of the output matrix `c`.  Each thread will execute the inner-most loop of the matrix multiplication formula.</div></div></div></p>

# <markdowncell>

# <p class="hint_trigger">Hint #3
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">The `row` value should be set to `cuda.blockIdx.x * cuda.blockDim.x + cuda.threadIdx.x` to get the thread which is calculating the row part of the `c` matrix.  Can you figure out what the `col` value should be set to?</div></div></div></p>

# <markdowncell>

# <p class="hint_trigger">Hint #4
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">Don't forget the `@cuda.autojit` function decorator to tell the compiler that `matrixMulGPU` is now a GPU function!</div></div></div></p>

# <markdowncell>

# <p class="hint_trigger">Hint #5
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\">Just like the CPU version, we need to make sure we do not do more work than we have data.  In this example, the `main` function is actually launching `matrixMulGPU` with more blocks of threads than we have data.  Make sure you're doing a check in your modified code so that `row` **and** `col` are less than N.</div></div></div></p>

# <codecell>

from numbapro import cuda
import numpy as np

N = 64

@cuda.autojit
def matrixMulGPU( a, b, c ):
    val = 0

    row = cuda.blockIdx.x * cuda.blockDim.x + cuda.threadIdx.x
    col = cuda.blockIdx.y * cuda.blockDim.y + cuda.threadIdx.y

    if (row < N and col < N):
        for k in range(N):
            val += a[row,k] * b[k,col]
        c[row,col] = val

def matrixMulCPU( a, b, c ):
    for row in range(N):
        for col in range(N):
            val = 0
            for k in range(N):
                val += a[row,k] * b[k,col]
            c[row,col] = val

def main():
    # Allocate host memory
    a = np.empty([N,N], dtype=np.float32)
    b = np.empty_like(a)
    c_cpu = np.empty_like(a)
    c_gpu = np.empty_like(a)

    # Initialize host memory
    for row in range(N):
        for col in range(N):
            a[row,col] = row
            b[row,col] = col+2
            c_cpu[row,col] = 0
            c_gpu[row,col] = 0

    # Allocate and initialize GPU/device memory
    d_a = cuda.to_device(a)
    d_b = cuda.to_device(b)
    d_c = cuda.to_device(c_gpu) # since we're overwriting c on the GPU in 
                                # the matrixMul kernel, no need to copy data over

    threads_per_block = (16, 16) # A 16 x 16 block threads
    number_of_blocks = ((N / threads_per_block[0]) + 1, (N / threads_per_block[1]) + 1)

    matrixMulGPU [ number_of_blocks, threads_per_block ] ( d_a, d_b, d_c )

    d_c.copy_to_host(c_gpu)

    # Call the CPU version to check our work
    matrixMulCPU( a, b, c_cpu )

    # Compare the two answers to make sure they are equal
    error = False
    for row in range(N):
        if error:
            break
        for col in range(N):
            if error:
                break
            if c_cpu[row,col] != c_gpu[row,col]:
                print "FOUND ERROR at c[" + str(row) + "," + str(col) + "]"
                error = True

    if not error:
        print "Success!"

main() # Run the program

# <markdowncell>

# <p class="hint_trigger">Click to check your solution
#       <div class="toggle_container"><div class="input_area box-flex1"><div class=\"highlight\"><pre>from numbapro import cuda
# import numpy as np
# 
# N = 64
# 
# @cuda.autojit
# def matrixMulGPU( a, b, c ):
#     val = 0
# 
#     row = cuda.blockIdx.x &#42; cuda.blockDim.x + cuda.threadIdx.x
#     col = cuda.blockIdx.y &#42; cuda.blockDim.y + cuda.threadIdx.y
# 
#     if (row &lt; N and col &lt; N):
#         for k in range(N):
#             val += a[row,k] &#42; b[k,col]
#         c[row,col] = val
# 
# def matrixMulCPU( a, b, c ):
#     for row in range(N):
#         for col in range(N):
#             val = 0
#             for k in range(N):
#                 val += a[row,k] &#42; b[k,col]
#             c[row,col] = val
# 
# def main():
#     # Allocate host memory
#     a = np.empty([N,N], dtype=np.float32)
#     b = np.empty_like(a)
#     c_cpu = np.empty_like(a)
#     c_gpu = np.empty_like(a)
# 
#     # Initialize host memory
#     for row in range(N):
#         for col in range(N):
#             a[row,col] = row
#             b[row,col] = col+2
#             c_cpu[row,col] = 0
#             c_gpu[row,col] = 0
# 
#     # Allocate and initialize GPU/device memory
#     d_a = cuda.to_device(a)
#     d_b = cuda.to_device(b)
#     d_c = cuda.to_device(c_gpu) # since we're overwriting c on the GPU in 
#                                 # the matrixMul kernel, no need to copy data over  
# 
#     threads_per_block = (16, 16) # A 16 x 16 block threads
#     number_of_blocks = ((N / threads_per_block[0]) + 1, (N / threads_per_block[1]) + 1)
# 
#     matrixMulGPU [ number_of_blocks, threads_per_block ] ( d_a, d_b, d_c )
# 
#     d_c.copy_to_host(c_gpu)
# 
#     # Call the CPU version to check our work
#     matrixMulCPU( a, b, c_cpu )
# 
#     # Compare the two answers to make sure they are equal
#     error = False
#     for row in range(N):
#         if error:
#             break
#         for col in range(N):
#             if error:
#                 break
#             if c_cpu[row,col] != c_gpu[row,col]:
#                 print "FOUND ERROR at c[" + str(row) + "," + str(col) + "]"
#                 error = True
# 
#     if not error:
#         print "Success!"
#         
# main() # Run the program</pre></div></div></div></p>

# <markdowncell>

# If you get Task #3 to run without any errors, you have successfully taken a serial function and moved it to a massively parallel version on the GPU!

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

