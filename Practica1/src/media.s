# media.s: Devuelve la media de los elementos de una lista

# SECCIÓN DE DATOS (.data, variables globales inicializadas)
.section .data
	.macro linea
	#	.int 1,-2,1,-2
	#	.int 1,2,-3,-4
		.int -1, -1 , -1,-1
	#	.int 0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF,0x7FFFFFFF
	#	.int 0x80000000,0x80000000,0x80000000,0x80000000
	# .int 0xf0000000,0xe0000000,0xe0000000,0xd0000000
	#	.int 0, -2, -1,-1
	.endm

	.macro linea0
	#	.int 0,-1,-1,-1
	#	.int 0,-2,-1,-1
	#	.int 1,-2,-1,-1
	#	.int 16,-2,-1,-1
	#	.int 32,-2,-1,-1
	#	.int 47,-2,-1,-1
	#	.int 63,-2,-1,-1
	#	.int 64,-2,-1,-1
	#	.int 78,-2,-1,-1
	#	.int 95,-2,-1,-1
	#	.int -31,-2,-1,-1
	#	.int -19,-2,-1,-1
		.int 0,-2,-1,-1

	.endm

lista: linea0
	.irpc i,1234567
		linea
	.endr

longlista:
.int (.-lista)/4	# . = contador posiciones. Aritm.etiquetas

media:
.int 0
resto:
.int 0


formato:
	.ascii "media = %d = 0x%x \nresto= %d = 0x%x \n\0" # formato para printf() libC

# SECCIÓN DE CÓDIGO (.text, instrucciones máquina)
.section .text # PROGRAMA PRINCIPAL

main: .global main # se puede abreviar de esta forma

	mov $lista, %ebx	# dirección del array lista
	mov longlista, %ecx	# número de elementos a sumar

	call suma # llamar suma(&lista, longlista);

	mov %eax, media # poenmos eax en la media
	mov %edx, resto	#ponemos edx al resto


	#metemos el resto, la media y el formato a la pila para el printf
	push resto
	push resto
	push media
	push media
	push $formato # traduce resultado a ASCII decimal/hex

	call printf # == printf(formato,resultado,resultado)

	add $20, %esp	# pone el puntero de pila en su posicion anterior

	# void _exit(int status);
	mov $1, %eax	# exit: servicio 1 kernel Linux
	mov $0, %ebx	# status: código a retornar (0=OK)
	int $0x80	# llamar _exit(0);


	suma:
		mov $0, %ebp	# poner los acomuladores a 0
		mov $0, %edi
		mov $0, %esi # poner a 0 índice

	bucle:
		mov (%ebx,%esi,4), %eax	# mover i-ésimo elemento por la extension de signo se hace en eax

		cltd # extendemos el signo
		add %eax, %edi
		adc %edx, %ebp
		inc %esi
		cmp %esi,%ecx
		jne bucle

		#movemos los datos a los registros que usa idiv edx:eax
		mov %ebp, %edx
		mov %edi, %eax
		idivl %ecx
	ret
