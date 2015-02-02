#include <iostream>
#include "input.h"

using namespace std;
void jacobi3d_partial_round_robin()
{

    cout<<"#include \"jacobi3d_generated.h\""<<endl;

    if(IACA_CODE) cout<<"#include \"iacaMarks.h\""<<endl;
    cout<<"#define _mm256_load_pd_my(addr)  _mm256_load_pd(&((addr)->num))"<<endl;
    cout<<"#define _mm256_store_pd_my(addr,var)  _mm256_store_pd(&((addr)->num),var)"<<endl;
    cout<<"struct doubleAllign64 {double num;}  __attribute__((aligned(64)));"<<endl;
    
    cout<<"using namespace std;"<<endl;

    cout<<"void jacobi3d_auto_generated()"<<endl;
    cout<<"{                                                                    "<<endl;
    cout<<"    double __attribute__((aligned(32))) cnst[4];       "<<endl;
    cout<<"    cnst[0] = 0.2;							"<<endl;
    cout<<"    cnst[1] = 0.2;							"<<endl;
    cout<<"    cnst[2] = 0.2;							"<<endl;
    cout<<"    cnst[3] = 0.2;							"<<endl;

    cout<<"    __m256d a["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d b["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d l["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d r["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];		             			"<<endl;
    cout<<"    __m256d cns = _mm256_load_pd(cnst);					"<<endl;

    cout<<"    static doubleAllign64  A[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    static doubleAllign64  B[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) A[i] = i*5.21;                  "<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) B[i] = i*7.21;                  "<<endl;
    cout<<"    double start = rtclock();						"<<endl;
    cout<<"										"<<endl;
    cout<<"    for(int t = 0; t< TSTEPS/2; t++)			         		"<<endl;
    cout<<"    {									"<<endl;

    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;

    if(IACA_CODE) cout<<"     IACA_START                                                "<<endl;

    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		}
	    }

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;

		    cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    

		}
	
	
    cout<<"	    }									"<<endl;
    if(IACA_CODE) cout<<"	IACA_END       					       	"<<endl;

    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }                                                                          "<<endl;
    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;
   
    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

	    }
		
	    }
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		    
		}
		    
	
	
    cout<<"	    }									"<<endl;
    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }          								"<<endl;

    cout<<"										"<<endl;



    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"    }									"<<endl;
    cout<<"    double end = rtclock();				        		"<<endl;
    cout<<"    double flops = N*N*N*7.0;					        	"<<endl;
    cout<<"    flops *=TSTEPS;	            						"<<endl;
    cout<<"    double gflops = flops/((end-start)*1000000000);	         		"<<endl;
    cout<<"    cout<<\"Time \"<<(end-start)<<endl;					"<<endl;
    cout<<"    						        			"<<endl;
    cout<<"    cout<<\" Gflops Auto Generated \"<<gflops<<endl;	        	"<<endl;
    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"}                                                                            "<<endl;

}
void jacobi3d_round_robin()
{

   cout<<"#include \"jacobi3d_generated.h\""<<endl;

    if(1) cout<<"#include \"iacaMarks.h\""<<endl;
    
    cout<<"using namespace std;"<<endl;

    cout<<"void jacobi3d_auto_generated()"<<endl;
    cout<<"{                                                                    "<<endl;
    cout<<"    double* cnst = new double[4] __attribute__((aligned(32)));       "<<endl;
    cout<<"    cnst[0] = 0.2;							"<<endl;
    cout<<"    cnst[1] = 0.2;							"<<endl;
    cout<<"    cnst[2] = 0.2;							"<<endl;
    cout<<"    cnst[3] = 0.2;							"<<endl;

    cout<<"    __m256d a["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d b["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d l["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d r["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];		             			"<<endl;
    cout<<"    __m256d cns = _mm256_load_pd(cnst);					"<<endl;

    cout<<"    double* A = new double[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    double* B = new double[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) A[i] = i*5.21;                  "<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) B[i] = i*7.21;                  "<<endl;
    cout<<"    __assume_aligned(A,32);                                                  "<<endl;
    cout<<"    __assume_aligned(B,32);                                                  "<<endl;
    cout<<"    double start = rtclock();						"<<endl;
    cout<<"										"<<endl;
    cout<<"    for(int t = 0; t< TSTEPS/2; t++)			         		"<<endl;
    cout<<"    {									"<<endl;

    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;

    if(IACA_CODE) cout<<"     IACA_START                                                "<<endl;

    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		}
	    }

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    if(IACA_CODE) cout<<"	IACA_END       					       	"<<endl;

    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }                                                                          "<<endl;
    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;
   
    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

	    }
		
	    }
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    
		}
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    
		    cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
		    
	
	
    cout<<"	    }									"<<endl;
    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }          								"<<endl;

    cout<<"										"<<endl;



    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"    }									"<<endl;
    cout<<"    double end = rtclock();				        		"<<endl;
    cout<<"    double flops = N*N*N*7.0;					        	"<<endl;
    cout<<"    flops *=TSTEPS;	            						"<<endl;
    cout<<"    double gflops = flops/((end-start)*1000000000);	         		"<<endl;
    cout<<"    cout<<\"Time \"<<(end-start)<<endl;					"<<endl;
    cout<<"    						        			"<<endl;
    cout<<"    cout<<\" Gflops Auto Generated \"<<gflops<<endl;	        	"<<endl;
    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"}                                                                            "<<endl;

}

