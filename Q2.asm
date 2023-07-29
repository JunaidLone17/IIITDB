section .data
    prompt db 'Enter an integer: ', 0
    prompt_len equ $ - prompt
    newline db 10, 0       ; Newline character for printing

section .bss
    num resb 10           ; Reserve 10 bytes to store the integer input (up to 10 digits)
    ascii_char resb 1     ; Reserve 1 byte to store the ASCII character

section .text
    global _start

_start:
    ; Display the prompt
    mov eax, 4            ; System call for write
    mov ebx, 1            ; File descriptor 1 (stdout)
    mov ecx, prompt       ; Pointer to the prompt message
    mov edx, prompt_len   ; Length of the prompt message
    int 0x80              ; Call the kernel

    ; Read input from the user
    mov eax, 3            ; System call for read
    mov ebx, 0            ; File descriptor 0 (stdin)
    mov ecx, num          ; Pointer to the buffer
    mov edx, 10           ; Maximum number of characters to read (up to 10 digits)
    int 0x80              ; Call the kernel

    ; Convert the string to an integer
    mov eax, num          ; Move the buffer address to EAX
    call str_to_int

    ; Convert the integer to ASCII character
    mov eax, ebx          ; Move the integer value to EAX
    call int_to_ascii_char

    ; Display the ASCII character
    mov eax, 4            ; System call for write
    mov ebx, 1            ; File descriptor 1 (stdout)
    mov ecx, ascii_char   ; Pointer to the ASCII character
    mov edx, 1            ; Length of the character (1 byte)
    int 0x80              ; Call the kernel

    ; Exit the program
    mov eax, 1            ; System call for exit
    xor ebx, ebx          ; Return 0 status
    int 0x80              ; Call the kernel

str_to_int:
    ; Convert the null-terminated string at [eax] to an integer
    ; Assumes that the string contains a valid integer representation
    xor ebx, ebx          ; Clear EBX (to store the result)
.next_digit:
    movzx ecx, byte [eax] ; Load the next byte from the string (zero-extended to 32 bits)
    test ecx, ecx         ; Check if it's the null terminator (end of the string)
    jz .done              ; If it is, we're done
    imul ebx, ebx, 10     ; Multiply the current result by 10
    sub ecx, '0'          ; Convert ASCII digit to integer (e.g., '5' -> 5)
    add ebx, ecx          ; Add the current digit to the result
    inc eax               ; Move to the next character in the string
    jmp .next_digit       ; Continue with the next digit
.done:
    ret

int_to_ascii_char:
    ; Convert the integer in EAX to ASCII character representation
    ; Assumes that the integer value is in the range of 0 to 255
    mov dl, al            ; Move the integer value to DL
    mov [ascii_char], dl  ; Store the ASCII character in memory
    ret
