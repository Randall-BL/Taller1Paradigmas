; Programa ASM para comparar dos cadenas de texto ingresadas por el usuario.
; Randall Bola?os L?pez/2019043784 Instituto Tecnologico de Costa Rica

.model small   ; Establece un modelo de memoria peque?o.

.stack 100h     ; Asigna 256 bytes para la pila.

.data          ; Secci?n de datos para almacenar las cadenas y mensajes.
promptMsg     db 10, 13, "Por favor, ingresa una cadena: $"
equalMessage  db 0Dh, 0Ah, "Las cadenas son iguales $"
diffMessage   db 0Dh, 0Ah, "Las cadenas NO son iguales $"
firstString   db 50 dup('?'), '$'   ; Reserva espacio para la cadena 1.
secondString  db 50 dup('?'), '$'   ; Reserva espacio para la cadena 2.

.code          ; Comienza la secci?n de c?digo del programa.

; Inicio del procedimiento principal.
start:
    mov ax, @data      ; Prepara el segmento de datos.
    mov ds, ax         ; Establece DS para apuntar a los datos.
    mov es, ax         ; Configura ES de igual manera.

    ; Solicita al usuario la entrada de la primera cadena.
    lea dx, promptMsg  ; Apunta a mensaje de solicitud.
    mov ah, 09h        ; AH preparado para la funci?n de mostrar cadena.
    int 21h            ; Invoca la interrupci?n DOS para mostrar el mensaje.

    ; Captura la primera cadena del usuario.
    mov ah, 0Ah        ; Prepara funci?n DOS para capturar cadena.
    lea dx, firstString ; Apunta al buffer de la primera cadena.
    int 21h            ; Ejecuta lectura de cadena.

    ; Repite para la segunda cadena.
    mov ah, 09h        ; Prepara funci?n para mostrar mensaje.
    lea dx, promptMsg  ; Reutiliza mensaje de solicitud.
    int 21h            ; Muestra mensaje.
    mov ah, 0Ah        ; Prepara funci?n para capturar cadena.
    lea dx, secondString ; Apunta al buffer de la segunda cadena.
    int 21h            ; Ejecuta lectura de cadena.

    ; Configura para comparar las cadenas.
    mov si, offset firstString  ; SI apunta al inicio de la primera cadena.
    mov di, offset secondString ; DI apunta al inicio de la segunda cadena.
    mov cx, 50        ; M?ximo de caracteres a comparar.

    ; Realiza la comparaci?n de cadenas.
    repe cmpsb        ; Compara mientras los caracteres sean iguales.

    ; Verifica resultado de la comparaci?n.
    je stringsEqual   ; Si son iguales, salta a stringsEqual.
    jne stringsDiffer ; Si son diferentes, salta a stringsDiffer.

stringsEqual:
    ; Muestra mensaje de cadenas iguales.
    lea dx, equalMessage
    mov ah, 09h
    int 21h
    jmp programExit   ; Salta a finalizar el programa.

stringsDiffer:
    ; Muestra mensaje de cadenas diferentes.
    lea dx, diffMessage
    mov ah, 09h
    int 21h

programExit:
    ; Finaliza el programa.
    mov ah, 4Ch
    int 21h

end start  ; Final del programa y punto de entrada.
