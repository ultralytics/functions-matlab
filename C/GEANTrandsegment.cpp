//purpose:  Generates isotropic unit vectors
//inputs:   rows, numbe of vectors to make
//outputs:  A (nx3)
//example:  A = isovecs(50);  makes 50 isotropic unit vectors
//Methods found in http://mathworld.wolfram.com/SpherePointPicking.html
    
#include <math.h>
#include "mex.h"
        void cfunction(double* p1, double* p2, double* t1, double* t2, int rows, double* A, double* B)
{
    int i;
    double f,dx,dy,dz,dt,x1,y1,z1,t0;
    dx = p2[0]-p1[0];
    dy = p2[1]-p1[1];
    dz = p2[2]-p1[2];
    dt = t2[0]-t1[0];
    x1 = p1[0];
    y1 = p1[1];
    z1 = p1[2];
    t0 = t1[0];
    
    for (i=0; i<rows; i++)
    {
        f = (double)rand()/RAND_MAX;

        A[i] = f*dx + x1;
        A[i+rows] = f*dy + y1;
        A[i+2*rows] = f*dz + z1;
        
        B[i] = f*dt + t0;
    }
     return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A, *B; //outputs
    int  nd, *d, nrows, *rows; //number of dimensions and dimension vector
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>2)  mexErrMsgTxt("too many outputs");
    if (nrhs<5)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    
    rows = (int*)mxGetPr(prhs[4]);
    nrows = (int)(*rows);
    //mexPrintf("function has %d rows\n",nrows);

    // allocate outputs, then assign pointers to outputs
    if (nrows>0){
        nd = 2;  d = (int*) calloc(nd, sizeof(int));  *d=nrows;  d[1]=3;    
        plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);
        nd = 2;  d = (int*) calloc(nd, sizeof(int));  *d=nrows;  d[1]=1;
        plhs[1] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      B = mxGetPr(plhs[1]);
    }
    else
    {
        nd = 1;  d = (int*) calloc(nd, sizeof(int));  *d=nrows;
        plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);
        plhs[1] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      B = mxGetPr(plhs[1]);
    }

    // Do the actual computations in a subroutine
    cfunction(mxGetPr(prhs[0]),mxGetPr(prhs[1]),mxGetPr(prhs[2]),mxGetPr(prhs[3]),nrows, A, B);
    
    free((void*)d);
    return;
}