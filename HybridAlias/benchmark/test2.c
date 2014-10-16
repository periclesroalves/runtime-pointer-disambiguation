#include <stdio.h>
#include <stdlib.h>

#define SIZE 1024

int main(int argc, char **argv)
{
  int i;

  float **B = (float**)malloc(SIZE*sizeof(float*));
  float **D = (float**)malloc(SIZE*sizeof(float*));
  float  *E = (float*) malloc(SIZE*sizeof(float));

  // init E
  for(i=0; i<SIZE; ++i) E[i] = i;

  // B[i] points to every position of E starting from the beginning of E
  // D[i] points to every position of E starting from the end of E
  for(i=0; i<SIZE; ++i) 
  {
    B[i] = E+i;
    D[i] = E+(SIZE-1)-i;
  }

  //for(i=0; i<SIZE; ++i) printf("%f\n", E[i]);

  // the test loop
  for(i=0; i<SIZE; ++i)
  {
    float *A;
    float *C;
    float tmp;

    A = B[i];
    C = D[i];
    
    // swap values of E
    tmp  = A[i];
    A[i] = C[i];
    C[i] = tmp;
  }

  //for(i=0; i<SIZE; ++i) printf("%f\n", E[i]);

  return 0;
}
