    .data # data section
saved_ret_pc:	.word 0		# Holds PC to return from main
true:   .asciiz "true\n"
false:  .asciiz "false\n"

    .text # text section
main:
    sw      $31, saved_ret_pc

    # syscall (read_int)
    li      $v0, 5                     
    syscall 
    add     $t0, $zero, $v0     # $t0: input

    slti    $t1, $v0, 0
    bne     $t1, $zero, print_false # negative number cannot be palindrome

    li      $a1, 0     
    add     $a0, $zero, $t0
    jal     reverse

    # palindrome is same as origin number
    add     $t2, $zero, $v0     # $t2: reverse
    add     $t3, $zero, $t0     # $t3: input
    beq     $t2, $t3, print_true
    j       print_false


reverse:
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)

    li      $t1, 10
    div     $a0, $t1
    mflo    $s0
    mfhi    $s1
    
    # next parameter
    add     $a0, $zero, $s0
    
    # make reverse-number
    mul     $a1, $a1, 10
    add     $a1, $a1, $s1

    # loop condition
    bne     $a0, $zero, reverse
    
    # end condtion
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    add     $v0, $zero, $a1
    jr      $ra

print_true:
    li      $v0, 4
    la      $a0, true
    syscall
    
    lw      $31, saved_ret_pc
    jr      $31

print_false:
    li      $v0, 4
    la      $a0, false
    syscall
    
    lw      $31, saved_ret_pc
    jr      $31

result = 0;
while(n!=0){
    remaider = n % 10;
    result = result*10 + remainer;
    n /= 10;
}