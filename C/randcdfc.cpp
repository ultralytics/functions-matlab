// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  Generates n isotropic unit vectors
//inputs:   n, number of vectors to make
//outputs:  A (nx3)
//example:  A = isovecs(50);  makes 50 isotropic unit vectors
//Methods found in http://mathworld.wolfram.com/SpherePointPicking.html
    
#include <math.h>
#include "mex.h"
void cfunction(double* cdf, int n, int elements, double* A){
    int i;  float j;
    for (i=0; i<n; i++){
        j = (float)rand()/RAND_MAX*elements;
        A[i] = cdf[ (int) j ];
    }
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A; //outputs
    int  nd, *d, n, elements; //number of dimensions and dimension vector

    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    
    n = mxGetScalar(prhs[1]); //number of points to create
    //mexPrintf("function has %d rows\n",n);
    
    elements = mxGetM(prhs[0])*mxGetN(prhs[0]);

    // allocate outputs, then assign pointers to outputs
    nd = 2;  d = (int*) calloc(nd, sizeof(int));  d[0]=n;  d[1]=1;
    plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    cfunction(mxGetPr(prhs[0]), n, elements, A);
    
    free((void*)d);
    return;
}