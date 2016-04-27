/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package javaapplication1;

/*********************************************************
A simple M/M/m/k queue simulation 

This program is submitted by Mohan Lal Jangir 
*********************************************************/


#include <stdio.h> 
#include <stdlib.h> // Needed for rand() and RAND_MAX
#include <math.h> // Needed for log()
#include <iostream.h>

//----- Constants -------------------------------------------------------------
#define SIM_TIME 1.0e7 // Simulation time

//----- Function prototypes ---------------------------------------------------
double expntl(double x); // Generate exponential RV with mean x
double general();

/********************** Main program******************************/
void main(void)
{
for(int i=1;i<=49;i++)
{
double end_time = SIM_TIME; // Total time to simulate
double Ta ; // Mean time between arrivals
double Ts = 2.0; // Mean service time
int m=2; //no of servers
double time = 0.0; // Simulation time
double t1 = 0.0; // Time for next event #1 (arrival)
double t2 = SIM_TIME; // Time for next event #2 (departure)
long int n = 0; // Number of customers in the system
long int k=8; //buffer space
float p;
double c = 0.0; // Number of service completions
double s = 0.0; // Area of number of customers in system
double tn = time; // Variable for "last event time"
double x; // Throughput
double l; // Mean number in the system
double w; // Mean residence time

p=0.02*i; Ta=Ts/(m*p);

// Main simulation loop
while (time < end_time)
{
if (t1 < t2) // *** Event #1 (arrival)
{
time = t1;
s = s + n * (time - tn); // Update area under "s" curve
if(n<k) n++;
tn = time; // tn = "last event time" for next event
t1 = time + expntl(Ta);
if (n == 1)
t2 = time + expntl(Ts);

}
else // *** Event #2 (departure)
{
time = t2;
s = s + n * (time - tn); // Update area under "s" curve
if(n>m)
n-=m; else n=0;
tn = time; // tn = "last event time" for next event
c++; // Increment number of completions
if (n > 0)
t2 = time + expntl(Ts);
else
t2 = end_time;

}
}

x = c / time; // Compute throughput rate
l = s / time; // Compute mean number in system
w = l / x; // Compute mean residence or system time
if(l>0)
cout<<p<<"\t"<<l<<endl;
}


}

/************************************************************************
Function to generate exponentially distributed RVs 
Input: x (mean value of distribution) 
Output: Returns with exponential RV 
*************************************************************************/
double expntl(double x)
{
double z; // Uniform random number from 0 to 1


// Pull a uniform RV (0 < z < 1)
do
{
z = ((double) rand() / RAND_MAX);
}
while ((z == 0) || (z == 1));

return(-x * log(z));
}



