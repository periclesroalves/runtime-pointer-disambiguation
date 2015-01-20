/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <stdio.h>
#include <stdlib.h>

void memWrite(char *p, int size);
void memRead(char *p, int size);

/*unsigned char __asan_magic(const void *p);
 * void *mallocTracker_getBasePtr(void *p);
 *
 * #ifdef MTRACK
 *   #define MAGIC(p) *((char *)mallocTracker_getBasePtr(p))
 *   #else
 *     #ifdef ASAN
 *         #define MAGIC(p) __asan_magic(p)
 *           #else
 *               #define MAGIC(p) *(p)
 *                 #endif
 *                 #endif*/

int main(void) 
{ 
        char *p1 = (char *)malloc(1024);
        char *p2 = (char *)malloc(256);
        char *p3 = (char *)malloc(512);
        char *p4 = (char *)malloc(2048);

        /*p1[0] = 1;
 *         p2[0] = 2;
 *                 p3[0] = 3;*/
 
	printf("--- Allocated Regions ---\n"); 
        printf("[%p, %p]\n", p1, p1+1023);
	printf("[%p, %p]\n", p2, p2+255);
	printf("[%p, %p]\n", p3, p3+511);
        printf("[%p, %p]\n", p3, p4+2047);

	/*printf("\n--- Memory Contents---\n");
 *         memRead(p1+512);
 *                 memRead(p2+128);
 *                         memRead(p3+256);*/

        memWrite(p1+512, 128);
        memRead(p1+512, 128);

	free(p1);
	free(p2);
	free(p3);
        free(p4);

        if(p1 != p2 && p3!= p4 && p1!= p4) printf("true\n");
        else printf("false\n");

        return 0;
}
