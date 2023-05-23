globl my_ili_handler
.extern what_to_do, old_ili_handler

my_ili_handler:
	pushq %rbp
	movq %rsp, %rbp
	
	#backup registers
	pushq %rax
	pushq %rbx
	pushq %rcx
	pushq %rdi
	pushq %rsi
	pushq %rdx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	
	movq (%rbp), %r8
	movb (%r8), %bl
	cmpb $0x0F, %bl
	jne one_byte
	
	#two byte 
	inc %r8
	
	one_byte:
		
		call 
	
	
	
	
	movq %rbp, %rsp
	popq %rbp
	ret