void jacobi3d_reduced_chain()
{

   cout<<"#include \"jacobi3d_generated.h\""<<endl;

    if(IACA_CODE) cout<<"#include \"iacaMarks.h\""<<endl;
    
    cout<<"using namespace std;"<<endl;

    cout<<"void jacobi3d_auto_generated()"<<endl;
    cout<<"{                                                                    "<<endl;
    cout<<"    double* cnst = new double[4] __attribute__((aligned(32)));       "<<endl;
    cout<<"    cnst[0] = 0.2;							"<<endl;
    cout<<"    cnst[1] = 0.2;							"<<endl;
    cout<<"    cnst[2] = 0.2;							"<<endl;
    cout<<"    cnst[3] = 0.2;							"<<endl;

    cout<<"    __m256d a["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d temp1, temp2, temp3, temp4;	                    	"<<endl;
    cout<<"    __m256d b["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d l["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d r["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];		             			"<<endl;
    cout<<"    __m256d cns = _mm256_load_pd(cnst);					"<<endl;

    cout<<"    double* A = new double[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    double* B = new double[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) A[i] = i*5.21;                  "<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) B[i] = i*7.21;                  "<<endl;
    cout<<"    __assume_aligned(A,32);                                                  "<<endl;
    cout<<"    __assume_aligned(B,32);                                                  "<<endl;
    cout<<"    double start = rtclock();						"<<endl;
    cout<<"										"<<endl;
    cout<<"    for(int t = 0; t< TSTEPS/2; t++)			         		"<<endl;
    cout<<"    {									"<<endl;

    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;

    if(IACA_CODE) cout<<"     IACA_START                                                "<<endl;

    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		}
	    }

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 temp1 ="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 temp2 ="
			<<"_mm256_add_pd(a["<<depth-1<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
	   
		    cout<<"                 temp3 ="
			<<"_mm256_add_pd(l["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;

		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],temp1);"<<endl;

		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],temp2);"<<endl;

		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],temp3);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    if(IACA_CODE) cout<<"	IACA_END       					       	"<<endl;

    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }                                                                          "<<endl;
    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;
   
    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

	    }
		
	    }
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0; col<NUM_COL+0;col++)
		{
		    cout<<"                 temp1 ="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 temp2 ="
			<<"_mm256_add_pd(a["<<depth-1<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
	   
		    cout<<"                 temp3 ="
			<<"_mm256_add_pd(l["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;

		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],temp1);"<<endl;

		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],temp2);"<<endl;

		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],temp3);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }          								"<<endl;

    cout<<"										"<<endl;



    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"    }									"<<endl;
    cout<<"    double end = rtclock();				        		"<<endl;
    cout<<"    double flops = N*N*N*7.0;					        	"<<endl;
    cout<<"    flops *=TSTEPS;	            						"<<endl;
    cout<<"    double gflops = flops/((end-start)*1000000000);	         		"<<endl;
    cout<<"    cout<<\"Time \"<<(end-start)<<endl;					"<<endl;
    cout<<"    						        			"<<endl;
    cout<<"    cout<<\" Gflops Auto Generated \"<<gflops<<endl;	        	"<<endl;
    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"}                                                                            "<<endl;

}

