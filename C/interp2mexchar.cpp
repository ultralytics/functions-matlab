// Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

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
float* S,
float* T,
unsigned char* F,
int	MN,
int nrows,
int ncols,
int ndim
)
{
    int	n, in1, in2, in3, in4;
    float	t, s;
    float m1, m2, m3, m4;//, nan;
    int ndx, Fshift, Zshift, i, nrowsncols, fs, ft;
    
    nrowsncols=nrows*ncols;
    //nan=mxGetNaN();
    for (n=0; n < MN; n++) {
        t=*(T+n);
        s=*(S+n);
        fs=(int)floor(s);
        ft=(int)floor(t);
        if (fs<1 || s>ncols || ft<1 || t>nrows){
           // for (i = 0; i < ndim; i++) F[n+i*MN]=nan;  } //put nans if outside
           for (i = 0; i < ndim; i++) F[n+i*MN]=0;  } //put 0 if outside
        else  {
            ndx = ft+(fs-1)*nrows;
           
            if (s==ncols){s=s+1; ndx=ndx-nrows; }  
            s=s-fs;
            if (t==nrows){t=t+1; ndx=ndx-1; }  
            t=t-ft;
            
            in1=ndx-1;
            in2=ndx;
            in4=ndx+nrows;
            in3=in4-1;

			m4=t*s;
            m1=1+m4-t-s;
            m2=t-m4;
            m3=s-m4;
            
            if (ndim>1){
                for (i = 0; i < ndim; i++)
                {
                    Zshift=i*nrowsncols;
                    F[n+i*MN] = Z[in1+Zshift]*m1+Z[in2+Zshift]*m2+Z[in3+Zshift]*m3+Z[in4+Zshift]*m4;
                }
            }
            else  
                F[n] = Z[in1]*m1 + Z[in2]*m2 + Z[in3]*m3 + Z[in4]*m4;
            
        }
    }
    return;
}
// ------- Main function definitions ----------
/* Input/output arguments */
#define IN_Z		prhs[0]
#define IN_S		prhs[1]
#define IN_T		prhs[2]
#define OUT_F		plhs[0]

/* Gateway routine */
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    unsigned char *Z, *F;
    float *S, *T;
    int  N, M, MN, nrows, ncols, vol, ndim, *newdims;
    const int *dims;
    
     /* Check for input errors */
    if (nlhs>5)  mexErrMsgTxt("too many outputs");
    if (nrhs<2)  mexErrMsgTxt("too few inputs");
    //if (!mxIsDouble(plhs[0]) || !mxIsDouble(plhs[1])) mexErrMsgTxt("inputs must be double");
    
   /* Get the sizes of each input argument */
    M = mxGetM(IN_S);
    N = mxGetN(IN_S);
    ndim = mxGetNumberOfDimensions(IN_Z);
    dims = mxGetDimensions(IN_Z);
    newdims = (int*) calloc(ndim, sizeof(int));
    
    /*Size of the array to allocate for the interpolated points*/
    *newdims=M;newdims[1]=N; MN=M*N; vol=1;
    if (ndim>2) {
        newdims[2]=dims[2];
        vol=dims[2];}
    
    /*Create the array (2D or 3D) to put the interpolated points*/
    OUT_F = mxCreateNumericArray(ndim, newdims, mxUINT8_CLASS, mxREAL);

    /* Input image size */
    nrows = *dims;
    ncols = *(dims+1);
    
  /* Assign pointers to the input/output arguments */
    Z      = (unsigned char*)mxGetPr(IN_Z);
    S      = (float*)mxGetPr(IN_S);
    T      = (float*)mxGetPr(IN_T);
    F      = (unsigned char*) mxGetPr(OUT_F);
    
  /* Do the actual computations in a subroutine */
    mirt2D_mexinterp(Z, S, T, F, MN, nrows, ncols, vol);
    
    free((void*)newdims);
    return;
}


