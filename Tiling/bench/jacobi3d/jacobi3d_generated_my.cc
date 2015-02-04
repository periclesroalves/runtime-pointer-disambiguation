#include "jacobi3d_generated.h"
//#include "iacaMarks.h"
using namespace std;

//https://gcc.gnu.org/ml/gcc/2003-09/msg01033.html

#define OFFSETOF(type, field)    ((unsigned long) &(((type *) 0)->field))
#define _mm256_load_pd_my(addr)  _mm256_load_pd((double*)(addr))
#define _mm256_store_pd_my(addr,var)  _mm256_store_pd((double*)(addr),var)

struct doubleAllign64 {double num;}  __attribute__((aligned(64)));

void jacobi3d_auto_generated()
{                                                                    
    static double __attribute__((aligned(32))) cnst[4];       
    cnst[0] = 0.2;							
    cnst[1] = 0.2;							
    cnst[2] = 0.2;							
    cnst[3] = 0.2;							
    __m256d a[2+2][2+2][2];				        	
    __m256d b[2+2][2+2][2];				        	
    __m256d l[2+2][2+2][2];				        	
    __m256d r[2+2][2+2][2];		             			
    __m256d cns = _mm256_load_pd(cnst);	
    
    /*
    struct doubleA64  AA64[(N+8)*(N+2)*(N+2)];				
    cout<<"Offset of num: "<< OFFSETOF(struct doubleA64, num)<<"\n";	
    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) AA64[i].num = i*5.21;                  
    int offset = 2;	
    cout << "Addr:" << AA64+offset << "\n";
    cout << "Offset:" << offset << "\n";
    cout << "Allign:" << (long)(AA64+offset) % 32  << "\n";
    cout << "Test: "<<"\n";
    a[1][1][0] = _mm256_load_pd(&((AA64+offset)->num));
    cout << "Passed:"<<*((double*)(AA64+offset))<<"\n";
    */
    
    static doubleAllign64  A[(N+8)*(N+2)*(N+2)];	
    static doubleAllign64  B[(N+8)*(N+2)*(N+2)];	
    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) A[i].num = i*5.21;                  
    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) B[i].num = i*7.21;                  
    //doubleAllign64* __attribute__((aligned(32))) A = (doubleA64*) __builtin_assume_aligned(A64,32);                                                  
    //doubleAllign64* __attribute__((aligned(32))) B = (doubleA64*) __builtin_assume_aligned(B64,32);                                                  
    double start = rtclock();						
										
    for(int t = 0; t< TSTEPS/2; t++)			         		
    {									
	for(int k = 1; k< N+1 ; k = k + 2)			
	{									
	  for(int i = 1; i< N+1 ; i = i + 2)			
	  {									
	    									
	    for(int j = 4; j< N+4 ; j = j + 2 * 4)	
	    {								
            /*
            cout << *A << " " << " " << *(A+1) <<" "<<*(A+2)<< "\n";
            int offset = 0;	
            cout << "Addr:" << A+offset << "\n";
            cout << "Offset:" << offset << "\n";
            cout << "Allign:" << (long)(A+offset) % 32  << "\n";
            cout << "Test: "<<"\n";
            a[1][1][0] = _mm256_load_pd(A+offset);
            cout << "Passed"<<"\n";

            offset = 2;	
            cout << "Addr:" << A+offset << "\n";
            cout << "Offset:" << offset << "\n";
            cout << "Allign:" << (long)(A+offset) % 32  << "\n";
            cout << "Test: "<<"\n";
            a[1][1][0] = _mm256_load_pd(A+offset);
            cout << "Passed"<<"\n";

            
            offset = (k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4;
            cout << "Addr:" << A+offset << "\n";
            cout << "Offset:" << offset << "\n";
            cout << "Allign:" << (long)(A+offset) % 32  << "\n";
            cout << "Test: "<<"\n";
             a[1][1][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
             cout << "Passed"<<"\n";                             
            */

                 a[1][1][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 l[1][1][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4-1);
                 r[1][1][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4+1);
                 a[1][0][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+-1)*(N+2)+j+0*4);
                 a[1][3][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+2)*(N+2)+j+0*4);
                 a[0][1][0]=_mm256_load_pd_my(A+(k+-1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 a[3][1][0]=_mm256_load_pd_my(A+(k+2)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 a[1][1][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 l[1][1][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4-1);
                 r[1][1][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4+1);
                 a[1][0][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+-1)*(N+2)+j+1*4);
                 a[1][3][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+2)*(N+2)+j+1*4);
                 a[0][1][1]=_mm256_load_pd_my(A+(k+-1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 a[3][1][1]=_mm256_load_pd_my(A+(k+2)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 a[1][2][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 l[1][2][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4-1);
                 r[1][2][0]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4+1);
                 a[0][2][0]=_mm256_load_pd_my(A+(k+-1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 a[3][2][0]=_mm256_load_pd_my(A+(k+2)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 a[1][2][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 l[1][2][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4-1);
                 r[1][2][1]=_mm256_load_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4+1);
                 a[0][2][1]=_mm256_load_pd_my(A+(k+-1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 a[3][2][1]=_mm256_load_pd_my(A+(k+2)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 a[2][1][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 l[2][1][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4-1);
                 r[2][1][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4+1);
                 a[2][0][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+-1)*(N+2)+j+0*4);
                 a[2][3][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+2)*(N+2)+j+0*4);
                 a[2][1][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 l[2][1][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4-1);
                 r[2][1][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4+1);
                 a[2][0][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+-1)*(N+2)+j+1*4);
                 a[2][3][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+2)*(N+2)+j+1*4);
                 a[2][2][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 l[2][2][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4-1);
                 r[2][2][0]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4+1);
                 a[2][2][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 l[2][2][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4-1);
                 r[2][2][1]=_mm256_load_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4+1);
                 b[1][1][0]=_mm256_add_pd(a[1][1][0],a[1][0][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],a[1][2][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],a[0][1][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],a[2][1][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],l[1][1][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],r[1][1][0]);
                 b[1][1][0]=_mm256_mul_pd(b[1][1][0],cns);

                 _mm256_store_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4,b[1][1][0]);

                 b[1][1][1]=_mm256_add_pd(a[1][1][1],a[1][0][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],a[1][2][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],a[0][1][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],a[2][1][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],l[1][1][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],r[1][1][1]);
                 b[1][1][1]=_mm256_mul_pd(b[1][1][1],cns);

                 _mm256_store_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4,b[1][1][1]);

                 b[1][2][0]=_mm256_add_pd(a[1][2][0],a[1][1][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],a[1][3][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],a[0][2][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],a[2][2][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],l[1][2][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],r[1][2][0]);
                 b[1][2][0]=_mm256_mul_pd(b[1][2][0],cns);

                 _mm256_store_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4,b[1][2][0]);

                 b[1][2][1]=_mm256_add_pd(a[1][2][1],a[1][1][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],a[1][3][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],a[0][2][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],a[2][2][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],l[1][2][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],r[1][2][1]);
                 b[1][2][1]=_mm256_mul_pd(b[1][2][1],cns);

                 _mm256_store_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4,b[1][2][1]);

                 b[2][1][0]=_mm256_add_pd(a[2][1][0],a[2][0][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],a[2][2][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],a[1][1][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],a[3][1][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],l[2][1][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],r[2][1][0]);
                 b[2][1][0]=_mm256_mul_pd(b[2][1][0],cns);

                 _mm256_store_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4,b[2][1][0]);

                 b[2][1][1]=_mm256_add_pd(a[2][1][1],a[2][0][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],a[2][2][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],a[1][1][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],a[3][1][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],l[2][1][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],r[2][1][1]);
                 b[2][1][1]=_mm256_mul_pd(b[2][1][1],cns);

                 _mm256_store_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4,b[2][1][1]);

                 b[2][2][0]=_mm256_add_pd(a[2][2][0],a[2][1][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],a[2][3][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],a[1][2][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],a[3][2][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],l[2][2][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],r[2][2][0]);
                 b[2][2][0]=_mm256_mul_pd(b[2][2][0],cns);

                 _mm256_store_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4,b[2][2][0]);

                 b[2][2][1]=_mm256_add_pd(a[2][2][1],a[2][1][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],a[2][3][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],a[1][2][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],a[3][2][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],l[2][2][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],r[2][2][1]);
                 b[2][2][1]=_mm256_mul_pd(b[2][2][1],cns);

                 _mm256_store_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4,b[2][2][1]);

	    }									
										
     }         								
  }                                                                          
	for(int k = 1; k< N+1 ; k = k + 2)			
	{									
	  for(int i = 1; i< N+1 ; i = i + 2)			
	  {										    									
	    for(int j = 4; j< N+4 ; j = j + 2 * 4)	
	    {									
                 a[1][1][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 l[1][1][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4-1);
                 r[1][1][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4+1);
                 a[1][0][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+-1)*(N+2)+j+0*4);
                 a[1][3][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+2)*(N+2)+j+0*4);
                 a[0][1][0]=_mm256_load_pd_my(B+(k+-1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 a[3][1][0]=_mm256_load_pd_my(B+(k+2)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 a[1][1][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 l[1][1][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4-1);
                 r[1][1][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4+1);
                 a[1][0][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+-1)*(N+2)+j+1*4);
                 a[1][3][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+2)*(N+2)+j+1*4);
                 a[0][1][1]=_mm256_load_pd_my(B+(k+-1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 a[3][1][1]=_mm256_load_pd_my(B+(k+2)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 a[1][2][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 l[1][2][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4-1);
                 r[1][2][0]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4+1);
                 a[0][2][0]=_mm256_load_pd_my(B+(k+-1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 a[3][2][0]=_mm256_load_pd_my(B+(k+2)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 a[1][2][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 l[1][2][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4-1);
                 r[1][2][1]=_mm256_load_pd_my(B+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4+1);
                 a[0][2][1]=_mm256_load_pd_my(B+(k+-1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 a[3][2][1]=_mm256_load_pd_my(B+(k+2)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 a[2][1][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4);
                 l[2][1][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4-1);
                 r[2][1][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4+1);
                 a[2][0][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+-1)*(N+2)+j+0*4);
                 a[2][3][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+2)*(N+2)+j+0*4);
                 a[2][1][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4);
                 l[2][1][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4-1);
                 r[2][1][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4+1);
                 a[2][0][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+-1)*(N+2)+j+1*4);
                 a[2][3][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+2)*(N+2)+j+1*4);
                 a[2][2][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4);
                 l[2][2][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4-1);
                 r[2][2][0]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4+1);
                 a[2][2][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4);
                 l[2][2][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4-1);
                 r[2][2][1]=_mm256_load_pd_my(B+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4+1);
                 b[1][1][0]=_mm256_add_pd(a[1][1][0],a[1][0][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],a[1][2][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],a[0][1][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],a[2][1][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],l[1][1][0]);
                 b[1][1][0]=_mm256_add_pd(b[1][1][0],r[1][1][0]);
                 b[1][1][0]=_mm256_mul_pd(b[1][1][0],cns);

                 _mm256_store_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4,b[1][1][0]);

                 b[1][1][1]=_mm256_add_pd(a[1][1][1],a[1][0][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],a[1][2][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],a[0][1][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],a[2][1][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],l[1][1][1]);
                 b[1][1][1]=_mm256_add_pd(b[1][1][1],r[1][1][1]);
                 b[1][1][1]=_mm256_mul_pd(b[1][1][1],cns);

                 _mm256_store_pd_my(A+(k+0)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4,b[1][1][1]);

                 b[1][2][0]=_mm256_add_pd(a[1][2][0],a[1][1][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],a[1][3][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],a[0][2][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],a[2][2][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],l[1][2][0]);
                 b[1][2][0]=_mm256_add_pd(b[1][2][0],r[1][2][0]);
                 b[1][2][0]=_mm256_mul_pd(b[1][2][0],cns);

                 _mm256_store_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4,b[1][2][0]);

                 b[1][2][1]=_mm256_add_pd(a[1][2][1],a[1][1][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],a[1][3][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],a[0][2][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],a[2][2][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],l[1][2][1]);
                 b[1][2][1]=_mm256_add_pd(b[1][2][1],r[1][2][1]);
                 b[1][2][1]=_mm256_mul_pd(b[1][2][1],cns);

                 _mm256_store_pd_my(A+(k+0)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4,b[1][2][1]);

                 b[2][1][0]=_mm256_add_pd(a[2][1][0],a[2][0][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],a[2][2][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],a[1][1][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],a[3][1][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],l[2][1][0]);
                 b[2][1][0]=_mm256_add_pd(b[2][1][0],r[2][1][0]);
                 b[2][1][0]=_mm256_mul_pd(b[2][1][0],cns);

                 _mm256_store_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+0*4,b[2][1][0]);

                 b[2][1][1]=_mm256_add_pd(a[2][1][1],a[2][0][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],a[2][2][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],a[1][1][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],a[3][1][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],l[2][1][1]);
                 b[2][1][1]=_mm256_add_pd(b[2][1][1],r[2][1][1]);
                 b[2][1][1]=_mm256_mul_pd(b[2][1][1],cns);

                 _mm256_store_pd_my(A+(k+1)*(N+2)*(N+2)+(i+0)*(N+2)+j+1*4,b[2][1][1]);

                 b[2][2][0]=_mm256_add_pd(a[2][2][0],a[2][1][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],a[2][3][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],a[1][2][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],a[3][2][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],l[2][2][0]);
                 b[2][2][0]=_mm256_add_pd(b[2][2][0],r[2][2][0]);
                 b[2][2][0]=_mm256_mul_pd(b[2][2][0],cns);

                 _mm256_store_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+0*4,b[2][2][0]);

                 b[2][2][1]=_mm256_add_pd(a[2][2][1],a[2][1][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],a[2][3][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],a[1][2][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],a[3][2][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],l[2][2][1]);
                 b[2][2][1]=_mm256_add_pd(b[2][2][1],r[2][2][1]);
                 b[2][2][1]=_mm256_mul_pd(b[2][2][1],cns);

                 _mm256_store_pd_my(A+(k+1)*(N+2)*(N+2)+(i+1)*(N+2)+j+1*4,b[2][2][1]);

	    }									
										
     }         								
  }          								
										
										
										
    }									
    double end = rtclock();				        		
    double flops = N*N*N*7.0;					        	
    flops *=TSTEPS;	            						
    double gflops = flops/((end-start)*1000000000);	         		
    cout<<"Time "<<(end-start)<<endl;					    						        			
    cout<<" Gflops Auto Generated "<<gflops<<endl;	        	
    
    bool printABContent = false;
    
    cout.precision(5);
    if(printABContent)cout<<"A:";
	unsigned long AXor=0; 									
    for(int i =0; i< (N+8)*(N+2)*(N+2); i++){         
         if(printABContent)cout<<A[i].num<<",";
         AXor ^= *((unsigned long*)&(A[i].num));                   
    }
    cout<<"\n";
	if(printABContent)cout<<"B:";	
	unsigned long BXor=0;								
    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) {
        if(printABContent)cout<<B[i].num<<",";                
        BXor ^= *((unsigned long*) &(B[i].num));
    }  
    cout<<"\n";
    
    cout<<"AXor:"<<AXor<<"\n";
    cout<<"BXor:"<<BXor<<"\n";

    cout<<"AXor^BXor:"<<(AXor^BXor)<<"\n";			
}                                                                            
