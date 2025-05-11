// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  Finds the bsx ranges between two sets of 2D or 3D vectors A and B
//inputs:   A (nx3), optional B (mx3)
//outputs:  range (nxm), range^2 (nxm), dx (nxm), dy (nxm), dz (nxm)
//example:  [r,rs,dx,dy,dz] = rangec(A,B)

#include <math.h>
#include "mex.h"
void cfunction(double* x, double* lims, double* A, int MN1)
{
    int i;
    double lower, upper, xi;
    lower = lims[0];
    upper = lims[1];
    
    for (i=0; i<MN1; i++)
    {
        xi=x[i];
        xi=fmax(xi,lower);
        A[i]=fmin(xi,upper);
        
        //if (A[i]<lower) {A[i]=lower;}
        //else if (A[i]>upper) {A[i]=upper;}
    }
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A; //outputs
    int  MN1, nd; //number of dimensions and dimension vector
    const int *din;
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
    if (!mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1])) mexErrMsgTxt("floorandceilc.cpp: inputs must be double");
    
    MN1 = mxGetM(prhs[0])*mxGetN(prhs[0]);
    
    // allocate outputs, then assign pointers to outputs
    nd = mxGetNumberOfDimensions(prhs[0]);
    din = mxGetDimensions(prhs[0]);    
    plhs[0] = mxCreateNumericArray(nd, din, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    cfunction(mxGetPr(prhs[0]),mxGetPr(prhs[1]), A, MN1);
    
    return;
}