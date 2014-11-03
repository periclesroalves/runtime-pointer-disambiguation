#include <stdio.h>

 void memWrite(char *p, int size)
 {
   int i;
   int j;
   for(i=0; i<size; ++i) 
   {
     for(j=size; j>i; --j) 
     { 
       p[i] = 42; 
       while(*p) 
       {
         p[i] = i; 
         printf("did not clone\n");
       }
     }
   }
 }
 
 void memRead(char *p, int size)
 {
   int i;
   for(i=0; i<size; ++i) p[i] = 42;//printf("*(%p) = %d\n", p, *p);
 }

