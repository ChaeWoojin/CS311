    .data # data section
saved_ret_pc:   .word 0 
newline:      .asciiz "\n"

    .text # text section
main:
    sw      $31, saved_ret_pc

    # syscall (read int, N)
    li      $v0, 5
    syscall
    move    $s0, $v0

    # read int array with size N
    li      $a0, 0
    move    $a1, $s0
    move    $s1, $sp

Loop1:
    beq     $a0, $a1, EndLoop1
    li      $v0, 5
    syscall
    addi    $sp, $sp, -4
    sw      $v0, 4($sp)

    addi    $a0, $a0, 1
    j       Loop1

EndLoop1:
    # $s1 stores the top address of array
    # $s0 stores N
    addi    $sp, $sp, 4
    li      $a0, 0
    move    $a1, $s0
    addi    $a1, $a1, -1
    jal     Quicksort

    li      $a0, 0
    jal     PrintResult

Quicksort:
    slt     $t0, $a0, $a1       # if(low < high)
    beq     $t0, $zero, Ret     # else return

    addi    $sp, $sp, -20       
    sw      $ra, 16($sp)        # save return address
    sw      $a0, 12($sp)        # save low
    sw      $a1, 8($sp)         # save high
    lw      $a2, 4($sp)         # load mid_left
    lw      $a3, 0($sp)         # load mid_right
    jal     Partition
    sw      $s2, 4($sp)         # save mid_left
    sw      $s3, 0($sp)         # save mid_right
    
    lw      $a0, 12($sp)        # load low
    lw      $a1, 4($sp)         # load mid_left
    addi    $a1, $a1, -1
    jal     Quicksort           # Quicksort(low, mid_left-1)
    
    lw      $a0, 0($sp)         # load mid_right
    addi    $a0, $a0, 1         
    lw      $a1, 8($sp)         # load high
    jal     Quicksort           # Quicksort(mid_right+1, high)
    lw      $ra, 16($sp)
    addi    $sp, $sp, 20

Ret:
    jr      $ra

Partition:
    move    $a2, $a0        # mid_left($a2) = low 
    move    $a3, $a1        # mid_right($a3) = high
    
    li      $t0, 1664525    
    multu   $t0, $a1        
    mflo    $t1             # $t1 = 1664525*(ul)high

    li      $t0, 22695477
    multu   $t0, $a0        # $t2 = 22695477*(ul)low
    mflo    $t2
    
    addu    $t3, $t1, $t2   # $t3 = $t1 + $t2 

    sub     $t4, $a1, $a0   # $t4 = high($a1) - low($a0) + 1
    addi    $t4, $t4, 1
    div     $t3, $t4
    mfhi    $t5             # $t5 = $t3 % $t4

    add     $t0, $a0, $t5   # i($t0) = low($a0) + ($t3 % $t4)
    sll     $t1, $t0, 2
    sub     $t1, $s1, $t1   # $t1 = &A[i]
    lw      $t2, 0($t1)     # pivot($t2) = A[i]

    sll     $t3, $a0, 2
    sub     $t3, $s1, $t3   # $t3 = &A[low]
    lw      $t4, 0($t3)     # $t4 = A[low]

    sw      $t2, 0($t3)    
    sw      $t4, 0($t1)     
    lw      $t2, 0($t1)     # A[i] = A[low]
    lw      $t4, 0($t3)     # A[low] = pivot
    move    $t7, $t4

    addi    $t0, $a0, 1     # i = low + 1


Loop2:
    L2_subLoop1:
        beq     $t0, $a3, sLabel1           # i($t0) == mid_right($a3): 1.1 condition
        slt     $t5, $t0, $a3               # i < mid_right: 1.2 condition
        beq     $t5, $zero, L2_subLoop2

        sLabel1:
            sll     $t3, $a3, 2     
            sub     $t4, $s1, $t3 
            lw      $t6, 0($t4)             # $t6: A[mid_right]
            slt     $t5, $t7, $t6           # pivot < A[mid_right]: 2.1 condition
            beq     $t5, $zero, L2_subLoop2
            
            addi	$a3, $a3, -1            # mid_right--
            j       L2_subLoop1

    L2_subLoop2:
        beq     $t0, $a3, sLabel2_1         # i == mid_right: 1.1 condition
        slt     $t5, $t0, $a3               # i < mid_right: 1.2 condition
        beq     $t5, $zero, L2_if
        
        sLabel2_1:
            sll     $t1, $t0, 2
            sub     $t1, $s1, $t1
            lw      $t2, 0($t1)     
            beq     $t2, $t7, sLabel2_2     # A[i] == pivot: 2.1 condition
            slt     $t5, $t2, $t7           # A[i] < pivot: 2.2 condition
            beq     $t5, $zero, L2_if
        
        sLabel2_2:
            sll     $t3, $a2, 2     
            sub     $t3, $s1, $t3
            sw      $t2, 0($t3)
            sw      $t7, 0($t1)

            addi    $a2, $a2, 1
            addi    $t0, $t0, 1
            j       L2_subLoop2

    L2_if:
        slt     $t5, $t0, $a3               # if i < mid_right
        beq     $t5, $zero, EndLoop2


        sll     $t3, $a3, 2                 # A[mid_right]
        sub     $t4, $s1, $t3               # $t4 = &A[mid_right]               
        lw      $t6, 0($t4)                 # $t6 = A[mid_right]

        sll     $t3, $a2, 2                 # A[mid_left]
        sub     $t3, $s1, $t3               # $t3 = &A[mid_left]
        sw      $t6, 0($t3)                 # A[mid_left] = A[mid_right]

        sll     $t1, $t0, 2
        sub     $t1, $s1, $t1
        lw      $t2, 0($t1)  
        sw      $t2, 0($t4)

        sw      $t7, 0($t1)

        addi    $a2, $a2, 1
        addi    $a3, $a3, 1
        addi    $t0, $t0, 1
        j       Loop2

EndLoop2:
    move    $s2, $a2 
    move    $s3, $a3 
    jr      $ra

PrintResult:
    # print results in for loop
    move    $t0, $a0
    
    Loop3:
        slt     $t1, $t0, $s0
        beq     $t1, $zero, End

        sll     $t2, $t0, 2
        sub     $t2, $s1, $t2
        li      $v0, 1
        lw      $a0, 0($t2)
        syscall

        li      $v0, 4
        la      $a0, newline
        syscall

        addi    $t0, $t0, 1
        j       Loop3

End:
    lw      $31, saved_ret_pc
    jr      $31
