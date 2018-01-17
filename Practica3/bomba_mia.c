//compilado con gcc -O0 -m32 -o bomba_mia.exe bomba_mia.c
#include <stdio.h>	// para printf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()/strlen()
#include <sys/time.h>	// para gettimeofday(), struct timeval

char password[]="ogiwuvcge\n";
int  passcode  = 9772;
//char diccionario[10] = {9,4,6,3,1,0,7,2,5,8};

void boom(){
	printf("***************\n");
	printf("*** BOOM!!! ***\n");
	printf("***************\n");
	exit(-1);
}

void defused(){
	printf("·························\n");
	printf("··· bomba desactivada ···\n");
	printf("·························\n");
	exit(0);
}

int longitud(int i){
	int longi = 0;
	while(i>0){
		longi++;
		i /=10;
	}
	return longi;
}

//Version descartada por complejidad
/*
int encriptar(int i){
	int copia = i;
	int longi = longitud(i);
	int valor_devolver = 0;
	int divisor = 1;
	for(int i = 0; i < longi-1; i++){
		divisor *= 10;
	}
	copia = i;
	for(int i = 0; i < longi; i++){
		valor_devolver *= 10;
		int valor = copia/divisor;
		
		int x=-1;
		int encontrado = 1;
		while(x<9 && encontrado != 0){
			x++;
			if(valor == diccionario[x])
				encontrado = 0;
		}
		copia -= valor*divisor;
		valor_devolver += x;
		divisor /= 10;
	}
	return valor_devolver;
}*/

int encriptar(int i){
	int longi = longitud(i);
	int sumar = 7;
	for(int i = 0; i < longi-1; i++){
		sumar *= 10;
		sumar += 7;
	}

	return i+sumar;
}
char * transformar(char * cadena){
	int long_cad = strlen(cadena);
	for(int i = 0; i < long_cad-1; i++){
		cadena[i] += 2;
	}
	return cadena;
}
int main(){
#define SIZE 100
	char pass[SIZE];
	int  pasv;
#define TLIM 5
	struct timeval tv1,tv2;	// gettimeofday() secs-usecs
	
	gettimeofday(&tv1,NULL);

	printf("Introduce la contraseña: ");
	fgets(pass,SIZE,stdin);
	char * pass_encrip = transformar(pass);


	if (strncmp(pass_encrip,password,strlen(password)))
	    boom();

	gettimeofday(&tv2,NULL);
	if (tv2.tv_sec - tv1.tv_sec > TLIM)
	    boom();
	
	printf("Introduce el código: ");
	scanf("%i",&pasv);
	
	int comp = encriptar(pasv);
	if (comp!=passcode) boom();

	gettimeofday(&tv1,NULL);
	if (tv1.tv_sec - tv2.tv_sec > TLIM)
	    boom();

	defused();
}
