.data 
    m:.space 1048576
	s:.space 4096
	f:.space 1024
    adresa:.space 1024

    q:.space 256
    vfq:.long 0

    nrop:.space 4
    op:.space 4
    nradd:.space 4

    id:.space 4
    kb:.space 4

    lims:.space 4

    fsc:.asciz "%d"
    fps:.asciz "%s\n"
	fp1:.asciz "%d\n"
	fp4:.asciz "((%d, %d), (%d, %d))\n"
	fp5:.asciz "%d: ((%d, %d), (%d, %d))\n"
    path:.space 10000
    fsp:.asciz "%s"

    stat_buf: .space 64
    FD:.space 4
.text 
.global main
q_add:
    push %ebp 
    mov %esp , %ebp 

    push %ebx 
    push %edi 
    push %esi 

    mov 8(%ebp) , %edx

    lea q , %edi 
    mov vfq , %ecx 
    movb %dl , (%edi , %ecx , 1)
    incl vfq

    lea adresa , %edi 
    mov (%edi , %edx , 4) , %eax 

    xor %ebx , %ebx
    q_add_loop:
        cmp $0 , %ecx 
        je q_add_ret 

        lea q , %edi 
        movb -1(%edi , %ecx , 1) , %bl 

        lea adresa , %edi 
        mov (%edi , %ebx , 4) , %esi 
        cmp %esi , %eax
        jg q_add_ret

        lea q , %edi 
        movb %dl , -1(%edi , %ecx , 1)
        movb %bl , (%edi , %ecx , 1)
        dec %ecx 
        jmp q_add_loop 
q_add_ret:
    pop %esi 
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret
q_del:
    push %ebp 
    mov %esp , %ebp 
    push %ebx 
    push %edi 

    lea q , %edi 
    mov 8(%ebp) , %ebx
    mov vfq , %edx
    decl vfq 
    xor %ecx , %ecx 
    xor %eax , %eax
    q_del_ps:
        movb (%edi , %ecx , 1) , %al
        inc %ecx  
        cmp %eax , %ebx 
        jne q_del_ps  
    q_del_loop:
        cmp %ecx , %edx 
        je q_ret 
        movb (%edi , %ecx , 1) , %al
        movb %al , -1(%edi , %ecx , 1) 
        inc %ecx
        jmp q_del_loop
q_ret:
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret

f_add:
    push %ebp
    mov %esp , %ebp 

    push %ebx 
    push %edi 
    push %esi

    mov 8(%ebp), %ebx
    xor %eax , %eax
    f_add_nrb:
        cmp $0 , %ebx 
        jle f_add_next_1
        inc %eax 
        sub $8 , %ebx
        jmp f_add_nrb
    
f_add_next_1:
    cmp $2 , %eax 
    jl f_add_ret_f
    cmp $1024 , %eax 
    jg f_add_ret_f
    
    mov 12(%ebp), %edx
    lea f , %edi

    mov (%edi , %edx , 4) , %ebx
    cmp $0 , %ebx 
    jne f_add_ret_f

    mov %eax , (%edi , %edx , 4)


    xor %ebx , %ebx 
    xor %ecx , %ecx
    xor %edx , %edx
    xor %esi , %esi
    f_add_vf_s:
        lea s , %edi 
        mov (%edi , %ebx , 4) , %esi 
        inc %ebx    
        cmp %esi , %eax 
        jg f_add_vf_s 
        
        mov %ebx , %ecx 
        dec %ecx
        shl $10 , %ecx
        add $1024 , %ecx 
        mov %ecx , lims
        sub $1024 , %ecx

        lea m , %edi
        f_add_vf_s_ps:
            cmp lims , %ecx
            jge f_add_vf_s
            movb (%edi , %ecx , 1) , %dl
            inc %ecx
            cmp $0 , %edx
            jne f_add_vf_s_ps
            
            dec %ecx
            mov %eax , %esi
            add %ecx , %esi 
            cmp lims , %esi 
            jg f_add_vf_s

            mov $1 , %esi 
            f_add_vf_s_pd:
                cmp %esi , %eax
                je f_add_next_2
                add %esi , %ecx 
                movb (%edi , %ecx , 1) , %dl 
                cmp $0 , %edx 
                jne f_add_vf_s_ps 
                sub %esi , %ecx 
                inc %esi
                jmp f_add_vf_s_pd
f_add_next_2:
    mov 12(%ebp) , %edx
    add %ecx , %esi    
    f_add_rezb:
        cmp %ecx , %esi 
        je f_add_ret_s
        movb %dl , (%edi , %ecx , 1)
        inc %ecx
        jmp f_add_rezb

