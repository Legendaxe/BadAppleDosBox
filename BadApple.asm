.model small, c

.stack

.data
    filepath db 'C:\BadApp/a0000.bmp', 0
    filehandle dw 0
    buffer db 0F30h dup(0), '$'
    datashift dw 0
    filecount dw 1
.code
main proc
    mov ax, @Data
    mov ds, ax

	mov cx, 6570
	
FileLoop:

	jmp HELP2
HELP1:
	loop FileLoop
	jmp quit
HELP2:
	push cx
	xor dx, dx
	mov cx, 10
	mov ax, filecount
	inc filecount
	div cx
	add dl, '0'
	mov filepath[14], dl
	xor dx, dx
	div cx
	add dl, '0'
	mov filepath[13], dl
	xor dx, dx
	div cx
	add dl, '0'
	mov filepath[12], dl
	xor dx, dx
	div cx
	add dl, '0'
	mov filepath[11], dl
	xor dx, dx




	mov ah, 3Dh
	mov al, 0
	mov dx, offset filepath
	int 21h
	mov filehandle, ax
	jc quit

	mov ah, 42h
	mov al, 00h
	xor cx, cx
	mov dx, 436h
	mov bx, filehandle
	int 21h
	jc quit

	mov ah, 3Fh
	mov bx, filehandle
	mov cx, 0F30h
	mov dx, offset buffer
	int 21h
	jc quit

	sub cx, 1
BufferLoop:
	mov di, cx
	test buffer[di], 0FFh
	mov buffer[di], 32
	jz BufferLoop2
	mov buffer[di], 38
BufferLoop2:
	loop BufferLoop 

	mov cx, 49
FrameLoop:
	mov al, 72
	mul cl
	mov datashift, ax
	mov ah, 09h
	mov dx, offset buffer
	add dx, datashift
	int 21h
	mov ah, 2h
	mov dl, 0Dh
	int 21h
	mov ah, 2h
	mov dl, 0Ah
	int 21h
	mov di, datashift
	mov buffer[di], '$'

	loop FrameLoop

	mov ah, 3Eh
	mov bx, filehandle
	int 21h

	mov ah, 86h
	xor cx, cx
	mov dx, 30303
	int 15h

	jc quit

	pop cx
	jmp HELP1
quit:   
    mov ax, 4c00h
    int 21h
main endp
    end main