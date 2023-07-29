section .data
    prompt db 'Enter an integer: ', 0
    prompt_len equ $ - prompt	
    buffer times 10 db 0   ; Buffer to store the input (up to 10 characters)
    newline db 10, 0       ; Newline character for printing
	
section .bss
    num resb 4            ; Reserve 4 bytes to store the integer input

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
    mov ecx, buffer       ; Pointer to the buffer
    mov edx, 10           ; Maximum number of characters to read
    int 0x80              ; Call the kernel

    ; Convert the string to an integer
    mov eax, buffer       ; Move the buffer address to EAX
    call str_to_int

    ; Now the integer value is stored in EAX, you can use it as needed

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



