#include "mex.h"
#include "math.h"

/* La fonction de calcul */
void MEX_SAFT(double c, int Fs, int Nt, int Nel, double *p_u, int Nx, int Nz, double *p_x, double *p_z, double *p_A, double *p_O)
{
    double tau;
	int s,ind_tau;
    
    for (int i = 0; i < Nx; i++) {
        for (int j = 0; j < Nz; j++) {
            s = 0;
            for (int k = 0; k < Nel; k++) {
                tau = (2 / c) * sqrt((p_x[i] - p_u[k]) * (p_x[i] - p_u[k]) + p_z[j] * p_z[j]);
                ind_tau = (int) floor(Fs*tau+0.5);
                if (ind_tau < Nt) {
                    s += p_A[ind_tau + k * Nt];
                }
            }
            p_O[j + i*Nz] = s;
        }
    }
}

/* La fonction d'appel */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    /* Déclarations variables C */
    double c;
	int Fs;
	int Nt;
	int Nel; 
	double *p_u;
	int Nx;
	int Nz;
	double *p_x;
	double *p_z;
	double *p_A;
	int NoutSize;
	double *p_O;
    
    /* Affectation des entrées */
    c = mxGetScalar(prhs[0]);
    Fs = mxGetScalar(prhs[1]);
    Nt = mxGetScalar(prhs[2]);
    Nel = mxGetScalar(prhs[3]);
    p_u = mxGetPr(prhs[4]);
    Nx = mxGetScalar(prhs[5]);
    Nz = mxGetScalar(prhs[6]);
    p_x = mxGetPr(prhs[7]);
    p_z = mxGetPr(prhs[8]);
    p_A = mxGetPr(prhs[9]);
    
    /* Affectation des sorties */
    NoutSize = Nx*Nz;
    plhs[0] = mxCreateNumericMatrix((mwSize)NoutSize,1,mxDOUBLE_CLASS,0);
    p_O = mxGetData(plhs[0]);
    
    /* Appel de la fonction de calcul */
    MEX_SAFT(c,Fs,Nt,Nel,p_u,Nx,Nz,p_x,p_z,p_A,p_O);
}
        






