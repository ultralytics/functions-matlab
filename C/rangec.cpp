
//purpose:  Finds the bsx ranges between two sets of 2D or 3D vectors A and B
//inputs:   A (nx3), optional B (1x3) or vice versa
//outputs:  range (nxm), range^2 (nxm), dx (nxm), dy (nxm), dz (nxm)
//example:  [r,rs,dx,dy,dz] = rangec(A,B)

#include <math.h>
#include "mex.h"
void cfunction(double* A, double* B, double* r, double* dx, double* rs, int MA, int MB, int NZ, int nrhs)
{
    int i, j, k;
    double a;
    
    if (nrhs==1){ //A is nx3, no B
         for (j=0; j<MA; j++){
            for (i=0; i<NZ; i++) {k=j+i*MA;  a=A[k];  rs[j]+=a*a;  dx[k]=a;}
            r[j] = sqrt(rs[j]);
        }}
    else{
        if (MB==MA){ //A = nx3 and B is same size
            for (j=0; j<MB; j++){
                for (i=0; i<NZ; i++) {k=j+i*MA;  a=B[k]-A[k];  rs[j]+=a*a;  dx[k]=a;}
                r[j] = sqrt(rs[j]);
            }}
        else if (MB>MA && MA==1){ //B is nx3 and A is 1x3
            for (j=0; j<MB; j++){
                for (i=0; i<NZ; i++) {k=j+i*MB;  a=B[k]-A[i];  rs[j]+=a*a;  dx[k]=a;}
                r[j] = sqrt(rs[j]);
            }}
        else if (MA>MB && MB==1){ //B is 1x3 and A is nx3
            for (j=0; j<MA; j++){
                for (i=0; i<NZ; i++) {k=j+i*MA;  a=B[i]-A[k];  rs[j]+=a*a;  dx[k]=a;}
                r[j] = sqrt(rs[j]);
            }}
    }
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A, *B, *C; //outputs
    int  nd, rows, *d, *e; //number of dimensions and dimension vector
    const int *dims;
    
    //mexPrintf("function has %d inputs and %d outputs\n",nrhs,nlhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    
    if (nlhs>3)  mexErrMsgTxt("too many outputs");
    if (nrhs<1)  mexErrMsgTxt("too few inputs");
    if (!mxIsDouble(prhs[0])) mexErrMsgTxt("inputs must be double");
    
    // allocate outputs, then assign pointers to outputs
    nd = 2;
    if (nrhs==1)
    {rows = mxGetM(prhs[0]);}
    else
    {rows = fmax(mxGetM(prhs[0]),mxGetM(prhs[1]));}
    
    d = (int*) calloc(2, sizeof(int));    *d=rows;   d[1]=mxGetN(prhs[0]);
    e = (int*) calloc(2, sizeof(int));    *e=rows;   e[1]=1;
    
    plhs[0] = mxCreateNumericArray(nd, e, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);
    plhs[1] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      B = mxGetPr(plhs[1]);
    plhs[2] = mxCreateNumericArray(nd, e, mxDOUBLE_CLASS, mxREAL);      C = mxGetPr(plhs[2]);
    
    if (nrhs==1)
    {cfunction(mxGetPr(prhs[0]), 0, A, B, C, mxGetM(prhs[0]), 0, d[1], nrhs);}
    else
    {cfunction(mxGetPr(prhs[0]), mxGetPr(prhs[1]), A, B, C, mxGetM(prhs[0]), mxGetM(prhs[1]), d[1], nrhs);     if (!mxIsDouble(prhs[0])) mexErrMsgTxt("inputs must be double");}
    
    free((void*)d);
    free((void*)e);
    return;
}