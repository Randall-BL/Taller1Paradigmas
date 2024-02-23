; Programa ASM para comparar dos cadenas de texto ingresadas por el usuario.
; Compara si la primera cadena es subcadena de la segunda.
; Randall Bola?os L?pez/2019043784 Instituto Tecnologico de Costa Rica

.model small
.stack 100h
.data
    inputBuffer1 db 255, ?, 255 dup(0) ; 255 caracteres max. + 1 para la longitud
    cadena1 db 256 dup('$') ; Espacio para la subcadena a buscar
    inputBuffer2 db 255, ?, 255 dup(0) ; 255 caracteres max. + 1 para la longitud
    cadena2 db 256 dup('$') ; Espacio para la cadena completa donde buscar
    mensajeVerdadero db 'Verdadero.$'
    mensajeFalso db 'Falso.$'

   
.code
inicio:
    mov ax, @data
    mov ds, ax
    mov es, ax

    ; Leer la primera cadena del usuario
    lea dx, inputBuffer1
    mov ah, 0Ah
    int 21h
    mov si, offset inputBuffer1 + 2 ; Saltar los primeros 2 bytes
    lea di, cadena1
    mov cl, [inputBuffer1+1] ; Longitud de la cadena ingresada
    mov ch, 0                ; Limpiar CH para usar CX en REP MOVSB
    rep movsb                ; Copiar la cadena al buffer cadena1
    mov byte ptr [di], '$'   ; Asegurar el fin de la cadena

    ; Imprimir salto de l?nea para separar las entradas
    mov ah, 02h              ; Funci?n DOS para imprimir car?cter
    mov dl, 0Dh              ; Car?cter de retorno de carro (CR)
    int 21h
    mov dl, 0Ah              ; Car?cter de avance de l?nea (LF)
    int 21h

    ; Leer la segunda cadena del usuario
    lea dx, inputBuffer2
    mov ah, 0Ah
    int 21h
    mov si, offset inputBuffer2 + 2 ; Saltar los primeros 2 bytes
    lea di, cadena2
    mov cl, [inputBuffer2+1] ; Longitud de la cadena ingresada
    mov ch, 0                ; Limpiar CH para usar CX en REP MOVSB
    rep movsb                ; Copiar la cadena al buffer cadena2
    mov byte ptr [di], '$'   ; Asegurar el fin de la cadena

    ; Restablecer registros para la comparacion
    lea si, cadena1
    lea di, cadena2
    mov bx, di       ; BX sirve como base para DI en la cadena completa

bucleExterno:
    mov cx, 0        ; Resetear contador de coincidencias
    mov al, [si]     ; Primer caracter de la subcadena

bucleInterno:
    cmp al, [di]     ; Compara el caracter actual de ambas cadenas
    je coincidencia  ; Si coinciden, continia con el siguiente caracter
    jne siguienteCaracter ; Si no coinciden, prueba con el siguiente caracter de cadena2

coincidencia:
    inc si
    inc di
    mov al, [si]
    cmp al, '$'      ; Verifica si llegamos al final de la subcadena
    je encontrado    ; Si es asi, la subcadena esta en cadena2
    jmp bucleInterno ; Si no, continia comparando

siguienteCaracter:
    inc bx
    mov di, bx       ; Mueve DI para comparar desde la siguiente posicion en cadena2
    lea si, cadena1  ; Reinicia SI al inicio de la subcadena
    mov al, [si]
    cmp byte ptr [di], '$' ; Verifica si llegamos al final de cadena2
    jne bucleExterno ; Si no es el final, intenta de nuevo con el siguiente caracter

    jmp noEncontrado ; Si llegamos al final de cadena2 sin encontrar la subcadena

encontrado:
    ; Imprimir dos saltos de l?nea antes del mensaje
    mov ah, 02h              ; Funci?n DOS para imprimir car?cter
    mov dl, 0Dh              ; Car?cter de retorno de carro (CR)
    int 21h
    mov dl, 0Ah              ; Car?cter de avance de l?nea (LF)
    int 21h
    int 21h                  ; Repetir para hacer dos l?neas en total
    lea dx, mensajeVerdadero
    jmp mostrarMensaje

noEncontrado:
    ; Imprimir dos saltos de l?nea antes del mensaje
    mov ah, 02h              ; Funci?n DOS para imprimir car?cter
    mov dl, 0Dh              ; Car?cter de retorno de carro (CR)
    int 21h
    mov dl, 0Ah              ; Car?cter de avance de l?nea (LF)
    int 21h
    int 21h                  ; Repetir para hacer dos l?neas en total
    lea dx, mensajeFalso

mostrarMensaje:
    mov ah, 09h
    int 21h
    mov ah, 4Ch
    int 21h
    ret


end inicio
