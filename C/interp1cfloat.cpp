//purpose:  1D linear iterploation
//inputs:   interp1c(x,y,xi)
//outputs:  A size(xi)
//example:  interp1c(x,y,xi)
    
#include <math.h>
#include "mex.h"
void interp1c(float* X, float* Y, float* XI, float* A, int MN, int nX)
{
    int i, i1, i3;
    double i2, xmin=X[0], idx = (nX - 1)/(X[nX-1]-xmin);//inverse dx = (nx-1)/(xmax-xmin)
    
    for (i=0; i<MN; i++){
        i2 = (XI[i]-xmin)*idx;
        i1 = (int)i2;
        i3 = i1 + 1;
        if (i2>=0 && i3<nX){A[i] = Y[i1]   +   (i2-i1) * (Y[i3]-Y[i1]);}
    }
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    float *A; //outputs
    int  MN, nd, nX; //number of dimensions and dimension vector
    const int *din;
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<3)  mexErrMsgTxt("too few inputs");
    if (!mxIsSingle(prhs[0]) || !mxIsSingle(prhs[1]) || !mxIsSingle(prhs[2])) mexErrMsgTxt("rangec: inputs must be single");
    
    MN = mxGetM(prhs[2])*mxGetN(prhs[2]);
    nX = fmax(mxGetM(prhs[0]),mxGetN(prhs[0]));
    
    // allocate outputs, then assign pointers to outputs
    nd = mxGetNumberOfDimensions(prhs[2]);
    din = mxGetDimensions(prhs[2]);    
    plhs[0] = mxCreateNumericArray(nd, din, mxSINGLE_CLASS, mxREAL);      A = (float *) mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    interp1c((float *) mxGetPr(prhs[0]),(float *) mxGetPr(prhs[1]),(float *) mxGetPr(prhs[2]), A, MN, nX);
    
    return;
}