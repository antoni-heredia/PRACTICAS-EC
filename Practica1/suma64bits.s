# suma64bits.s:	Sumar los elementos de una lista usando 64 bits
#
# retorna: 	código retorno 0

# SECCIÓN DE DATOS (.data, variables globales inicializadas)
.section .data
lista:
	.int 0xFFFFFFFF,0xFFFFFFFF,1,1,1,1,1,1
	.int 1,1,1,1,1,1,1,1
	.int 1,1,1,1,1,1,1,1
	.int 1,1,1,1,1,1,1,1

longlista:
	.int (.-lista)/4			# . = contador posiciones. Aritm.etiquetas

resultado:
	.quad 0x0123456789ABCDEF			# para ver cuándo se modifica cada byte
						# 0x0123456789ABCDEF cuando sea 64b y quad por que es de 64 bits

formato:
	.ascii "suma = %llu = %llx hex\n\0" # formato para printf() libC
# llu es por que es unsigned de long long (64bits) igual para llx
# el string “formato” sirve como argumento a la llamada printf opcional


# SECCIÓN DE CÓDIGO (.text, instrucciones máquina)
.section .text					# PROGRAMA PRINCIPAL
#_start:	.global _start				# Programa principal si se usa gcc
main: .global main				# se puede abreviar de esta forma
	mov    $lista, %ebx			# dirección del array lista
	mov longlista, %ecx			# número de elementos a sumar
	call suma				# llamar suma(&lista, longlista);
	mov %eax, resultado			# salvar resultado
	mov %edx, resultado+4			#para concatenar en memoria eax y edx ( asi por que es littel endian)


	push resultado+4				# versión libC de syscall __NR_write
	push resultado				# ventaja: printf() con formato "%d" / "%x"
	push resultado+4
	push resultado
	push $formato				# traduce resultado a ASCII decimal/hex
	call printf				# == printf(formato,resultado,resultado)
	add $20, %esp     #para mover el puntero de pila a su estado anterior

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
	add (%ebx,%edx,4), %eax			# acumular i-ésimo elemento
	jnc noacarreo				# salta si no hay acarreo
	inc %edx				# si hay acarreo sumo edx(que es lo que se concatenara)

noacarreo: #si no hay accarreo
	inc %esi #incremeta el contador
	cmp %esi,%ecx
	jne bucle
ret
