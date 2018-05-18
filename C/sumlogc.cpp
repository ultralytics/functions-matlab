//purpose:  Finds the bsx ranges between two sets of 2D or 3D vectors A and B
//inputs:   A (nx3), optional B (mx3)
//outputs:  range (nxm), range^2 (nxm), dx (nxm), dy (nxm), dz (nxm)
//example:  [r,rs,dx,dy,dz] = rangec(A,B)

#include <math.h>
#include "mex.h"
void cfunction(double* A, double* B, int M, int N)
{
    int i, j;
    double a,b;
    
    for (i=0; i<N; i++)
    {
//         a=0;
//         c=0;
//         for (j=0; j<M; j++)
//         {
//             b = A[j+i*M];            
//             if (b>0){a = a + log(b + 1E-323);  c=c+1;}
//         }
//         B[i] = a - (M-c)*743.746924740821; //probability floor
        
        a=0;
        for (j=0; j<M; j++)
        {
            if (A[j+i*M]>0){a = a + log(A[j+i*M] + 1E-323);}
            else{a = a - 743.746924740821;}
        }
        B[i] = a; //probability floor
        
        
//         a=0;
//         for (j=0; j<M; j++)
//         {
//             a = a + log(A[j+i*M] + 1E-323);
//         }
//         B[i] = a; //probability floor
        
    }
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A; //outputs
    int  nd, *d, M, N; //number of dimensions and dimension vector
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<1)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    
    // allocate outputs, then assign pointers to outputs
    M = mxGetM(prhs[0]); N = mxGetN(prhs[0]);
    nd = 2;  d = (int*) calloc(nd, sizeof(int));  *d=1;  d[1]=N;
    plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    cfunction(mxGetPr(prhs[0]), A, M, N);
    
    free((void*)d);
    return;
}