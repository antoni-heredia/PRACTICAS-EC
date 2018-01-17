# SECCIÓN DE DATOS (.data, variables globales inicializadas)
.section .data
	.macro linea
	 #	.int 1,1,1,1
	 # 	.int 2,2,2,2
	 #	.int 1,2,3,4
	 # 	.int -1,-1,-1,-1
	 # 	.int 0xffffffff,0xffffffff,0xffffffff,0xffffffff
	 #	.int 0x08000000,0x08000000,0x08000000,0x08000000
	 	.int 0x10000000,0x20000000,0x40000000,0x80000000
	.endm

lista:
	.irpc i,12345678
		linea
	.endr

longlista:
	.int (.-lista)/4			# . = contador posiciones. Aritm.etiquetas

resultado:
	.quad 0x0123456789ABCDEF			# para ver cuándo se modifica cada byte

formato:
	.ascii "suma = %llu = %llx hex\n\0" # formato para printf() libC
# llu es por que es unsigned de long long (64bits) igual para llx
# el string “formato” sirve como argumento a la llamada printf opcional


# SECCIÓN DE CÓDIGO (.text, instrucciones máquina)
.section .text					# PROGRAMA PRINCIPAL

main: .global main				# se puede abreviar de esta forma
	mov $lista, %ebx			# dirección del array lista
	mov longlista, %ecx			# número de elementos a sumar
	call suma				# llamar suma(&lista, longlista);

	mov %eax, resultado			# salvar resultado
	mov %edx, resultado+4			#para concatenar en memoria eax y edx ( asi por que es little endian)
	#el +4 se debe a que ya se han insertado 4bytes a partir de la direccion de memoria a la que apunta resultadoç


	#Añadimos a la pila el resultado para que lo tenga disponible printf
	#Aqui se añade el resultado para %llx que sera eax|edx pero al añadirlo a la pila se añade al reves
	push resultado+4
	push resultado

	#Se realiza lo mismo que en los push de arriba para %llu
	push resultado+4
	push resultado
	#Se introduce el formato
	push $formato				# traduce resultado a ASCII decimal/hex

	call printf				# == printf(formato,resultado,resultado)
	#Volvemos al puntero de pila a su posicion anterior 5*4bytes=20
	add $20, %esp

	# void _exit(int status);
	mov $1, %eax				# exit: servicio 1 kernel Linux
	mov $0, %ebx				# status: código a retornar (0=OK)
	int $0x80				# llamar _exit(0);

# SUBRUTINA: suma(int*lista, int longlista);
# entrada:	1) %ebx =dirección inicio array
#		2) %ecx =número de elementos a sumar
# salida:	%edx|%eax =resultado de la suma

suma:
	mov $0, %eax				# poner los acomuladores a 0
	mov $0, %edx
	mov $0, %esi 				# poner a 0 índice
bucle:
	add (%ebx,%esi,4), %eax			# acumular i-ésimo elemento
	jnc noacarreo				# salta si no hay acarreo en el add
	inc %edx				# si hay acarreo sumo edx(que es lo que se concatenara)

noacarreo: #si no hay accarreo
	inc %esi
	cmp %esi,%ecx #compara si el indice es igual a la cantidad de elementos
	jne bucle #Si no son iguales, vuelve a realizar otra pasada el bucle
	ret
