.data
	b:.space 1024
	n:.long 1024
	fs:.asciz "%d"
	fp:.asciz "%d\n"
	id:.space 4
	d:.space 4
	op:.space 4
	err:.asciz "eroare\n"
	p:.asciz "(%d, %d)\n"
	nrop:.space 4
	nra:.space 4
	fpadd:.asciz "%d: (%d, %d)\n"
.text
.global main

add:
	push %ebp
	mov %esp , %ebp
	
	push %edi
	push %ebx
	push %esi
	
	mov 8(%ebp) , %edi
	mov 16(%ebp) , %ebx
	xor %eax , %eax
	
add_nrb: 
	cmp $0 , %ebx 
	jle add_next1
	sub $8 , %ebx
	inc %eax
	jmp add_nrb

add_next1:
	xor %edx , %edx
	xor %ecx , %ecx
	xor %ebx , %ebx

add_rezb:
	cmp $1024 , %ecx
	je add_ret_f
	movb (%edi , %ecx , 1) , %bl
	inc %ecx
	cmp $0 , %ebx
	jne add_rezb
	
	dec %ecx
	mov $1 , %esi
add_rezb_vs:
	cmp %esi , %eax
	je add_rezb_vs_s

	add %esi , %ecx
	cmp $1024 , %ecx
	jge add_ret_f

	movb (%edi , %ecx , 1) , %dl
	cmp $0 , %edx
	jne add_rezb
	sub %esi , %ecx
	inc %esi
	jmp add_rezb_vs

add_rezb_vs_s:
	mov 12(%ebp) , %ebx
	add %ecx , %esi
	dec %esi
	
	push %eax
	push %ecx
	push %edx
	
	push %esi
	push %ecx
	push %ebx
	push $fpadd
	call printf
	add $16 , %esp

	pop %edx
	pop %ecx
	pop %eax	
	
	xor %esi , %esi

add_rezb_vs_s_loop:
	cmp %esi , %eax
	je add_ret_s
	movb %bl , (%edi , %ecx , 1)
	inc %esi
	inc %ecx
	jmp add_rezb_vs_s_loop

add_ret_s:
	pop %esi
	pop %ebx
	pop %edi
	pop %ebp
	ret
add_ret_f:
	xor %ecx , %ecx
	mov 12(%ebp) , %ebx
	push %ecx
	push %ecx
	push %ebx
	push $fpadd
	call printf
	add $16 , %esp
	
        pop %esi
        pop %ebx
        pop %edi
        pop %ebp
        ret
get:
	push %ebp
        mov %esp , %ebp

        push %edi
	push %ebx
        mov 8(%ebp), %edi
        mov 12(%ebp) , %ebx

	xor %ecx , %ecx
	xor %eax , %eax
	xor %edx , %edx
	
get_pd:
	cmp $1024 , %ecx
	je get_ret_f
	movb (%edi , %ecx , 1) , %al
	inc %ecx
	cmp %eax , %ebx
	je get_pre_ps
	jmp get_pd

get_pre_ps:
	mov %ecx , %eax
	dec %ecx

get_ps:
	cmp $1024 , %ecx
        jge get_ret
        movb (%edi , %ecx , 1) , %dl
	cmp %edx , %ebx
	jne get_ret
	inc %ecx
	jmp get_ps

get_ret_f:
	mov $1 , %eax
	mov $1 , %ecx
get_ret:
	mov %ecx  , %edx
	dec %edx
	dec %eax
	pop %ebx 
	pop %edi
	pop %ebp
	ret
delete:
	push %ebp
	mov %esp , %ebp
	
	push %edi
	mov 8(%ebp), %edi
	mov 12(%ebp) , %eax

	xor %ecx , %ecx
	xor %edx , %edx

delete_for:
	cmp n , %ecx
	je delete_ret
	movb (%edi , %ecx , 1) , %dl
	inc %ecx
	cmp %edx , %eax
	je delete_rm
	jmp delete_for
delete_rm:
	dec %ecx
	movb $0 , (%edi , %ecx , 1)
	inc %ecx
	jmp delete_for
delete_ret:
	pop %edi
	pop %ebp
	ret
	
