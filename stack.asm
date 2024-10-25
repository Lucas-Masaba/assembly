section .data
    input_str db "Hello, World!", 0    ; Input string to reverse
    str_len equ $ - input_str - 1      ; Length of string (minus null terminator)
    output_msg db "Reversed string: "
    output_msg_len equ $ - output_msg

section .bss
    stack_space resb 100               ; Reserve 100 bytes for our stack
    output_str resb 100               ; Space for reversed string

section .text
global _start

_start:
    ; Initialize our custom stack pointer
    mov ebx, stack_space              ; Base of our stack
    mov ecx, str_len                  ; Counter for string length
    
    ; Push phase - Push each character onto our stack
push_loop:
    mov al, [input_str + ecx - 1]     ; Get character from input string
    mov [ebx], al                     ; Store in our stack
    inc ebx                           ; Move stack pointer
    dec ecx                           ; Decrease counter
    jnz push_loop                     ; Continue until all chars are pushed

    ; Pop phase - Pop characters to create reversed string
    mov ebx, stack_space              ; Reset to stack base
    mov ecx, str_len                  ; Reset counter
    mov edi, output_str              ; Destination for reversed string

pop_loop:
    mov al, [ebx + ecx - 1]          ; Get character from stack
    mov [edi], al                    ; Store in output string
    inc edi                          ; Move output pointer
    dec ecx                          ; Decrease counter
    jnz pop_loop                     ; Continue until all chars are popped

    ; Add null terminator to output string
    mov byte [edi], 0

    ; Print output message
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; stdout
    mov ecx, output_msg            ; message to write
    mov edx, output_msg_len        ; message length
    int 0x80

    ; Print reversed string
    mov eax, 4                      ; sys_write
    mov ebx, 1                      ; stdout
    mov ecx, output_str            ; reversed string
    mov edx, str_len               ; string length
    int 0x80

    ; Exit program
    mov eax, 1                      ; sys_exit
    xor ebx, ebx                    ; return 0
    int 0x80