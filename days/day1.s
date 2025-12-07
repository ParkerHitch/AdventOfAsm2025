
.extern _printf
.global _main

.text
_main:
    stp lr, xzr, [sp, #-16]!
    // Allocate a stack buffer for char and ints
    // stack contains: [char, int]
    // Must be 16-byte alligned
    add sp, sp, #-16

    # If no arg give up
    cmp x0, #2
    b.ne done

    # deref argv[1]
    ldr x1, [x1, #8]

    # Push argc, arv onto stack
    stp x0, x1, [sp, #-16]!
    adrp x0, str_hello@PAGE
    add x0, x0, str_hello@PAGEOFF
    bl _printf
    # Postfix sp incr
    ldp x0, x1, [sp], #16

    # fopen time
    mov x0, x1   // filename
    # "r"
        adrp x1, str_r@PAGE
        add x1, x1, str_r@PAGEOFF
    bl _fopen

    mov x19, x0 //x19 = FILE*

    // Null check
    cmp x0, xzr
    b.eq done

    // x20 is current state
    mov x20, #50
    // x21 is zero count
    mov x21, #0
    // x22 is pt2 zero count
    mov x22, #0

loop:
    // Get the pointers to the char/int
    add x0, sp, #0 // char*
    add x1, sp, #8 // int*

    // fscanf
        // Variadic:
            stp x0, x1, [sp, #-16]!
        // FILE*
            mov x0, x19
        // Format specifier:
            adrp x1, str_scanspec@PAGE
            add x1, x1, str_scanspec@PAGEOFF
        // Call fscanf
            bl _fscanf
        // Dealloc variadic
            add sp, sp, #16


    // Print 'em for shits and gigs
    // The top 16 bytes on the stack should be correct
    adrp x0, str_line@PAGE
    add x0, x0, str_line@PAGEOFF
    bl _printf

    // Load dir and amt into x0 & x1
    ldrb w0, [sp]
    ldr w1, [sp, #8]

    // If left, negate x1
    cmp x0, #'L'
    cneg x1, x1, EQ

    // Save the og state
    mov x4, x20
    // Update state
    adds x20, x20, x1

    // Integer division (rounds towards zero)
    mov x3, #100
    sdiv x2, x20, x3

    // Check what the original dividend was
    cmp x20, xzr // This cmp REUSED
    // If we landed exactly on zero, we need to increment pt2
    cinc x22, x22, EQ

    // Now we just complete the modulo
    msub x20, x2, x3, x20

    // If the original dividend was negative (reusing cmp)
    b.ge nonneg
        // We know x20 was negative before modulo
        // We need to add 1 to pt2 if crossed zero
        cmp x4, xzr
        cinc x22, x22, GT

        // And if there is still any remainder left we need to correct it
        cmp x20, xzr
        b.ge nonneg
        add x20, x20, #100

    nonneg:

    // Take abs of x2 (integer quotient)
    cmp x2, xzr
    cneg x2, x2, lt
    // And add to pt2 zero
    add x22, x22, x2

        # // sdiv rounds towards zero, so incr by 100 if less than that
        # // Also update part2 count
        # cmp x20, xzr
        # b.ge fine
        #     // If we start at 0, don't incr an extra time
        #     # cmp x4, xzr
        #     # cinc x22, x22, NE
        #     add x22, x22, #1
        #     adds x20, x20, #100
        # fine:

    # // Use the flag forom either the cmp or the adds
    # // Incr count if zero
    # // Also incr the pt2 count

    // If we land on zero incr pt1
    cmp x20, xzr
    cinc x21, x21, EQ

    // Print and clobber the shit we used for scanfing
    stp x20, x21, [sp, #-32]!
    str x22, [sp, #16]
    adrp x0, str_status@PAGE
    add x0, x0, str_status@PAGEOFF
    bl _printf
    add sp, sp, 32

    mov x0, x19
    bl _feof

    cbz x0, loop



close:
    // Close
    mov x0, x19 // FILE*
    bl _fclose



done:
    add sp, sp, #16
    ldp lr, xzr, [sp], #16
    mov x0, #0
    ret

.data
str_hello: .asciz "Main called w/ argc: %d, argv: %s\n"
str_scanspec: .asciz "%c%d\n"
str_r: .asciz "r"
str_char: .asciz "-%c"
str_line: .asciz "%c - %3d"
str_status: .asciz " -> pos=%2d, cnt=%4d, pt2 count=%d\n"
