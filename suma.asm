; Programa ASM para sumar dos cantidades.
; El programa solo sirve si el numero es de maximo 5 digitos, debido a los registros de 16 bits.
; Randall Bola?os L?pez/2019043784 Instituto Tecnologico de Costa Rica

.model small
.stack 100h

.data
inputNum1 db 6, ?, 5 dup('$') ; Longitud m?xima, longitud actual, buffer
inputNum2 db 6, ?, 5 dup('$')
num1 dw ?
num2 dw ?
result dw ?
msgResult db 0Dh, 0Ah, 'El resultado  $' ; CR, LF antes del mensaje
msgPrompt1 db 'Ingrese el primer numero (max 5 digitos): $'
msgPrompt2 db 0Dh, 0Ah, 'Ingrese el segundo numero (max 5 digitos): $' ; CR, LF antes del mensaje

.code
start:
    mov ax, @data
    mov ds, ax

    ; Pedir el primer numero
    mov ah, 09h
    lea dx, msgPrompt1
    int 21h
    mov ah, 0Ah
    lea dx, inputNum1 ; Buffer para el primer numero
    int 21h
    lea si, inputNum1 + 2 ; Saltar los 2 primeros bytes del buffer
    call ConvertToNum
    mov num1, ax

    ; Pedir el segundo numero
    mov ah, 09h
    lea dx, msgPrompt2
    int 21h
    mov ah, 0Ah
    lea dx, inputNum2 ; Buffer para el segundo numero
    int 21h
    lea si, inputNum2 + 2 ; Saltar los 2 primeros bytes del buffer
    call ConvertToNum
    mov num2, ax

    ; Sumar num1 y num2
    mov ax, num1
    add ax, num2
    mov result, ax

    ; Convertir el resultado a cadena para mostrar
    mov ax, result
    call PrintNum

    ; Terminar el programa
    mov ax, 4C00h
    int 21h

ConvertToNum proc
    xor ax, ax ; Limpiar ax para el resultado
    xor bx, bx ; Limpiar bx, se usa para acumular el numero

    convert_loop1:
        lodsb ; Cargar byte en al desde si, incrementar si
        cmp al, '0'
        jb not_digit1 ; Saltar si es menor que '0'
        cmp al, '9'
        ja not_digit1 ; Saltar si es mayor que '9'
        sub al, '0' ; Convertir ASCII a valor numerico

        ; Ahora bx contiene el valor previo a multiplicar por 10
        ; Multiplicar bx por 10: bx = bx*8 + bx*2
        mov cx, bx     ; Mover BX a CX para la operacion
        shl cx, 3      ; CX = CX * 8 (multiplicar por 8 mediante desplazamiento)
        shl bx, 1      ; BX = BX * 2 (multiplicar por 2 mediante desplazamiento)
        add bx, cx     ; BX = BX original * 8 + BX original * 2 = BX * 10

        add bx, ax ; A?adir el digito convertido a BX
        jmp convert_loop1

    not_digit1:
    mov ax, bx ; Mover el resultado acumulado a AX
    ret
ConvertToNum endp

PrintNum proc
    mov ax, result ; Cargar el resultado para convertir a cadena
    mov bx, 10 ; Divisor para la conversion a decimal
    mov cx, 0 ; Inicializar contador de digitos

    convert_loop2:
        xor dx, dx ; Limpiar dx para usarlo en div
        div bx ; ax / 10, resultado en ax, resto en dx
        push dx ; Guardar el digito en la pila
        inc cx ; Incrementar contador de digitos
        test ax, ax ; Verificar si ax es 0
        jnz convert_loop2 ; Continuar si no es 0

    ; Preparar para mostrar el resultado
    mov di, offset msgResult + 16 ; Posicion inicial para los digitos

    print_digits:
    pop dx ; Recuperar un digito de la pila
        add dl, '0' ; Convertir a ASCII
        mov [di], dl ; Almacenar el digito
        inc di ; Moverse al siguiente espacio
        loop print_digits ; Repetir hasta imprimir todos los digitos

    mov byte ptr [di], '$' ; Terminar la cadena

    ; Mostrar el resultado
    mov ah, 09h
    lea dx, msgResult
    int 21h
    ret
PrintNum endp

end start
