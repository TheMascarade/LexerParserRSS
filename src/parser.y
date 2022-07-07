%{
	#include <stdio.h>
	#include "lex.yy.c"
	FILE* arch_salida;
%}
%glr-parser // Hace que el parser generado actúe como un APD (con backtracking) y pueda procesar gramáticas ambiguas.
%define parse.error detailed // Mas informacion de errores.
%union
{
	char* string;
}
%token <string>A_TITULO C_TITULO
	A_DESC C_DESC
	A_CAT C_CAT
	A_DER C_DER
	A_ALT C_ALT
	A_ANCHO C_ANCHO
	A_LINK C_LINK
	A_URL C_URL
	A_CANAL C_CANAL
	A_ITEM C_ITEM
	A_IMG C_IMG
	D_RSS C_RSS
	D_XML
	CAD ENLACE NUM
%start documento // no terminal distinguido (sigma).
%type <string> titulo descripcion link 
%%
	documento:
		defXML defRSS canal C_RSS
	;
	defXML:
		%empty %dprec 10
		| D_XML %dprec 9
	;
	defRSS:
		D_RSS
	;
	canal:
		A_CANAL canal_obligatorio canal_opcional items C_CANAL %dprec 49
		| A_CANAL canal_obligatorio items canal_opcional C_CANAL %dprec 48
		| A_CANAL canal_opcional canal_obligatorio items C_CANAL %dprec 47
		| A_CANAL canal_opcional items canal_obligatorio C_CANAL %dprec 46
		| A_CANAL items canal_obligatorio canal_opcional C_CANAL %dprec 45
		| A_CANAL items canal_opcional canal_obligatorio C_CANAL %dprec 44
	;
	canal_obligatorio:
		titulo link descripcion %dprec 20 {
			fprintf(arch_salida,"<H1>%s</H1>\n<p>%s</p>\n<a>%s</a>\n",$1,$3,$2);
		}
		| titulo descripcion link %dprec 19{
			fprintf(arch_salida,"<H1>%s</H1>\n<p>%s</p>\n<a>%s</a>\n",$1,$2,$3);
		}
		| link descripcion titulo %dprec 18{
			fprintf(arch_salida,"<H1>%s</H1>\n<p>%s</p>\n<a>%s</a>\n",$3,$2,$1);
		}
		| link titulo descripcion %dprec 17{
			fprintf(arch_salida,"<H1>%s</H1>\n<p>%s</p>\n<a>%s</a>\n",$2,$3,$1);
		}
		| descripcion link titulo %dprec 16{
			fprintf(arch_salida,"<H1>%s</H1>\n<p>%s</p>\n<a>%s</a>\n",$3,$1,$2);
		}
		| descripcion titulo link %dprec 15{
			fprintf(arch_salida,"<H1>%s</H1>\n<p>%s</p>\n<a>%s</a>\n",$2,$1,$3);
		}
	;
	canal_opcional:
		categoria derechos imagen %dprec 26
		| categoria imagen derechos %dprec 25
		| derechos categoria imagen %dprec 24
		| derechos imagen categoria %dprec 23
		| imagen derechos categoria %dprec 22
		| imagen categoria derechos %dprec 21
	;
	items:
		%empty %dprec 28
		| item %dprec 8
		| item items %dprec 7
	;
	item:
		A_ITEM item_obligatorio item_opcional C_ITEM %dprec 27
		| A_ITEM item_opcional item_obligatorio C_ITEM %dprec 29
	;
	item_obligatorio:
		titulo link descripcion %dprec 35{
			fprintf(arch_salida,"<H3>%s</H3>\n<p>%s</p>\n",$1,$3);
		}
		| titulo descripcion link %dprec 34{
			fprintf(arch_salida,"<H3>%s</H3>\n<p>%s</p>\n",$1,$2);
		}
		| link descripcion titulo %dprec 33{
			fprintf(arch_salida,"<H3>%s</H3>\n<p>%s</p>\n",$3,$2);
		}
		| link titulo descripcion %dprec 32{
			fprintf(arch_salida,"<H3>%s</H3>\n<p>%s</p>\n",$2,$3);
		}
		| descripcion link titulo %dprec 31{
			fprintf(arch_salida,"<H3>%s</H3>\n<p>%s</p>\n",$3,$1);
		}
		| descripcion titulo link %dprec 30{
			fprintf(arch_salida,"<H3>%s</H3>\n<p>%s</p>\n",$2,$1);
		}
	;
	item_opcional:
		categoria
	;
	imagen:
		%empty %dprec 13
		| A_IMG imagen_obligatorio imagen_opcional C_IMG %dprec 14
	;
	imagen_obligatorio:
		url titulo link %dprec 41
		| url link titulo %dprec 40
		| titulo url link %dprec 39
		| titulo link url %dprec 38
		| link url titulo %dprec 37
		| link titulo url %dprec 36
	;
	imagen_opcional:
		alto ancho %dprec 43
		| ancho alto %dprec 42
	;
	titulo:
		A_TITULO CAD C_TITULO {
			$$=$2;
		}
	;
	link:
		A_LINK ENLACE C_LINK{
			$$=$2;
		}
	;
	descripcion:
		A_DESC CAD C_DESC{
			$$=$2;
		}
	;
	derechos:
		%empty %dprec 12
		| A_DER CAD C_DER %dprec 11
	;
	url:
		A_URL ENLACE C_URL
	;
	alto:
		%empty %dprec 6
		| A_ALT NUM C_ALT %dprec 5
	;
	ancho:
		%empty %dprec 4
		| A_ANCHO NUM C_ANCHO %dprec 3
	;
	categoria:
		%empty %dprec 2
		| A_CAT CAD C_CAT %dprec 1
	;
%%
int salida;

yyerror(char *msg)
{
	printf("%s\n",msg);
	return 1;
}
int eval_parse(int salida)
{
	switch (salida)
	{
		case 0:
			printf("Compilado exitoso!\n");
			break;
		case 1:
			printf("l: %i\n",yylineno);
			remove("salida.html"); // eliminar el archivo de salida.
			break;
		case 2:
			printf("ERROR, falta de memoria");
			break;
	}
}
grabar_salida()
{
	arch_salida=fopen("salida.html","w+");
	fprintf(arch_salida, "%s","<!DOCTYPE html>\n""<head>\n""<title>Salida del Parser</title>\n""</head>\n""<body>\n");
	salida=yyparse();
	fprintf(arch_salida, "%s","</body>\n""</html>");
}
int main(int argc, char **argv){
	if(argc==2)
	{
		yyin=fopen(argv[1],"rt");
		if(yyin==NULL)
		{
			printf("Archivo inexistente\n");
		}
		else
		{
			grabar_salida();
			fclose(yyin);
		}
	}
	else
	{
		printf("Ingrese por teclado\n");
		yyin=stdin;
		grabar_salida();
	}
	fclose(arch_salida);
	eval_parse(salida);
	return 0;
}