void jacobi3d_simple()
{

    cout<<"#include \"jacobi3d_generated.h\""<<endl;
    if(0) cout<<"#include \"iacaMarks.h\""<<endl;
    cout<<"#define _mm256_load_pd_my(addr)  _mm256_load_pd(&((addr)->num))"<<endl;
    cout<<"#define _mm256_store_pd_my(addr,var)  _mm256_store_pd(&((addr)->num),var)"<<endl;
    cout<<"struct doubleAllign64 {double num;}  __attribute__((aligned(64)));"<<endl;
    
    cout<<"using namespace std;"<<endl;

    cout<<"void jacobi3d_auto_generated()"<<endl;
    cout<<"{                                                                    "<<endl;
    cout<<"    double __attribute__((aligned(32))) cnst[4];       "<<endl;
    cout<<"    cnst[0] = 0.2;							"<<endl;
    cout<<"    cnst[1] = 0.2;							"<<endl;
    cout<<"    cnst[2] = 0.2;							"<<endl;
    cout<<"    cnst[3] = 0.2;							"<<endl;

    cout<<"    __m256d a["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d b["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d l["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d r["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];		             			"<<endl;
    cout<<"    __m256d cns = _mm256_load_pd(cnst);					"<<endl;

    cout<<"    static doubleAllign64  A[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    static doubleAllign64  B[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) A[i].num = i*5.21;                  "<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) B[i].num = i*7.21;                  "<<endl;
    cout<<"    double start = rtclock();						"<<endl;
    cout<<"										"<<endl;
    cout<<"    for(int t = 0; t< TSTEPS/2; t++)			         		"<<endl;
    cout<<"    {									"<<endl;

    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;

    if(IACA_CODE) cout<<"     IACA_START                                                "<<endl;

    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		}
	    }

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    if(IACA_CODE) cout<<"	IACA_END       					       	"<<endl;

    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }                                                                          "<<endl;
    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;
   
    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

	    }
		
	    }
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0; col<NUM_COL+0;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }          								"<<endl;

    cout<<"										"<<endl;



    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"    }									"<<endl;
    cout<<"    double end = rtclock();				        		"<<endl;
    cout<<"    double flops = N*N*N*7.0;					        	"<<endl;
    cout<<"    flops *=TSTEPS;	            						"<<endl;
    cout<<"    double gflops = flops/((end-start)*1000000000);	         		"<<endl;
    cout<<"    cout<<\"Time \"<<(end-start)<<endl;					"<<endl;
    cout<<"    						        			"<<endl;
    cout<<"    cout<<\" Gflops Auto Generated \"<<gflops<<endl;	        	"<<endl;
    cout<<"										"<<endl;
    cout<<"    bool printABContent = false;					"<<endl;    
    cout<<"    cout.precision(5);					"<<endl;
    cout<<"    if(printABContent)cout<<\"A:\";					"<<endl;
    cout<<"    unsigned long AXor=0; 														"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++){         					"<<endl;
    cout<<"         if(printABContent)cout<<A[i].num<<\",\";					"<<endl;
    cout<<"         AXor ^= *((unsigned long*)&(A[i].num));					"<<endl;                   
    cout<<"    }					"<<endl;
    cout<<"    cout<<\"\\n\";					"<<endl;
    cout<<"    if(printABContent)cout<<\"B:\";						"<<endl;
    cout<<"    unsigned long BXor=0;													"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) {					"<<endl;
    cout<<"        if(printABContent)cout<<B[i].num<<\",\";                					"<<endl;
    cout<<"        BXor ^= *((unsigned long*) &(B[i].num));					"<<endl;
    cout<<"    }  					"<<endl;
    cout<<"    cout<<\"\\n\";    					"<<endl;
    cout<<"    cout<<\"AXor:\"<<AXor<<\"\\n\";					"<<endl;
    cout<<"    cout<<\"BXor:\"<<BXor<<\"\\n\";					"<<endl;
    cout<<"    cout<<\"AXor^BXor:\"<<(AXor^BXor)<<\"\\n\";								"<<endl;
    cout<<"										"<<endl;
    cout<<"}                                                                            "<<endl;

}


