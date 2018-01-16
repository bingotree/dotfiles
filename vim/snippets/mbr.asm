[org 0x7c00]

    jmp $

; Padding and magic BIOS number

    times 510 - ($ - $$) db 0
    dw 0xaa55
