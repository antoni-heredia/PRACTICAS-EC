# suma64sgn.s:	Sumar los elementos de una lista con signo y teniendo en cuenta 64bits

# SECCIÓN DE DATOS (.data, variables globales inicializadas)
.section .data

.macro linea
	 # 	.int -1,-1,-1,-1
	 # 	.int 0xffffffff,0xffffffff,0xffffffff,0xffffffff
	 #	.int 1, -2, 1, -2
	 #	.int 1, 2, -3, -4
	 #	.int 0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff
	 #	.int 0x08000000,0x08000000,0x08000000,0x08000000
	 #	.int 0x04000000,0x04000000,0x04000000,0x04000000
	 #	.int 0x80000000,0x80000000,0x80000000,0x80000000
	 #	.int 0xfc000000,0xfc000000,0xfc000000,0xfc000000
 	 #	.int 0xf8000000,0xf8000000,0xf8000000,0xf8000000
	 	.int 0xf0000000,0xe0000000,0xe0000000,0xf0000000
.endm

lista:
	.irpc i,12345678
		linea
	.endr

longlista:
	.int (.-lista)/4			# . = contador posiciones. Aritm.etiquetas
resultado:
	.quad 0x0123456789ABCDEF			# para ver cuándo se modifica cada byte
						# 0x0123456789ABCDEF cuando sea 64b y quad por que es de 64 bits

formato:
	.ascii "suma = %lld = %llx hex\n\0" # formato para printf() libC
# lld es por que es un decimal de long long (64bits) igual para llx
# el string “formato” sirve como argumento a la llamada printf opcional


# SECCIÓN DE CÓDIGO (.text, instrucciones máquina)
.section .text					# PROGRAMA PRINCIPAL

main: .global main				# se puede abreviar de esta forma

	mov $lista, %ebx			# dirección del array lista
	mov longlista, %ecx			# número de elementos a sumar
	call suma				# llamar suma(&lista, longlista);
	mov %eax, resultado			# salvar resultado
	mov %edx, resultado+4			#para concatenar en memoria eax y edx ( asi por que es littel endian)

	#Añadimos a la pila el resultado para que lo tenga disponible printf
	#Aqui se añade el resultado para %llx que sera eax|edx pero al añadirlo a la pila se añade al reves
	push resultado+4
	push resultado

	#Se realiza lo mismo para %lld
	push resultado+4
	push resultado
	#añadimos el formato para printf
	push $formato
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

	#Realizamos la suma parcial
	add %eax, %edi

	#Realizamos la suma parcial teniendo en cuenta el acarreo del add anterior
	adc %edx, %ebp
	#Incrementamos el valor de la cantidad de elementos procesados
	inc %esi
	#comparamos si se han recorrido todos los elementos
	cmp %esi,%ecx
	jne bucle # si no se han recorrido  volvemos a emepzar

	#movemos el resultado a edx|eax para no tener que cambiar el programa principal
	mov %ebp, %edx
	mov %edi, %eax

	ret
