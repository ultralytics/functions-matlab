//purpose:  Generates isotropic unit vectors
//inputs:   rows, numbe of vectors to make
//outputs:  A (nx3)
//example:  A = isovecs(50);  makes 50 isotropic unit vectors
//Methods found in http://mathworld.wolfram.com/SpherePointPicking.html
    
#include <math.h>
#include "mex.h"
#include <iostream>
#include <random>

void cfunction(double mu, int* number, int MN)
{
    int i;
    unsigned seed = rand();
    std::default_random_engine generator (seed);;
    std::poisson_distribution<int> distribution(mu);

    for (i=0; i<MN; i++){number[i] = distribution(generator);}

    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *dims; //outputs
    int  *A, MN, i, nd, *d; //number of dimensions and dimension vector
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<1)  mexErrMsgTxt("too few inputs");
    if (!mxIsDouble(prhs[0])) mexErrMsgTxt("poissrndc.cpp: inputs must be double");
   
    MN=1;
    if(nrhs==1){
        nd = 2;  d = (int*) calloc(nd, sizeof(int));  *d=1;  d[1]=1;}
    else //second input is size
    {
        dims = (double*)mxGetPr(prhs[1]);
        nd = mxGetNumberOfElements(prhs[1]);
        d = (int*) calloc(nd, sizeof(int));  *d=dims[0];  for(i=1; i<nd; i++){d[i]=dims[i];}
        for(i=0; i<nd; i++){MN=MN*dims[i];}
    }
    plhs[0] = mxCreateNumericArray(nd, d, mxUINT32_CLASS, mxREAL);      A = (int*)mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    cfunction((double)* mxGetPr(prhs[0]), A, MN);
    return;
}