f_add_ret_s:
     
    mov 12(%ebp) , %esi

    sub %eax , %ecx
    mov %eax , %ebx
    dec %ebx 
    xor %edx , %edx 
    mov %ecx , %eax
    mov $1024 , %ecx
    
    lea adresa , %edi 
    mov %eax , (%edi , %esi , 4)
    
    div %ecx
    
    lea s, %edi
    mov (%edi , %eax , 4) , %ecx 
    sub %ebx , %ecx 
    dec %ecx
    mov %ecx , (%edi , %eax , 4)
    
    add %edx , %ebx 

    push %ebx 
    push %eax
    push %edx 
    push %eax 
    push %esi 
    push $fp5
    call printf
    add $24 , %esp 

    mov $1 , %eax
    pop %esi 
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret

f_add_ret_f:
    mov 12(%ebp) , %esi
    xor %eax , %eax
    push %eax 
    push %eax
    push %eax 
    push %eax 
    push %esi 
    push $fp5
    call printf
    add $24 , %esp

    mov $0 , %eax
    pop %esi 
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret

f_get:
    push %ebp 
    mov %esp , %ebp
    
    push %ebx 
    push %edi 
    push %esi 

    xor %edx , %edx 

    mov 8(%ebp) , %ebx
    lea f , %edi 
    mov (%edi , %ebx , 4) , %esi
    cmp $0 , %esi 
    je f_get_ret_f

    lea adresa , %edi 
    mov (%edi , %ebx , 4) , %eax 

    mov $1024 , %ecx
    div %ecx

    dec %esi
    add %edx , %esi 

    push %esi 
    push %eax
    push %edx 
    push %eax
    push $fp4 
    call printf
    add $20 , %esp

    pop %esi 
    pop %edi
    pop %ebx 
    pop %ebp 
    ret

f_get_ret_f:
    push %edx
    push %edx
    push %edx
    push %edx
    push $fp4 
    call printf
    add $20 , %esp

    pop %esi 
    pop %edi
    pop %ebx 
    pop %ebp 
    ret 
f_afi: 
    push %ebp 
    mov %esp , %ebp 

    push %ebx 
    push %edi 
    push %esi

    xor %esi , %esi
    xor %ebx , %ebx 
    lea m , %edi 
    f_afi_loop:
        cmp $1048576 , %esi 
        je f_afi_ret
        movb (%edi , %esi , 1) , %bl
        inc %esi
        cmp $0 , %ebx 
        je f_afi_loop 

        xor %edx , %edx
        dec %esi
        mov $1024 , %ecx 
        mov %esi , %eax 
        div %ecx 

        lea f , %edi 
        mov (%edi , %ebx , 4) , %ecx
        add %ecx , %esi 
        dec %ecx 
        add %edx , %ecx

        push %ecx 
        push %eax 
        push %edx 
        push %eax 
        push %ebx 
        push $fp5 
        call printf
        add $24 , %esp 

        lea m , %edi
        jmp f_afi_loop
f_afi_ret:
    pop %esi 
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret 

f_del:
    push %ebp 
    mov %esp , %ebp 

    push %ebx 
    push %edi 
    push %esi 

    mov 8(%ebp), %ebx 

    lea f , %edi 
    mov (%edi , %ebx , 4) , %ecx 
    cmp $0 , %ecx 
    je f_del_ret

    push %ecx

    push %ebx 
    call q_del 
    add $4 , %esp

    pop %ecx

    lea adresa , %edi 
    mov (%edi , %ebx , 4) , %esi 
    mov %esi , %eax
    add %ecx , %eax

    xor %edx , %edx
    lea m , %edi 
    f_del_loop:
        cmp %esi , %eax
        je f_del_next_1
        movb %dl , (%edi , %esi , 1)
        inc %esi 
        jmp f_del_loop   
f_del_next_1:
    dec %esi
    shr $10 , %esi 
    lea s , %edi 
    mov (%edi , %esi , 4) , %eax
    add %ecx , %eax 
    mov %eax , (%edi , %esi , 4)
    lea f , %edi 
    mov %edx , (%edi , %ebx , 4)

f_del_ret:
    pop %esi 
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret 

