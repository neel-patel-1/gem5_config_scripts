#include <stdio.h>
#include <sys/sysinfo.h>
#include <stdlib.h>
#include <unistd.h>
int main(void) {
        int i;
        long int freemem = 2048*1024*25;        int chunks = freemem / sizeof(long long int);
        printf("free memory size: %ld Bytes, long long int chuncks %d\n", freemem, chunks);
        long long int *ptr = (long long int *) malloc(chunks * sizeof(long long int));        for (i=0; i < chunks; i++) {
                ptr[i] = 1;
        }        printf("%lld\n",ptr[0]);
	while (1) {
	}
        free(ptr);
        return 0;
}
