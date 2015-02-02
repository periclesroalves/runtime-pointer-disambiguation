


//#include "iacaMarks.h"
#include "memcpy.h"
#include "helper.h"
#include "jacobi3d_generated.h"
//#include "jacobi3d_generated_non_intrinsic.h"
//#include "omp.h"
using namespace std;
void max_gflops()
{
    double start = rtclock();
    double* hello;
    hello = memcpy_opt(N,TSTEPS);
    double end = rtclock();
    double flops = (N)*(N)*5.0;
    flops *=TSTEPS;
    double gflops = flops/((end-start)*1000000000);
    cout<<"Fast Time "<<(end-start)<<endl;
    
    cout<<"Peak Gflops "<<gflops<<endl;
}


void jacobi3d()
{

    double* A __attribute__((aligned(32))) = new double[(N+4)*(N+2)*(N+2)] ;
    double* B __attribute__((aligned(32))) = new double[(N+4)*(N+2)*(N+2)] ;

    double start = rtclock();
    for(int t = 0; t< TSTEPS/2; t++)
    {
	for(int k = 1; k< N+1 ; k++)
	{
	for(int i = 1; i< N+1 ; i++)
	{

//	    IACA_START

	    for(int j = 4; j< N+4 ; j++)
	    {
		B[k*(N+2)*(N+2)+i*(N+2)+j]=0.2* (A[(k-1)*(N+2)*(N+2)+i*(N+2)+j] + A[(k+1)*(N+2)*(N+2)+i*(N+2)+j] + A[k*(N+2)*(N+2)+i*(N+2)+j] +
						 A[k*(N+2)*(N+2)+(i-1)*(N+2)+j] + A[k*(N+2)*(N+2)+(i+1)*(N+2)+j] + A[k*(N+2)*(N+2)+i*(N+2)+j-1] + 
						 A[k*(N+2)*(N+2)+i*(N+2)+j+1]);
	    }
	}
	}
//	IACA_END
	for(int k = 1; k< N+1 ; k++)
	{
	    for(int i = 1; i< N+1 ; i++)
	    {

//	    IACA_START

		for(int j = 4; j< N+4 ; j++)
		{
		    A[k*(N+2)*(N+2)+i*(N+2)+j]=0.2* (B[(k-1)*(N+2)*(N+2)+i*(N+2)+j] + B[(k+1)*(N+2)*(N+2)+i*(N+2)+j] + B[k*(N+2)*(N+2)+i*(N+2)+j]+
						     B[k*(N+2)*(N+2)+(i-1)*(N+2)+j] + B[k*(N+2)*(N+2)+(i+1)*(N+2)+j] + B[k*(N+2)*(N+2)+i*(N+2)+j-1] + 
						     B[k*(N+2)*(N+2)+i*(N+2)+j+1]);
		}
	    }
	}
    }	
    double end = rtclock();
    double flops = N*N*N*7.0;
    flops *=TSTEPS;
    double gflops = flops/((end-start)*1000000000);
    cout<<"Time "<<(end-start)<<endl;
    
    cout<<" Gflops Straight Achieved "<<gflops<<endl;
}




int main(int argc, char** argv)
{
    cout<<"Total size is : "<<2*N*N*N*8/1024<<"KB."<<endl;
    //max_gflops();
    //jacobi3d();
    /*double start =rtclock();
#pragma omp parallel
{
    jacobi3d_auto_generated();
}
double end=rtclock();
    double flops = N*N*N*7.0*4;
    flops *=TSTEPS;
    double gflops = flops/((end-start)*1000000000);
    cout<<"Time "<<(end-start)<<endl;
    
    cout<<" Gflops Straight Achieved Parallel"<<gflops<<endl;*/
    jacobi3d_auto_generated();
    //jacobi3d_auto_generated_no_intrinsic(); 
   return 0;
}
