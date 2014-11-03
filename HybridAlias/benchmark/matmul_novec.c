#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BSIZE 64

float **A;
float **B;
float **C;

void matmul(float *C, float *A, float *B);

void compute(int DIM, float *A[DIM][DIM], float *B[DIM][DIM], float *C[DIM][DIM])
{
  int i, j, k;

  for (i = 0; i < DIM; i++)
    for (j = 0; j < DIM; j++)
      for (k = 0; k < DIM; k++)
        matmul(C[i][j], A[i][k], B[k][j]);
}

static void convert_to_blocks(int DIM, int N, float *Alin, float *A[DIM][DIM])
{
  int i, j;
  for (i = 0; i < N; i++)
  {
    for (j = 0; j < N; j++)
    {
      A[i/BSIZE][j/BSIZE][(i%BSIZE)*BSIZE+j%BSIZE] = Alin[j*N+i];
    }
  }

}

void initialize(int argc, char **argv, int *DIM_p)
{
  int DIM;
  int i;

  if(argc == 2) DIM = atoi(argv[1]);
  else
  {
    printf("usage: %s DIM\n",argv[0]);
    exit(0);
  }

  *DIM_p = DIM;
  int N  = BSIZE*DIM;
  int NN = N*N;

  printf("Matrix dimension: %d\n",N);

  // linear matrix
  /*float *Alin = (float *) malloc(NN * sizeof(float));
  float *Blin = (float *) malloc(NN * sizeof(float));
  float *Clin = (float *) malloc(NN * sizeof(float));*/

  // tiled matrix
  A = (float **) malloc(DIM*DIM*sizeof(float *));
  B = (float **) malloc(DIM*DIM*sizeof(float *));
  C = (float **) malloc(DIM*DIM*sizeof(float *));
  for (i = 0; i < DIM*DIM; i++)
  {
     A[i] = (float *) malloc(BSIZE*BSIZE*sizeof(float));
     B[i] = (float *) malloc(BSIZE*BSIZE*sizeof(float));
     C[i] = (float *) malloc(BSIZE*BSIZE*sizeof(float));
  }

  // copy contents of linear matrix to tiled matrix
  /*convert_to_blocks(DIM, N, Alin, (void *)A);
  convert_to_blocks(DIM, N, Blin, (void *)B);
  convert_to_blocks(DIM, N, Clin, (void *)C);*/

  /*free(Alin);
  free(Blin);
  free(Clin);*/
}

int main(int argc, char **argv)
{
  // local vars
  int i, j, k;
  int DIM;

  // application initialization
  initialize(argc, argv, &DIM);

  // matrix multiplication
  compute(DIM, (void *)A, (void *)B, (void *)C);

  return 0;
}

