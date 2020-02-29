%define SYS_WRITE 1
%define SYS_EXIT 60

%define STDOUT_FILENO 1

SECTION .bss
	cbuf: resb 1
	numbuf: resb 32

SECTION .text

global puts
puts:
	mov rdx, 0
.loop:  cmp BYTE[rsi+rdx], `\0`
	je .stop
	inc rdx
	jmp .loop
.stop:  mov rax, SYS_WRITE
	mov rdi, STDOUT_FILENO
	syscall
	ret

global printc
printc:
  mov [cbuf], cl
  mov rax, SYS_WRITE
  mov rdi, STDOUT_FILENO  
  mov rsi, cbuf
  mov rdx, 1
  syscall
  ret

global printnum
printnum:
	mov rax, r15
	lea rsi, [numbuf+32]
	mov BYTE [rsi], 0
	mov rbx, 10
	mov r12, 0
	cmp rax, 0
	jge .loop
	neg rax
	mov r12, 1
.loop:
	cqo
	div rbx
	add dl, '0'
	dec rsi
	mov BYTE [rsi], dl
	cmp rax, 0
	jne .loop
	cmp r12, 1
	jne .skipneg
	dec rsi
	mov BYTE [rsi], '-'
.skipneg:
	call puts
	ret

global printascii
printascii:
 
	mov BYTE r14, rbx
  	mov BYTE cl, `\t`
  	call printc 
  	mov BYTE r15, rbx 
  	call printnum 
  	mov BYTE cl, ':'
  	call printc 
  	mov BYTE cl, ' '
  	call printc 
  	mov BYTE cl, `\'` 
  	call printc
	mov BYTE rbx, r14 
 
 	cmp BYTE rbx, 32
  	jl .jump
	mov rbx, r14
	cmp rbx, 127
	jge .jump
        mov cl, r14b
	call printc
	jmp .jmp	
.jump:
	mov BYTE cl, '.'
	call printc
.jmp:
	mov BYTE cl, `\'`
	call printc
	mov BYTE cl, `\t`
	call printc
	ret 

global exit
exit:
	mov rax, SYS_EXIT
	mov rdi, 0
	syscall
global _start
_start:
	mov BYTE rbx, 0
	mov r13, rbx
.loop:
	cmp rbx, 32
	jge .endfor
    	mov  r13, rbx
    	call printascii
	mov rbx, r13 
    	add rbx, 32 
    	call printascii
	mov rbx, r13 
    	add rbx, 64
    	call printascii 
	mov rbx, r13
    	add BYTE rbx, 96
    	call printascii 
    	mov BYTE cl, `\n` 
    	call printc
	mov rbx, r13 
 	inc rbx
	inc r13
	jmp .loop
.endfor:
	jmp exit
	

