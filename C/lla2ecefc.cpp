//purpose:  Finds the bsx ranges between two sets of 2D or 3D vectors A and B
//inputs:   A (nx3), optional B (mx3)
//outputs:  range (nxm), range^2 (nxm), dx (nxm), dy (nxm), dz (nxm)
//example:  [r,rs,dx,dy,dz] = rangec(A,B)

#include <math.h>
#include "mex.h"
void cfunction(double* lla, double* ecef, int rows)
{
    int i;
    double d2r,f,fa,R,Rs,lat,lng,alt,lambda,slambda,r,k1;

    
d2r = M_PI/180;

f = pow(1-1/298.257223563, 2); //WGS84 flattening
fa = (1/f-1);
R = 6378.1370; //WGS84 equatorial radius (km)
Rs = pow(R,2);

    for (i=0; i<rows; i++)
    {
        lat = lla[i]*d2r;
        lng = lla[i+rows]*d2r;
        alt = lla[i+2*rows]/1000;
        
        lambda = atan(f*tan(lat)); //mean sea level at lat
        slambda = sin(lambda);
        
        r = sqrt( Rs / (1+fa*pow(slambda,2)) ); //radius at surface point
        k1 = r*cos(lambda) + alt*cos(lat);
        
        ecef[i] = k1*cos(lng);
        ecef[i+rows] = k1*sin(lng);
        ecef[i+2*rows] = r*slambda + alt*sin(lat);
        
    }
    return;
}

// Main function definitions ----------------------------------------------
//#define IN_A		prhs[0]
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A; //outputs
    int  nd, *d; //number of dimensions and dimension vector
    const int *dims;
    
    //mexPrintf("function has %d inputs and %d outputs\n",nlhs,nrhs);
    //mexPrintf("A is %dD, MxN=%dx%d\n",mxGetNumberOfDimensions(prhs[0]),mxGetM(prhs[0]),mxGetN(prhs[0]));
    if (nlhs>1)  mexErrMsgTxt("too many outputs");
    if (nrhs<1)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("rangec: inputs must be double");
    

    // allocate outputs, then assign pointers to outputs
    nd = 2;
    d = (int*) calloc(nd, sizeof(int));  *d=mxGetM(prhs[0]);  d[1]=3;
    //dims = mxGetDimensions(prhs[0]);
    plhs[0] = mxCreateNumericArray(nd, d, mxDOUBLE_CLASS, mxREAL);      A = mxGetPr(plhs[0]);

    // Do the actual computations in a subroutine
    cfunction(mxGetPr(prhs[0]), A, mxGetM(prhs[0]));
    
    free((void*)d);
    return;
}