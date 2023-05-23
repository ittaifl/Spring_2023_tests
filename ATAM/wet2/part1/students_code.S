.global	keyMixing, byteSubstitution, shiftRows, cipher

.section	.data
sbox:	.byte	99,124,119,123,-14,107,111,-59,48,1,103,43,-2,-41,-85,118
		.byte	-54,-126,-55,125,-6,89,71,-16,-83,-44,-94,-81,-100,-92,114,-64
		.byte	-73,-3,-109,38,54,63,-9,-52,52,-91,-27,-15,113,-40,49,21
		.byte	4,-57,35,-61,24,-106,5,-102,7,18,-128,-30,-21,39,-78,117
		.byte	9,-125,44,26,27,110,90,-96,82,59,-42,-77,41,-29,47,-124
		.byte	83,-47,0,-19,32,-4,-79,91,106,-53,-66,57,74,76,88,-49
		.byte	-48,-17,-86,-5,67,77,51,-123,69,-7,2,127,80,60,-97,-88
		.byte	81,-93,64,-113,-110,-99,56,-11,-68,-74,-38,33,16,-1,-13,-46
		.byte	-51,12,19,-20,95,-105,68,23,-60,-89,126,61,100,93,25,115
		.byte	96,-127,79,-36,34,42,-112,-120,70,-18,-72,20,-34,94,11,-37
		.byte	-32,50,58,10,73,6,36,92,-62,-45,-84,98,-111,-107,-28,121
		.byte	-25,-56,55,109,-115,-43,78,-87,108,86,-12,-22,101,122,-82,8
		.byte	-70,120,37,46,28,-90,-76,-58,-24,-35,116,31,75,-67,-117,-118
		.byte	112,62,-75,102,72,3,-10,14,97,53,87,-71,-122,-63,29,-98
		.byte	-31,-8,-104,17,105,-39,-114,-108,-101,30,-121,-23,-50,85,40,-33
		.byte	-116,-95,-119,13,-65,-26,66,104,65,-103,45,15,-80,84,-69,22

.section	.text
keyMixing:
	pushq %rbp
	movq %rsp, %rbp
	
	xorq %r10, %r10
	xorq %r11, %r11
	
	movq (%rsi), %r10 #r10 = key[0] (r10 = first 64 bits of key)
	movq 8(%rsi), %r11 #r10 = key[1] (r11 = next 64 bits of key)
	
	xorq %r10, (%rdi)
	xorq %r11, 8(%rdi)
	
	movq %rbp,%rsp
	popq %rbp
	ret


byteSubstitution:
	pushq %rbp
	movq %rsp, %rbp
	
	leaq sbox(%rip), %r9 #r9 is a pointer to sbox
	xorq %r10, %r10 #r10 = index in input
	xorq %rax, %rax
	xorq %rbx, %rbx
	
	sub_loop:
		movb (%rdi, %r10), %al 
		movb (%r9, %rax), %bl 
		movb %bl, (%rdi,%r10)
		
		inc %r10
		cmpq $16, %r10
		jne sub_loop
	
	movq %rbp,%rsp
	popq %rbp
	ret


shiftRows:
	pushq %rbp
	movq %rsp, %rbp
	
	xorq %rax, %rax
	xorq %rbx, %rbx
	xorq %rcx, %rcx
	xorq %rdx, %rdx
	
	#we dont change the first row
	#second row 
	movb 4(%rdi), %al
	movb 5(%rdi), %bl
	movb 6(%rdi), %cl
	movb 7(%rdi), %dl
	
	movb %bl, 4(%rdi)
	movb %cl, 5(%rdi)
	movb %dl, 6(%rdi)
	movb %al, 7(%rdi)	
	
	#third row 
	movb 8(%rdi), %al
	movb 9(%rdi), %bl
	movb 10(%rdi), %cl
	movb 11(%rdi), %dl
	
	movb %cl, 8(%rdi)
	movb %dl, 9(%rdi)
	movb %al, 10(%rdi)
	movb %bl, 11(%rdi)	
	
	#forth row 
	movb 12(%rdi), %al
	movb 13(%rdi), %bl
	movb 14(%rdi), %cl
	movb 15(%rdi), %dl
	
	movb %dl, 12(%rdi)
	movb %al, 13(%rdi)
	movb %bl, 14(%rdi)
	movb %cl, 15(%rdi)	
	movq %rbp,%rsp
	popq %rbp
	ret


cipher:
	pushq %rbp
	movq %rsp, %rbp
	
	cipher_loop:
		#stage a
		pushq %rdi
		pushq %rsi
		pushq %rdx
		call keyMixing
		popq %rdx
		popq %rsi
		popq %rdi
		
		#stage b
		xor %r9, %r9
		b_loop:
			pushq %rdi
			pushq %rsi
			pushq %rdx
			pushq %r9
			call byteSubstitution
			popq %r9
			popq %rdx
			popq %rsi
			popq %rdi
			
			pushq %rdi
			pushq %rsi
			pushq %rdx
			pushq %r9
			call shiftRows
			popq %r9
			popq %rdx
			popq %rsi
			popq %rdi
			
			pushq %rdi
			pushq %rsi
			pushq %rdx
			pushq %r9
			call mixColumns
			popq %r9
			popq %rdx
			popq %rsi
			popq %rdi
			
			pushq %rdi
			pushq %rsi
			pushq %rdx
			pushq %r9
			call keyMixing
			popq %r9
			popq %rdx
			popq %rsi
			popq %rdi
			
			inc %r9
			cmpq $9, %r9
			jne b_loop

		#stage c
		pushq %rdi
		pushq %rsi
		pushq %rdx
		call byteSubstitution
		popq %rdx
		popq %rsi
		popq %rdi
		
		#stage d
		pushq %rdi
		pushq %rsi
		pushq %rdx
		call shiftRows
		popq %rdx
		popq %rsi
		popq %rdi
		
		#stage e
		pushq %rdi
		pushq %rsi
		pushq %rdx
		call keyMixing
		popq %rdx
		popq %rsi
		popq %rdi
		
		addq $16, %rdi
		decq %rdx
		cmpq $0, %rdx
		jne cipher_loop
		
	
	movq %rbp,%rsp
	popq %rbp
	ret
