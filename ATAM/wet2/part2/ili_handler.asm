.globl my_ili_handler

.text
.align 4, 0x90
my_ili_handler:
  ####### Some smart student's code here #######
  
	pushq %rsp
	pushq %rax
	pushq %rsi
	pushq %rdx
	pushq %rcx
	pushq %r8
	pushq %r9
	pushq %r10
	pushq %r11
	pushq %r12
	pushq %r13
	pushq %r14
	pushq %r15
	pushq %rbx
	pushq %rbp 
	xor %r9, %r9
	xor %rdi, %rdi
	xor %rax, %rax
	movq 120(%rsp), %r10
	movq (%r10), %r8
	movw %r8w, %r9w
	cmp $0x0F, %r8b
	jne one_byte	
	shrw $8, %r9w
	movb %r9b, %dil
	call what_to_do
	cmp $0, %rax
	je is_zero
	movq %rax, %rdi
	popq %rbp
	popq %rbx
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rax
	popq %rsp
	add $2, (%rsp)
	jmp end_hw2
	
one_byte:
	movb %r9b, %dil
	call what_to_do
	cmp $0, %rax
	je is_zero
	movq %rax, %rdi
	popq %rbp
	popq %rbx
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rax
	popq %rsp
	add $1, (%rsp)
	jmp end_hw2	
is_zero:
  	popq %rbp
	popq %rbx
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %r11
	popq %r10
	popq %r9
	popq %r8
	popq %rcx
	popq %rdx
	popq %rsi
	popq %rax
	popq %rsp
	jmp * old_ili_handler
	
end_hw2:
	iretq
