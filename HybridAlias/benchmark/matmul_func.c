#define BSIZE 64

void matmul(float C[BSIZE][BSIZE], float A[BSIZE][BSIZE], float B[BSIZE][BSIZE])
{
  int i, j, k;

  for (i = 0; i < BSIZE; i++)
  {
    for (j = 0; j < BSIZE; j++)
    {
      for (k=0; k < BSIZE; k++)
      {
        C[i][j] += A[i][k]*B[k][j];
      }
    }
  }
}