defrag:
	push %ebp
	mov %esp , %ebp
	
	push %edi
	push %esi
	mov 8(%ebp) , %edi

	xor %ecx , %ecx
	xor %edx , %edx
	mov $1 , %esi

defrag_ecx_nz:
	cmp $1024 , %ecx
    je defrag_ret	

	movb (%edi , %ecx , 1) , %dl
	inc %ecx
	cmp $0 , %edx
	jne defrag_ecx_nz
	
	mov %ecx , %esi
	dec %ecx

defrag_esi_z:
	cmp $1024 , %esi
    je defrag_ret	

	movb (%edi , %esi , 1) , %dl
	inc %esi
	cmp $0 , %edx
	je defrag_esi_z

	dec %esi
	movb (%edi , %esi , 1) , %dl
	movb %dl , (%edi , %ecx , 1)
	movb $0 , (%edi , %esi , 1)
	
	jmp defrag_ecx_nz

defrag_ret:
	pop %esi
	pop %edi
	pop %ebp
	ret

afisareI:
	push %ebp
	mov %esp , %ebp
	
	push %ebx
	push %edi
	push %esi
	mov 8(%ebp) , %edi
	
	xor %ebx , %ebx
	xor %esi , %esi
	xor %ecx , %ecx
	xor %edx , %edx

afis_loop:
	cmp $1024 , %esi
	jge afis_ret
	movb (%edi , %esi , 1) , %bl
	inc %esi
	cmp $0 , %ebx
	je afis_loop

	dec %esi
	mov %esi , %ecx

afis_loop2:
	cmp $1024 , %esi
	jge afisI
	inc %esi
	mov (%edi , %esi , 1) , %dl
	cmp %ebx , %edx
	je afis_loop2
afisI:
	dec %esi
	push %eax
	push %ecx
	push %edx

	push %esi
	push %ecx
	push %ebx
	push $fpadd
	call printf
	add $16 , %esp

	pop %edx
	pop %ecx
	pop %eax
	inc %esi	
	jmp afis_loop

afis_ret:
	pop %esi
	pop %edi
	pop %ebx
	pop %ebp
	ret
main:
	
	xor %ecx , %ecx
	lea b , %edi
	
et_reset_b:
	cmp $1024 , %ecx
	je et_pre_op
	movb $0 , (%edi , %ecx , 1)
	inc %ecx
	jmp et_reset_b
	
et_pre_op:
	push $nrop
	push $fs
	call scanf
	add $8 , %esp

	xor %esi , %esi
et_op:
	cmp nrop , %esi
	je et_exit
	
	inc %esi	

	push $op
	push $fs
	call scanf
	add $8 , %esp
	
	mov op , %eax
	cmp $0 , %eax
	je afisare_intervale
	cmp $1 , %eax
	je pre_apel_add
	cmp $2 , %eax
        je apel_get
	cmp $3 , %eax
        je apel_delete
	cmp $4 , %eax
        je apel_defrag
	
	push $err
	call printf
	add $4 , %esp
	jmp et_op

pre_apel_add:
	push $nra
	push $fs
	call scanf
	add $8 , %esp
	push %esi
	xor %esi , %esi
apel_add:
	cmp nra , %esi
	je post_apel_add
	inc %esi
	push $id
	push $fs
	call scanf
	add $8 , %esp
	
	push $d
	push $fs
	call scanf
	add $8 , %esp

	push d
	push id
	push %edi
	call add
	add $12 , %esp
	
	jmp apel_add
post_apel_add:
	pop %esi
	jmp et_op

apel_get:
	push $id
        push $fs
        call scanf
        add $8 , %esp

        push id
        push %edi
        call get
        add $8 , %esp
	
	push %edx
	push %eax
	push $p
	call printf
	add $12 , %esp

	jmp et_op

apel_delete:
        push $id
        push $fs
        call scanf
        add $8 , %esp
	
	push id
	push %edi
	call delete
	add $8 , %esp

afisare_intervale:
	push %edi
	call afisareI
	add $4 , %esp

	jmp et_op
apel_defrag:
	push %edi
	call defrag
	add $4 , %esp

	jmp afisare_intervale
et_exit:
    pushl $0
    call fflush
	popl %eax
	
	mov $1 , %eax
	xor %ebx , %ebx
	int $0x80
