#include <immintrin.h>

double* memcpy_opt(int N, int TSTEPS)
{
    double* A __attribute__((aligned(32))) = new double[N*N] ;
    double* B __attribute__((aligned(32))) = new double[N*N] ;

    __m256d reg_1;
    __m256d reg_2;
    __m256d reg_3;
    __m256d reg_4;
    __m256d reg_5;
    __m256d reg_6;
    __m256d reg_7;
    __m256d reg_8;
    __m256d reg_9;
    __m256d reg_10;
    __m256d reg_11;
    __m256d reg_12;
    __m256d reg_13;
    __m256d reg_14;
    __m256d reg_15;
    __m256d reg_16;

    for(int t = 0; t< TSTEPS/2; t++)
    {

	for(int i = 0; i< N; i++)
	    for(int j = 0; j< N ; j+=4)
	    {
		reg_1 = _mm256_load_pd(&A[i*N+j]);
/*		reg_2 = _mm256_load_pd(&A[i*N+j+4]);
		reg_3 = _mm256_load_pd(&A[i*N+j+8]);
		reg_4 = _mm256_load_pd(&A[i*N+j+12]);
		reg_5 = _mm256_load_pd(&A[i*N+j+16]);
		reg_6 = _mm256_load_pd(&A[i*N+j+20]);
		reg_7 = _mm256_load_pd(&A[i*N+j+24]);
		reg_8 = _mm256_load_pd(&A[i*N+j+28]);
		reg_9 = _mm256_load_pd(&A[i*N+j+32]);
		reg_10 = _mm256_load_pd(&A[i*N+j+36]);
		reg_11 = _mm256_load_pd(&A[i*N+j+40]);
		reg_12 = _mm256_load_pd(&A[i*N+j+44]);
		reg_13 = _mm256_load_pd(&A[i*N+j+48]);
		reg_14 = _mm256_load_pd(&A[i*N+j+52]);
		reg_15 = _mm256_load_pd(&A[i*N+j+56]);
		reg_16 = _mm256_load_pd(&A[i*N+j+60]);
*/		
		 _mm256_store_pd(&B[i*N+j]   ,reg_1 );
/*		 _mm256_store_pd(&B[i*N+j+4] ,reg_2);
		 _mm256_store_pd(&B[i*N+j+8] ,reg_3);
		 _mm256_store_pd(&B[i*N+j+12],reg_4);
		 _mm256_store_pd(&B[i*N+j+16],reg_5);
		 _mm256_store_pd(&B[i*N+j+20],reg_6);
		 _mm256_store_pd(&B[i*N+j+24],reg_7);
		 _mm256_store_pd(&B[i*N+j+28],reg_8);
		 _mm256_store_pd(&B[i*N+j+32] ,reg_9 );
		 _mm256_store_pd(&B[i*N+j+36] ,reg_10);
		 _mm256_store_pd(&B[i*N+j+40] ,reg_11);
		 _mm256_store_pd(&B[i*N+j+44],reg_12);
		 _mm256_store_pd(&B[i*N+j+48],reg_13);
		 _mm256_store_pd(&B[i*N+j+52],reg_14);
		 _mm256_store_pd(&B[i*N+j+56],reg_15);
		 _mm256_store_pd(&B[i*N+j+64],reg_16);
*/		
	    }

	for(int i = 0; i< N ; i++)
	    for(int j = 0; j< N ; j+=4)
	    {
		reg_1 = _mm256_load_pd(&B[i*N+j]);
/*		reg_2 = _mm256_load_pd(&B[i*N+j+4]);
		reg_3 = _mm256_load_pd(&B[i*N+j+8]);
		reg_4 = _mm256_load_pd(&B[i*N+j+12]);
		reg_5 = _mm256_load_pd(&B[i*N+j+16]);
		reg_6 = _mm256_load_pd(&B[i*N+j+20]);
		reg_7 = _mm256_load_pd(&B[i*N+j+24]);
		reg_8 = _mm256_load_pd(&B[i*N+j+28]);
		reg_9 = _mm256_load_pd(&B[i*N+j+32]);
		reg_10 = _mm256_load_pd(&B[i*N+j+36]);
		reg_11 = _mm256_load_pd(&B[i*N+j+40]);
		reg_12 = _mm256_load_pd(&B[i*N+j+44]);
		reg_13 = _mm256_load_pd(&B[i*N+j+48]);
		reg_14 = _mm256_load_pd(&B[i*N+j+52]);
		reg_15 = _mm256_load_pd(&B[i*N+j+56]);
		reg_16 = _mm256_load_pd(&B[i*N+j+60]);
*/		
		 _mm256_store_pd(&A[i*N+j]   ,reg_1 );
/*		 _mm256_store_pd(&A[i*N+j+4] ,reg_2);
		 _mm256_store_pd(&A[i*N+j+8] ,reg_3);
		 _mm256_store_pd(&A[i*N+j+12],reg_4);
		 _mm256_store_pd(&A[i*N+j+16],reg_5);
		 _mm256_store_pd(&A[i*N+j+20],reg_6);
		 _mm256_store_pd(&A[i*N+j+24],reg_7);
		 _mm256_store_pd(&A[i*N+j+28],reg_8);
		 _mm256_store_pd(&A[i*N+j+32] ,reg_9 );
		 _mm256_store_pd(&A[i*N+j+36] ,reg_10);
		 _mm256_store_pd(&A[i*N+j+40] ,reg_11);
		 _mm256_store_pd(&A[i*N+j+44],reg_12);
		 _mm256_store_pd(&A[i*N+j+48],reg_13);
		 _mm256_store_pd(&A[i*N+j+52],reg_14);
		 _mm256_store_pd(&A[i*N+j+56],reg_15);
		
 _mm256_store_pd(&A[i*N+j+64],reg_16);
*/
	    }

    }
    return A;

}

