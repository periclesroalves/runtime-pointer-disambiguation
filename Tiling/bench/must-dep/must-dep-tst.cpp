/*
clang -emit-llvm -c must-dep-tst.cpp
opt -load /home/luke2k4/work/inria/llvm/cprog/llvm-passes/MustDep/libMustDep.so -help |  grep aaa
opt -load /home/luke2k4/work/inria/llvm/cprog/llvm-passes/Hello/libMustDep.so -hello --time-passes ../must-dep-tst.bc
*/

#include<stdio.h>
#define ARR_SIZE 300


void printArrayRecursive(int* elem, int cnt)
{
    if(cnt>0)
    {
        printf("%d,",*elem);
        printArrayRecursive(elem+1,cnt-1);
    }
}

void printArrayRecursive(long* elem, int cnt)
{
    if(cnt>0)
    {
        printf("%ld,",*elem);
        printArrayRecursive(elem+1,cnt-1);
    }
}


int main()
{
    printf("Hi from test program\n");

    int K=20;
    int J=254;

    long A[ARR_SIZE] = {0};
    int  B[ARR_SIZE] = {0};
    int  C[ARR_SIZE] = {0};

    int scalar1=3, scalar2=5, scalar3=7;
    int constant = 17;
    int N = 100;

    /*
    for(int i=1; i<I; i++)
    {
    	scalar2 += scalar2;
        for( int j=2; j<J; j=j+3)
        {
        	scalar1 = scalar1 + 2 * scalar2 - scalar3 * 3;

        	scalar3 = scalar1 +4 * j;
        }
    }
    printf("%d",scalar1);
	*/


    /*
    for (long i = 0; i < n; ++i)
    {
    	p[i] = 0.0;
	}
	*/

    /*
    for( int i = 0; i< ARR_SIZE; i++)
    {
        A[i]=i;
        B[i]=2*i;
    }
    */

    /*
    for(int i=1; i<I; i++)
    {
        for( int j=2; j<J; j+=2)
        {
        	//A[j]=0;
            A[j]= A[j+1]+2;
            B[j]= A[j-1];
        }
    }
    */
    
    
    for(int j=2; j<J; j+=3)
    {
        scalar2++;
        A[j] = j; 
        B[j] = A[j-2];
        C[j] = B[j] + scalar2; 
    }
    
        
    unsigned register int j=2;
    //while(j<J)
    for(long k=19;k<K;k+=3)
    {
    	//TODO:if j=1 here, does not find the diff 12-24 if 5 ok
		//TODO: what would be the distance if the step was j+=3?
    	for(j=2;j<J;j+=1)
		{
			A[j]= A[k+j+3]+2;
			B[j]= A[k+j-1];
			B[j]= A[j-2];
			A[k+j-1] = B[j+2];
			scalar1 = B[j+1];
            scalar1 = B[j-1];
            scalar1 ++;
            //B[j+2]=5;
			//j++;
			
			C[j]= scalar1;
			scalar2=C[j-2];
			scalar2 ++;
            scalar2=C[j-2]++;
            
		}
    }
    
    printf("Values of array elements and scalars\n");
    printf("A[]:");
    printArrayRecursive(A,ARR_SIZE);
    printf("\nB[]:");
    printArrayRecursive(B,ARR_SIZE);
    printf("\nC[]:");
    printArrayRecursive(C,ARR_SIZE);
    printf("\nscalar1:%d",scalar1);
    printf("\nscalar2:%d",scalar2);
    printf("\nscalar3:%d",scalar3);
    printf("\n");

}

int AAsmain2()
{
	return 0;
}
