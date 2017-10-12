# suma.s:	Sumar los elementos de una lista
#	  	llamando a función, pasando argumentos mediante registros
# retorna: 	código retorno 0, comprobar suma en %eax mediante gdb/ddd

# SECCIÓN DE DATOS (.data, variables globales inicializadas)
.section .data
lista:
	.int 1,1,1,1,1,1,1,1
	.int 1,1,1,1,1,1,1,2
	.int 1,1,1,1,1,1,1,1
	.int 1,1,1,1,1,1,1,1
longlista:
	.int (.-lista)/4			# . = contador posiciones. Aritm.etiquetas
resultado:
	.quad 0x0123456789ABCDEF			# para ver cuándo se modifica cada byte
						# 0x0123456789ABCDEF cuando sea 64b y quad por que es de 64 bits

formato:
	.ascii "media = %d \nresto= %d \n\0" # formato para printf() libC



# SECCIÓN DE CÓDIGO (.text, instrucciones máquina)
.section .text					# PROGRAMA PRINCIPAL
#_start:	.global _start				# Programa principal si se usa gcc
main: .global main				# se puede abreviar de esta forma
	mov    $lista, %ebx			# dirección del array lista
	mov longlista, %ecx			# número de elementos a sumar
	call suma				# llamar suma(&lista, longlista);
	mov %eax, resultado			# salvar resultado
	mov %edx, resultado+4			#para concatenar en memoria eax y edx ( asi por que es littel endian)

#	# si se usa este bloque, usar también la línea que define formato,
#	# cambiar la línea _start por main, y compilar con gcc
	push resultado+4				# versión libC de syscall __NR_write
	push resultado
	push $formato						# traduce resultado a ASCII decimal/hex
	call printf							# == printf(formato,resultado,resultado)
	add $20, %esp						# pone el puntero de pila en su posicion anterior
						# void _exit(int status);
	mov $1, %eax				# exit: servicio 1 kernel Linux
	mov $0, %ebx				# status: código a retornar (0=OK)
	int $0x80				# llamar _exit(0);

# SUBRUTINA: suma(int*lista, int longlista);
# entrada:	1) %ebx =dirección inicio array
#		2) %ecx =número de elementos a sumar
# salida:	%edx|%eax =resultado de la suma

suma:
	mov $0, %ebp				# poner los acomuladores a 0
	mov $0, %edi
	mov $0, %esi 				# poner a 0 índice
bucle:
	mov (%ebx,%esi,4), %eax			# mover i-ésimo elemento por la extension de signo se hace en eax
	cltd					# extendemos el signo
	add %eax, %edi
	adc %edx, %ebp
	inc %esi
	cmp %esi,%ecx
	jne bucle

	#movemos los datos a los registros que usa idiv  edx:eax
	mov %ebp, %edx
	mov %edi, %eax
	idivl longlista

	ret
