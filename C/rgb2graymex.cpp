/* 2D linear interpolation 
   Andriy Myronenko, Feb 2008, email: myron@csee.ogi.edu
   homepage: http://www.bme.ogi.edu/~myron/

ZI = mirt2D_mexinterp(Z,XI,YI) interpolates 2D image Z at the points with coordinates XI,YI.
Z is assumed to be defined at regular spaced points 1:N, 1:M, where [M,N]=size(Z).
If XI,YI values are outside the image boundaries, put NaNs in ZI.

The performance is similar to Matlab's ZI = INTERP2(Z,XI,YI,'linear',NaN).
If Z is a 3D matrix, then iteratively interpolates Z(:,:,1), Z(:,:,2),Z(:,:,3),.. etc.
This works faster than to interpolate each image independaently, such as
 ZI(:,:,1) = INTERP2(Z(:,:,1),XI,YI);
 ZI(:,:,2) = INTERP2(Z(:,:,2),XI,YI);
 ZI(:,:,3) = INTERP2(Z(:,:,3),XI,YI);

 The speed gain is from the precomputation of coefficients for interpolation, which are the same for all images.
 Interpolation of a set of images is useful, e.g. for image registration, when one has to interpolate image and its gradients
 at the same positions.
*/

#include <math.h>
#include "mex.h"
void mirt2D_mexinterp(
unsigned char* Z,
unsigned char* F,
int	MN
)
{
    int	n, MN2;
    float m1, m2, m3;
    
    MN2 = 2*MN;
    m1=0.298936021293776;
    m2=0.587043074451121;
    m3=0.114020904255103;
    
    for (n=0; n < MN; n++) {
         F[n] = Z[n]*m1 + Z[n+MN]*m2 + Z[n+MN2]*m3;
    }
    return;
}

// ------- Main function definitions ----------
/* Input arguments */
#define IN_Z		prhs[0]

/* Output arguments */
#define OUT_F		plhs[0]

/* Gateway routine */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    unsigned char *Z, *F;
    int  N, M, MN, ndim, *newdims;
    //const int *dims;
    
     /* Check for input errors */
    if (nlhs>1)  mexErrMsgTxt("Wrong number of output parameters, usage:  Output_images = mirt2D_mexinterp(Input_images, X, Y)");
    if (nrhs!=1) mexErrMsgTxt("Wrong number of input parameters, usage:  Output_images = mirt2D_mexinterp(Input_images, X, Y)");
    //if (!mxIsSingle(IN_Z) || !mxIsSingle(IN_S) || !mxIsSingle(IN_T)) mexErrMsgTxt("mirt2D_mexinterp: Input arguments must be float.");
    //if ((mxGetNumberOfDimensions(IN_S) != mxGetNumberOfDimensions(IN_T)) || (mxGetNumberOfElements(IN_S) != mxGetNumberOfElements(IN_T))) mexErrMsgTxt("Inputs X, Y must have the same size");
    
   /* Get the sizes of each input argument */
    M = mxGetM(IN_Z);
    N = mxGetN(IN_Z)/3;
    MN = M*N;
    
    //ndim = mxGetNumberOfDimensions(IN_Z);
    //dims = mxGetDimensions(IN_Z);
    //newdims = (int*) calloc(ndim, sizeof(int));
    /*Size of the array to allocate for the interpolated points*/
    //*newdims=M;newdims[1]=N; MN=M*N;
    //if (ndim>2){newdims[2]=dims[2];}

    ndim = 2;
    newdims = (int*) calloc(ndim, sizeof(int));
    *newdims=M; newdims[1]=N;
    
    /*Create the array (2D or 3D) to put the interpolated points*/
    OUT_F = mxCreateNumericArray(ndim, newdims, mxUINT8_CLASS, mxREAL);

    
    Z      = (unsigned char*)mxGetPr(IN_Z);
    F      = (unsigned char*) mxGetPr(OUT_F);
    
  /* Do the actual computations in a subroutine */
    mirt2D_mexinterp(Z, F, MN);
    
    free((void*)newdims);
    return;
}


