// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

//purpose:  Generates diffuse reflection vectors about normal vector [nx ny nz]
//inputs:   rows, numbe of vectors to make
//outputs:  A (nx3)
//example:  A = isovecs(50);  makes 50 isotropic unit vectors
//Methods found in http://mathworld.wolfram.com/SpherePointPicking.html
//mex diffusevecs.cpp; fig; x=diffusevecs(1E4,[0 0 0]); fcnplot3(x,'.'); xyzlabel; axis equal vis3d

#include <math.h>
#include "mex.h"
void cfunction(int rows, double* A, double* N)
{
    int i;
    float u,theta,b, x,y,z, nx,ny,nz, yaw,pitch, cp,sp, cy,sy;
    
    nx =  N[0]; //normal unit vector of surface
    ny =  N[1];
    nz =  N[2];
    
    for (i=0; i<rows; i++)
    {
        //u = acos((float)rand()/RAND_MAX)/(M_PI/2); //ISOTROPIC
        u = acos((float)rand()/RAND_MAX)/(M_PI/2); //Lambert's Cosine Law https://en.wikipedia.org/wiki/Lambert%27s_cosine_law
        theta = (float)rand()/RAND_MAX*2*M_PI;
        b = sqrt(1-u*u);
        
        z = b*cos(theta);
        y = b*sin(theta);
        x = u;

        pitch = asin(-nz); //unit vector! otherwise  asin(-nz/r)
        yaw = atan2(ny,nx);
        
        cp=sqrt(1 - nz*nz);     sp=-nz;
        //cp=cos(pitch);        sp=sin(pitch);
        cy=cos(yaw);            sy=sin(yaw);
        
        A[i]            = cp*cy*x - sy*y + cy*sp*z;
        A[i+rows]       = cp*sy*x + cy*y + sp*sy*z;
        A[i+2*rows]     = cp*z - sp*x;
        
// p = asin(-z/1); //unit vector!
// y = atan2(y,x);
// cp=cos(p);  sp=sin(p);
// cy=cos(y);  sy=sin(y);
//
// DCM_B2W =   [ cp*cy, -sy, cy*sp
//               cp*sy,  cy, sp*sy
//                 -sp,   0,    cp]  //nzERO ROLL
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
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
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
    cfunction(nrows, A, mxGetPr(prhs[1]));
    
    free((void*)d);
    return;
}