void jacobi3d_depth_unroll()
{

   cout<<"#include \"jacobi3d_generated.h\""<<endl;
    if(1) cout<<"#include \"iacaMarks.h\""<<endl;
    
    cout<<"using namespace std;"<<endl;

    cout<<"void jacobi3d_auto_generated()"<<endl;
    cout<<"{                                                                    "<<endl;
    cout<<"    double* cnst = new double[4] __attribute__((aligned(32)));       "<<endl;
    cout<<"    cnst[0] = 0.2;							"<<endl;
    cout<<"    cnst[1] = 0.2;							"<<endl;
    cout<<"    cnst[2] = 0.2;							"<<endl;
    cout<<"    cnst[3] = 0.2;							"<<endl;

    cout<<"    __m256d a["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d b["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d l["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];				        	"<<endl;
    cout<<"    __m256d r["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"];		             			"<<endl;
    cout<<"    __m256d cns = _mm256_load_pd(cnst);					"<<endl;

    cout<<"    double* A = new double[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    double* B = new double[(N+8)*(N+2)*(N+2)] __attribute__((aligned(64)));	"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) A[i] = i*5.21;                  "<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) B[i] = i*7.21;                  "<<endl;
    cout<<"    __assume_aligned(A,32);                                                  "<<endl;
    cout<<"    __assume_aligned(B,32);                                                  "<<endl;
    cout<<"    double start = rtclock();						"<<endl;
    cout<<"										"<<endl;
    cout<<"    for(int t = 0; t< TSTEPS/2; t++)			         		"<<endl;
    cout<<"    {									"<<endl;

    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;

    if(IACA_CODE) cout<<"     IACA_START                                                "<<endl;
    int depth = 0;

	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		}

		if(depth == NUM_DEPTH-1)
		{
		    cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
			<<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		}
	    }

	for(depth =1; depth<NUM_DEPTH;depth++){
	    for(int row =0; row<NUM_ROW;row++){
		for(int col =0; col<NUM_COL;col++)
		{
		    cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
			<<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		    
		    cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
			<<"=_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		    cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
			<<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		    if(row == 0)
		    {
			cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
			cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		    }

		    if(depth == 0)
		    {
			cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		    }
		    
		    if(depth == NUM_DEPTH-1)
		    {
			cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		    }

		}
	    }

	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0 ; col<NUM_COL;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	}

	depth = NUM_DEPTH;
	for(int row = 1; row<NUM_ROW+1;row++)
	    for(int col = 0 ; col<NUM_COL;col++)
	    {
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
		    <<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
	    }
	
    cout<<"	    }									"<<endl;
    if(IACA_CODE) cout<<"	IACA_END       					       	"<<endl;

    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }                                                                          "<<endl;
    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = 4; j< N+4 ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;
   
    depth = 0;
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
		    <<"=_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}

		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}
		if(depth == NUM_DEPTH-1)
		{
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}
		
	    }
        for(int depth = 1; depth<NUM_DEPTH;depth++){
	    for(int row =0; row<NUM_ROW;row++)
		for(int col =0; col<NUM_COL;col++)
		{
		    cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
			<<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		    cout<<"                 l["<<depth+1<<"]["<<row+1<<"]["<<col<<"]"
			<<"=_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"-1);"<<endl;

		    cout<<"                 r["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
			<<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<"+1);"<<endl;

		    if(row == 0)
		    {
			cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
			cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		    }

		    if(depth == 0)
		    {
			cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		    }
		    if(depth == NUM_DEPTH-1)
		    {
			cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col<<"]="
			    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		    }
		
		}

	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col = 0; col<NUM_COL+0;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	}

	depth = NUM_DEPTH;

	for(int row = 1; row<NUM_ROW+1;row++)
	    for(int col = 0; col<NUM_COL+0;col++)
	    {
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],l["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],r["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
		    <<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
		    <<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
	    }


    cout<<"	    }									"<<endl;
    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }          								"<<endl;

    cout<<"										"<<endl;



    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"    }									"<<endl;
    cout<<"    cout <<\"In depth Unroll \"<<endl;		        		"<<endl;
    cout<<"    double end = rtclock();				        		"<<endl;
    cout<<"    double flops = N*N*N*7.0;					        	"<<endl;
    cout<<"    flops *=TSTEPS;	            						"<<endl;
    cout<<"    double gflops = flops/((end-start)*1000000000);	         		"<<endl;
    cout<<"    cout<<\"Time \"<<(end-start)<<endl;					"<<endl;
    cout<<"    						        			"<<endl;
    cout<<"    cout<<\" Gflops Auto Generated \"<<gflops<<endl;	        	"<<endl;
    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"}                                                                            "<<endl;

}

