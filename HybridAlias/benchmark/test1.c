/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 1024

int main(int argc, char **argv)
{
  int i;

  float *B = (float*)malloc(SIZE*sizeof(float));
  float *D = (float*)malloc(SIZE*sizeof(float));
  float *E = (float*)malloc(SIZE*sizeof(float));

  // initialize with twos
  for(i=0; i<SIZE; ++i) B[i] = D[i] = 2;

  // odds are zeros, evens are ones
  for(i=0; i<SIZE; ++i) E[i] = i&1;

  // the test loop
  for(i=0; i<SIZE; ++i)
  {
    float *A;

    if(E[i]) A = B+i;
    else     A = D+i;
    
    *A = E[i];
  }

  //for(i=0; i<SIZE; ++i) printf("B[%d] = %f, D[%d] = %f\n", i, B[i], i, D[i]);

  return 0;
}
