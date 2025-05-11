// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  Generates isotropic unit vectors
//inputs:   rows, numbe of vectors to make
//outputs:  A (nx3)
//example:  A = isovecs(50);  makes 50 isotropic unit vectors
//Methods found in http://mathworld.wolfram.com/SpherePointPicking.html
    
#include <math.h>
#include "mex.h"
void cfunction(int rows, double* A)
{
    int i;
    float u,theta,b;
    
    for (i=0; i<rows; i++)
    {
        u = (float)rand()/RAND_MAX*2 - 1;
        theta = (float)rand()/RAND_MAX*2*M_PI;
        b = sqrt(1-u*u);
        
        A[i] = b*cos(theta);
        A[i+rows] = b*sin(theta);
        A[i+2*rows] = u;
    }
     return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A; //outputs
    int  nd, *d, nrows; //number of dimensions and dimension vector

    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<1)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    
    nrows = mxGetScalar(prhs[0]);
    //mexPrintf("function has %d rows\n",nrows);

    // allocate outputs, then assign pointers to outputs
    if (nrows>0){
        nd = 2;  d = (int*) calloc(nd, sizeof(int));  d[0]=nrows;  d[1]=3;    
        plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);
    }
    else
    {
        nd = 1;  d = (int*) calloc(nd, sizeof(int));  d[0]=nrows;
        plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);
    }

    // Do the actual computations in a subroutine
    cfunction(nrows, A);
    
    free((void*)d);
    return;
}