void jacobi3d_DLT()
{

   cout<<"#include \"jacobi3d_generated.h\""<<endl;

    if(IACA_CODE) cout<<"#include \"iacaMarks.h\""<<endl;
    
    cout<<"using namespace std;"<<endl;

    cout<<"void jacobi3d_auto_generated()"<<endl;
    cout<<"{                                                                    "<<endl;
    cout<<"    double* cnst = new double[4] __attribute__((aligned(32)));       "<<endl;
    cout<<"    cnst[0] = 0.2;							"<<endl;
    cout<<"    cnst[1] = 0.2;							"<<endl;
    cout<<"    cnst[2] = 0.2;							"<<endl;
    cout<<"    cnst[3] = 0.2;							"<<endl;

    cout<<"    __m256d a["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"+2];				        	"<<endl;
    cout<<"    __m256d b["<<NUM_DEPTH<<"+2]["<<NUM_ROW<<"+2]["<<NUM_COL<<"+2];				        	"<<endl;
    cout<<"    __m256d cns = _mm256_load_pd(cnst);					"<<endl;

    cout<<"    double* A = new double[(N+2)*(N+2)*(N+2*"<<VEC_WIDTH<<")] __attribute__((aligned(32)));	"<<endl;
    cout<<"    double* B = new double[(N+2)*(N+2)*(N+2*"<<VEC_WIDTH<<")] __attribute__((aligned(32)));	"<<endl;
    cout<<"    double start = rtclock();						"<<endl;
    cout<<"										"<<endl;
    cout<<"    for(int t = 0; t< TSTEPS/2; t++)			         		"<<endl;
    cout<<"    {									"<<endl;

    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = "<<VEC_WIDTH<<"; j< N+"<<VEC_WIDTH<<" ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;

    if(IACA_CODE) cout<<"     IACA_START                                                "<<endl;

    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		
		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}
		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}
		if(col == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col-1<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<NUM_COL+1<<"]="
		    <<"_mm256_load_pd_my(A+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<NUM_COL<<"*"<<VEC_WIDTH<<");"<<endl;

		}

	    }

        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col =1; col<NUM_COL+1;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row<<"]["<<col+1<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row<<"]["<<col-1<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    if(IACA_CODE) cout<<"	IACA_END       					       	"<<endl;

    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }                                                                          "<<endl;
    cout<<"	for(int k = 1; k< N+1 ; k = k + "<<NUM_DEPTH<<")			"<<endl;
    cout<<"	{									"<<endl;
   
    cout<<"	  for(int i = 1; i< N+1 ; i = i + "<<NUM_ROW<<")			"<<endl;
    cout<<"	  {									"<<endl;
    cout<<"	    									"<<endl;
    cout<<"	    for(int j = "<<VEC_WIDTH<<"; j< N+"<<VEC_WIDTH<<" ; j = j + "<<NUM_COL<<" * "<<VEC_WIDTH<<")	"<<endl;
    cout<<"	    {									"<<endl;
   
    for(int depth =0; depth<NUM_DEPTH;depth++)
	for(int row =0; row<NUM_ROW;row++)
	    for(int col =0; col<NUM_COL;col++)
	    {
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		if(row == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<(row-1)<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<NUM_ROW+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<NUM_ROW<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}
		if(depth == 0)
		{
		cout<<"                 a["<<depth<<"]["<<row+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<NUM_DEPTH+1<<"]["<<row+1<<"]["<<col+1<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<NUM_DEPTH<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH<<");"<<endl;

		}
		if(col == 0)
		{
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<col<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<col-1<<"*"<<VEC_WIDTH<<");"<<endl;
		cout<<"                 a["<<depth+1<<"]["<<row+1<<"]["<<NUM_COL+1<<"]="
		    <<"_mm256_load_pd_my(B+(k+"<<depth<<")*(N+2)*(N+2)+(i+"<<row<<")*(N+2)+j+"<<NUM_COL<<"*"<<VEC_WIDTH<<");"<<endl;

		}
	    }
        for(int depth = 1; depth<NUM_DEPTH+1;depth++)
	    for(int row = 1; row<NUM_ROW+1;row++)
		for(int col =1; col<NUM_COL+1;col++)
		{
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(a["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row-1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row+1<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth-1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth+1<<"]["<<row<<"]["<<col<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row<<"]["<<col-1<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_add_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],a["<<depth<<"]["<<row<<"]["<<col+1<<"]);"<<endl;
		    
		    cout<<"                 b["<<depth<<"]["<<row<<"]["<<col<<"]="
			<<"_mm256_mul_pd(b["<<depth<<"]["<<row<<"]["<<col<<"],cns);"<<endl<<endl;
		    
		    cout<<"                 _mm256_store_pd_my(A+(k+"<<depth-1<<")*(N+2)*(N+2)+(i+"<<row-1<<")*(N+2)+j+"<<col<<"*"<<VEC_WIDTH
			<<",b["<<depth<<"]["<<row<<"]["<<col<<"]);"<<endl<<endl;
		    
		}
	
	
    cout<<"	    }									"<<endl;
    cout<<"										"<<endl;
    cout<<"     }         								"<<endl;
    cout<<"  }          								"<<endl;

    cout<<"										"<<endl;



    cout<<"										"<<endl;
    cout<<"										"<<endl;
    cout<<"    }									"<<endl;
    cout<<"    double end = rtclock();				        		"<<endl;
    cout<<"    double flops = N*N*N*7.0;					        	"<<endl;
    cout<<"    flops *=TSTEPS;	            						"<<endl;
    cout<<"    double gflops = flops/((end-start)*1000000000);	         		"<<endl;
    cout<<"    cout<<\"Time \"<<(end-start)<<endl;					"<<endl;
    cout<<"    						        			"<<endl;
    cout<<"    cout<<\" Gflops Auto Generated \"<<gflops<<endl;	        	"<<endl;
    cout<<"										"<<endl;
    cout<<"    bool printABContent = false;					"<<endl;    
    cout<<"    cout.precision(5);					"<<endl;
    cout<<"    if(printABContent)cout<<\"A:\";					"<<endl;
    cout<<"    unsigned long AXor=0; 														"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++){         					"<<endl;
    cout<<"         if(printABContent)cout<<A[i].num<<\",\";					"<<endl;
    cout<<"         AXor ^= *((unsigned long*)&(A[i].num));					"<<endl;                   
    cout<<"    }					"<<endl;
    cout<<"    cout<<\"\n\";					"<<endl;
    cout<<"    if(printABContent)cout<<\"B:\";						"<<endl;
    cout<<"    unsigned long BXor=0;													"<<endl;
    cout<<"    for(int i =0; i< (N+8)*(N+2)*(N+2); i++) {					"<<endl;
    cout<<"        if(printABContent)cout<<B[i].num<<\",\";                					"<<endl;
    cout<<"        BXor ^= *((unsigned long*) &(B[i].num));					"<<endl;
    cout<<"    }  					"<<endl;
    cout<<"    cout<<\"\n\";    					"<<endl;
    cout<<"    cout<<\"AXor:\"<<AXor<<\"\n\";					"<<endl;
    cout<<"    cout<<\"BXor:\"<<BXor<<\"\n\";					"<<endl;
    cout<<"    cout<<\"AXor^BXor:\"<<(AXor^BXor)<<\"\n\";								"<<endl;
    cout<<"										"<<endl;
    cout<<"}                                                                            "<<endl;

}

int main(int argc, char* argv[])
{
    //jacobi3d_simple();
    //jacobi3d_partial_round_robin();
    //jacobi3d_round_robin();
   
    jacobi3d_simple();
    //jacobi3d_depth_unroll();
    return 0;
}


