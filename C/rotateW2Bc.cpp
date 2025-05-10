// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  Rotates nx3 matrix X by nx3 RPY matrix R
//inputs:   X (nx3), R (mx3)
//outputs:  Y
//example:  [Y] = rotateB2W(R,X)

#include <math.h>
#include "mex.h"
void rotate(double* R, double* X, double* Y, int rowsR, int rowsX)
{
    int i, j, k, rows=fmax(rowsR,rowsX);
    double sr,cr, sp,cp, sy,cy;
    
    if(rowsR==rowsX){ //X=nx3, R=nx3 
        for (i=0; i<rows; i++){
            j=i+rows; k=j+rows;
            //ROLL         PITCH          YAW
            sr=sin(R[i]);  sp=sin(R[j]);  sy=sin(R[k]);
            cr=cos(R[i]);  cp=cos(R[j]);  cy=cos(R[k]);
            Y[i] = X[i]*(cp*cy)                 + X[j]*(sr*sp*cy-cr*sy)         + X[k]*(cr*sp*cy+sr*sy);
            Y[j] = X[i]*(cp*sy)                 + X[j]*(sr*sp*sy+cr*cy)         + X[k]*(cr*sp*sy-sr*cy) ;
            Y[k] =-X[i]*sp                      + X[j]*(sr*cp)                  + X[k]*(cr*cp);}
    }
    else if(rowsR==1){ //X=nx3, R=1x3
        sr=sin(R[0]);  sp=sin(R[1]);  sy=sin(R[2]);
        cr=cos(R[0]);  cp=cos(R[1]);  cy=cos(R[2]);
        for (i=0; i<rows; i++){
            j=i+rows; k=j+rows;
            Y[i] = X[i]*(cp*cy)                 + X[j]*(sr*sp*cy-cr*sy)         + X[k]*(cr*sp*cy+sr*sy);
            Y[j] = X[i]*(cp*sy)                 + X[j]*(sr*sp*sy+cr*cy)         + X[k]*(cr*sp*sy-sr*cy) ;
            Y[k] =-X[i]*sp                      + X[j]*(sr*cp)                  + X[k]*(cr*cp);}
    }
    else{ //X=1x3, R=nx3
        double x=X[0],y=X[1],z=X[2];
        for (i=0; i<rows; i++){
            j=i+rows; k=j+rows;
            sr=sin(R[i]);  sp=sin(R[j]);  sy=sin(R[k]);
            cr=cos(R[i]);  cp=cos(R[j]);  cy=cos(R[k]);
            Y[i] = x*(cp*cy)                 + y*(sr*sp*cy-cr*sy)         + z*(cr*sp*cy+sr*sy);
            Y[j] = x*(cp*sy)                 + y*(sr*sp*sy+cr*cy)         + z*(cr*sp*sy-sr*cy) ;
            Y[k] =-x*sp                      + y*(sr*cp)                  + z*(cr*cp);}
    }
    
    return;
}

// Main function definitions ----------------------------------------------
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A; //outputs
    int  nd; //number of dimensions and dimension vector
    const int *din;
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    
    // allocate outputs, then assign pointers to outputs
    nd = mxGetNumberOfDimensions(prhs[1]);
    din = mxGetDimensions(prhs[1]);
    plhs[0] = mxCreateNumericArray(nd, din, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    rotate(mxGetPr(prhs[0]),mxGetPr(prhs[1]), A, mxGetM(prhs[0]), mxGetM(prhs[1]));
    
    return;
}