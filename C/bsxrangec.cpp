// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  Finds the bsx ranges between two sets of 2D or 3D vectors A and B
//inputs:   A (nx3), optional B (mx3)
//outputs:  range (nxm), range^2 (nxm), dx (nxm), dy (nxm), dz (nxm)
//example:  [r,rs,dx,dy,dz] = rangec(A,B)

#include <math.h>
#include "mex.h"
void cfunction(double* A, double* B, double* r, double* rs, double* dx, double* dy, double* dz, int MA, int MB, int NZ)
{
    int i, j, k;
    float Bx,By,Bz;

    for (j=0; j<MB; j++)
    {
        Bx = B[j];
        By = B[j+MB];
        Bz = B[j+2*MB];
        for (i=0; i<MA; i++)
        {
            k = i+j*MA;
            dx[k] = A[i] - Bx;
            dy[k] = A[i+MA] - By;
            if (NZ==3){dz[k] = A[i+2*MA] - Bz;  rs[k] = dx[k]*dx[k] + dy[k]*dy[k] + dz[k]*dz[k];}
            else{rs[k] = dx[k]*dx[k] + dy[k]*dy[k];}
            r[k] = sqrt(rs[k]);
        }
    }    
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A, *B, *C, *D, *E; //outputs
    int  nd, *d; //number of dimensions and dimension vector
    const int *dims;
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>5)  mexErrMsgTxt("too many outputs");
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("inputs must be double");
    

    // allocate outputs, then assign pointers to outputs
    nd = 2;  d = (int*) calloc(nd, sizeof(int));  *d=mxGetM(prhs[0]);  d[1]=mxGetM(prhs[1]);
    plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);
    plhs[1] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      B = mxGetPr(plhs[1]);
    plhs[2] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      C = mxGetPr(plhs[2]);
    plhs[3] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      D = mxGetPr(plhs[3]);
    plhs[4] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      E = mxGetPr(plhs[4]);

    // Do the actual computations in a subroutine
    cfunction(mxGetPr(prhs[0]), mxGetPr(prhs[1]), A, B, C, D, E, mxGetM(prhs[0]), mxGetM(prhs[1]), mxGetN(prhs[0]));
    
    free((void*)d);
    return;
}