double* memcpy_opt3D(int N, int TSTEPS)
{
    double* A __attribute__((aligned(32))) = new double[N*N*N];
    double* B __attribute__((aligned(32))) = new double[N*N*N];

    __m256d reg_1;
    __m256d reg_2;
    __m256d reg_3;
    __m256d reg_4;
    __m256d reg_5;
    __m256d reg_6;
    __m256d reg_7;
    __m256d reg_8;
    __m256d reg_9;
    __m256d reg_10;
    __m256d reg_11;
    __m256d reg_12;
    __m256d reg_13;
    __m256d reg_14;
    __m256d reg_15;
    __m256d reg_16;

    for(int t = 0; t< TSTEPS/2; t++)
    {

	for(int i = 0; i< N*N; i++)
	    for(int j = 0; j< N ; j+=4)
	    {
		reg_1 = _mm256_load_pd(&A[i*N+j]);
/*		reg_2 = _mm256_load_pd(&A[i*N+j+4]);
		reg_3 = _mm256_load_pd(&A[i*N+j+8]);
		reg_4 = _mm256_load_pd(&A[i*N+j+12]);
		reg_5 = _mm256_load_pd(&A[i*N+j+16]);
		reg_6 = _mm256_load_pd(&A[i*N+j+20]);
		reg_7 = _mm256_load_pd(&A[i*N+j+24]);
		reg_8 = _mm256_load_pd(&A[i*N+j+28]);
		reg_9 = _mm256_load_pd(&A[i*N+j+32]);
		reg_10 = _mm256_load_pd(&A[i*N+j+36]);
		reg_11 = _mm256_load_pd(&A[i*N+j+40]);
		reg_12 = _mm256_load_pd(&A[i*N+j+44]);
		reg_13 = _mm256_load_pd(&A[i*N+j+48]);
		reg_14 = _mm256_load_pd(&A[i*N+j+52]);
		reg_15 = _mm256_load_pd(&A[i*N+j+56]);
		reg_16 = _mm256_load_pd(&A[i*N+j+60]);
*/		
		 _mm256_store_pd(&B[i*N+j]   ,reg_1 );
/*		 _mm256_store_pd(&B[i*N+j+4] ,reg_2);
		 _mm256_store_pd(&B[i*N+j+8] ,reg_3);
		 _mm256_store_pd(&B[i*N+j+12],reg_4);
		 _mm256_store_pd(&B[i*N+j+16],reg_5);
		 _mm256_store_pd(&B[i*N+j+20],reg_6);
		 _mm256_store_pd(&B[i*N+j+24],reg_7);
		 _mm256_store_pd(&B[i*N+j+28],reg_8);
		 _mm256_store_pd(&B[i*N+j+32] ,reg_9 );
		 _mm256_store_pd(&B[i*N+j+36] ,reg_10);
		 _mm256_store_pd(&B[i*N+j+40] ,reg_11);
		 _mm256_store_pd(&B[i*N+j+44],reg_12);
		 _mm256_store_pd(&B[i*N+j+48],reg_13);
		 _mm256_store_pd(&B[i*N+j+52],reg_14);
		 _mm256_store_pd(&B[i*N+j+56],reg_15);
		 _mm256_store_pd(&B[i*N+j+64],reg_16);
*/		
	    }

	for(int i = 0; i< N*N ; i++)
	    for(int j = 0; j< N ; j+=4)
	    {
		reg_1 = _mm256_load_pd(&B[i*N+j]);
/*		reg_2 = _mm256_load_pd(&B[i*N+j+4]);
		reg_3 = _mm256_load_pd(&B[i*N+j+8]);
		reg_4 = _mm256_load_pd(&B[i*N+j+12]);
		reg_5 = _mm256_load_pd(&B[i*N+j+16]);
		reg_6 = _mm256_load_pd(&B[i*N+j+20]);
		reg_7 = _mm256_load_pd(&B[i*N+j+24]);
		reg_8 = _mm256_load_pd(&B[i*N+j+28]);
		reg_9 = _mm256_load_pd(&B[i*N+j+32]);
		reg_10 = _mm256_load_pd(&B[i*N+j+36]);
		reg_11 = _mm256_load_pd(&B[i*N+j+40]);
		reg_12 = _mm256_load_pd(&B[i*N+j+44]);
		reg_13 = _mm256_load_pd(&B[i*N+j+48]);
		reg_14 = _mm256_load_pd(&B[i*N+j+52]);
		reg_15 = _mm256_load_pd(&B[i*N+j+56]);
		reg_16 = _mm256_load_pd(&B[i*N+j+60]);
*/		
		 _mm256_store_pd(&A[i*N+j]   ,reg_1 );
/*		 _mm256_store_pd(&A[i*N+j+4] ,reg_2);
		 _mm256_store_pd(&A[i*N+j+8] ,reg_3);
		 _mm256_store_pd(&A[i*N+j+12],reg_4);
		 _mm256_store_pd(&A[i*N+j+16],reg_5);
		 _mm256_store_pd(&A[i*N+j+20],reg_6);
		 _mm256_store_pd(&A[i*N+j+24],reg_7);
		 _mm256_store_pd(&A[i*N+j+28],reg_8);
		 _mm256_store_pd(&A[i*N+j+32] ,reg_9 );
		 _mm256_store_pd(&A[i*N+j+36] ,reg_10);
		 _mm256_store_pd(&A[i*N+j+40] ,reg_11);
		 _mm256_store_pd(&A[i*N+j+44],reg_12);
		 _mm256_store_pd(&A[i*N+j+48],reg_13);
		 _mm256_store_pd(&A[i*N+j+52],reg_14);
		 _mm256_store_pd(&A[i*N+j+56],reg_15);
		
 _mm256_store_pd(&A[i*N+j+64],reg_16);
*/
	    }

    }
    return A;

}
