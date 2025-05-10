// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  1D linear iterploation
//inputs:   interp1c(x,y,xi)
//outputs:  A size(xi)
//example:  interp1c(x,y,xi)
    
#include <math.h>
#include "mex.h"
void index1c(double* X, double* XI, double* A, int MN, int nX)
{
    int i;
    double xmin, idx;
    idx = (nX - 1)/(X[nX-1]-X[0]); //inverse dx = (nx-1)/(xmax-xmin)
    xmin = X[0]*idx - 1;

    for (i=0; i<MN; i++){
        A[i] = XI[i]*idx - xmin;
    }
    return;
}

void index1cint(double* X, double* XI, int* A, int MN, int nX)
{
    int i, i1;
    double xmin, idx, i2;
    idx = (nX - 1)/(X[nX-1]-X[0]); //inverse dx = (nx-1)/(xmax-xmin)
    xmin = X[0]*idx - 1;

    for (i=0; i<MN; i++){
        i2 = XI[i]*idx - xmin;
        i1 = (int)i2;
        if ((i2-i1) >= .5) {A[i] = i1 + 1;}
        else {A[i]=i1;}
    }
    return;
}


// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    //double *A; //outputs
    int  MN, nX; //number of dimensions and dimension vector
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    
    MN = mxGetM(prhs[1])*mxGetN(prhs[1]);
    nX = fmax(mxGetM(prhs[0]),mxGetN(prhs[0]));
    
    if (nrhs==3) { //'exact'
        plhs[0] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]), mxDOUBLE_CLASS, mxREAL);  double *A;  A = mxGetPr(plhs[0]);
        index1c(mxGetPr(prhs[0]),mxGetPr(prhs[1]), A, MN, nX);
    }
    else { //'nearest'
        plhs[0] = mxCreateNumericArray(mxGetNumberOfDimensions(prhs[1]), mxGetDimensions(prhs[1]), mxUINT32_CLASS, mxREAL);  int *A;  A = (int*)mxGetPr(plhs[0]);
        index1cint(mxGetPr(prhs[0]),mxGetPr(prhs[1]), A, MN, nX);
    }
    
    return;
}