f_dfg:
    push %ebp 
    mov %esp , %ebp 

    push %ebx 
    push %edi 
    push %esi 

    lea m , %edi
    xor %ecx , %ecx
    xor %esi , %esi
    f_dfg_set_m:
        cmp $262144 , %ecx
        je f_dfg_preset_s
        mov %esi , (%edi , %ecx , 4)
        inc %ecx
        jmp f_dfg_set_m
    f_dfg_preset_s:    
        lea s , %edi 
        xor %ecx , %ecx 
        mov $1024 , %esi
    f_dfg_set_s:
        cmp $1024 , %ecx
	    je f_dfg_next_1
	    mov %esi , (%edi , %ecx , 4)
	    inc %ecx
	    jmp f_dfg_set_s
f_dfg_next_1:
    xor %ecx , %ecx  
    lea q, %edi 
    xor %esi , %esi
    xor %ebx , %ebx 
    f_dfg_loop:
        cmp vfq , %esi
        je f_dfg_ret 
        push %esi 

        lea q , %edi 
        movb (%edi , %esi , 1) , %bl 

        lea f , %edi
        mov (%edi , %ebx , 4) , %eax

        mov %ecx , %esi 
        shr $10 , %esi 

        lea s , %edi 
        mov (%edi , %esi , 4) , %edx
        cmp %edx , %eax 
        jle f_dfg_loop_next_1
        shr $10 , %ecx
        inc %ecx
        shl $10 , %ecx 
        inc %esi
    f_dfg_loop_next_1:
        mov (%edi , %esi , 4) , %edx 
        sub %eax , %edx 
        mov %edx , (%edi , %esi , 4)
        lea adresa , %edi 
        mov %ecx , (%edi , %ebx , 4)

        mov %ecx , %esi 
        add %eax , %esi  
        lea m , %edi
    f_dfg_loop_rezb:
        cmp %ecx , %esi
        je f_dfg_loop_next_2
        movb %bl , (%edi , %ecx , 1)
        inc %ecx 
        jmp f_dfg_loop_rezb

    f_dfg_loop_next_2:
        pop %esi  
        inc %esi
        jmp f_dfg_loop
        
f_dfg_ret:
    pop %esi 
    pop %edi 
    pop %ebx 
    pop %ebp 
    ret 
main:
    lea m , %edi
    xor %ecx , %ecx
    xor %esi , %esi
    et_set_m:
        cmp $262144 , %ecx
        je et_preset_f
        mov %esi , (%edi , %ecx , 4)
        inc %ecx
        jmp et_set_m
    
    et_preset_f:
        lea f , %edi 
        xor %ecx , %ecx
    et_set_f:
        cmp $256 , %ecx
	    je et_preset_s
	    mov %esi , (%edi , %ecx , 4)
	    inc %ecx
	    jmp et_set_f
    
    et_preset_s:
        lea s , %edi 
        xor %ecx , %ecx 
        mov $1024 , %esi
    et_set_s:
        cmp $1024 , %ecx
	    je main_next_1
	    mov %esi , (%edi , %ecx , 4)
	    inc %ecx
	    jmp et_set_s
main_next_1:
    push $nrop
    push $fsc 
    call scanf 
    add $8 , %esp 

    xor %esi , %esi 
    et_op:
        cmp nrop , %esi 
        je et_exit 
        inc %esi 

        push $op 
        push $fsc 
        call scanf 
        add $8 , %esp 

        mov op , %eax 
        cmp $1 , %eax
        je et_add 
        cmp $2 , %eax 
        je et_get 
        cmp $3 , %eax 
        je et_del 
        cmp $4 , %eax
        je et_dfg 
        jmp et_op

        et_add:
            push $nradd 
            push $fsc 
            call scanf 
            add $8 , %esp 

            xor %ebx , %ebx
            et_add_apel_loop:
                cmp nradd , %ebx
                je et_op 
                inc %ebx 

                push $id 
                push $fsc 
                call scanf 
                add $8 , %esp 

                push $kb 
                push $fsc 
                call scanf 
                add $8 , %esp 

                push id 
                push kb 
                call f_add 
                add $8 , %esp

                cmp $0 , %eax 
                je et_add_apel_loop

                push id 
                call q_add
                add $4 , %esp 

                jmp et_add_apel_loop
        et_get:
            push $id
            push $fsc 
            call scanf 
            add $8 , %esp 

            push id
            call f_get 
            add $4 , %esp 

            jmp et_op
        et_del:
            push $id
            push $fsc 
            call scanf 
            add $8 , %esp 

            push id
            call f_del 
            add $4 , %esp

            call f_afi
            jmp et_op
        et_dfg:
            call f_dfg 
            call f_afi 
            jmp et_op  
et_exit:
	pushl $0
    call fflush
    popl %eax
    
    mov $1 , %eax
    xor %ebx , %ebx 
    int $0x80
