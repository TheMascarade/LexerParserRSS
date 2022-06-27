%{
	#include <stdio.h>
	#include "lex.yy.c"
%}
%glr-parser // Hace que el parser generado actúe como un APD (con backtracking) y pueda procesar gramáticas ambiguas.
%token A_TITULO C_TITULO
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
%%
	titulo:
		A_TITULO CAD C_TITULO
	;
	descripcion:
		A_DESC CAD C_DESC
	;
	categoria:
		A_CAT CAD C_CAT
	;
	derechos:
		A_DER CAD C_DER
	;
	alto:
		A_ALT NUM C_ALT
	;
	ancho:
		A_ANCHO NUM C_ANCHO
	;
	url:
		A_URL ENLACE C_URL
	;
	link:
		A_LINK ENLACE C_LINK
	;
	defRSS:
		D_RSS
	;
	defXML:
		D_XML
	;
	imagen_obligatorio:
		url titulo link
		| url link titulo
		| titulo url link
		| titulo link url
		| link titulo url
		| link url titulo
	;
	imagen_opcional:
		alto
		| ancho
		| alto ancho
		| ancho alto
	;
	imagen:
		A_IMG imagen_obligatorio C_IMG
		| A_IMG imagen_obligatorio imagen_opcional C_IMG
		| A_IMG imagen_opcional imagen_obligatorio C_IMG
	;
	item_obligatorio:
		titulo link descripcion
		| titulo descripcion link
		| descripcion titulo link
		| descripcion link titulo
		| link titulo descripcion
		| link descripcion titulo
	;
	item_opcional:
		categoria
	;
	item:
		A_ITEM item_obligatorio C_ITEM
		| A_ITEM item_obligatorio item_opcional C_ITEM
		| A_ITEM item_opcional item_obligatorio C_ITEM
	;
	items:
		%empty
		| item
		| item items
	;
	canal_obligatorio:
		titulo link descripcion
		| titulo descripcion link
		| descripcion titulo link
		| descripcion link titulo
		| link titulo descripcion
		| link descripcion titulo
	;
	canal_opcional:
		categoria
		| derechos
		| imagen
		| categoria derechos
		| categoria imagen
		| derechos imagen
		| derechos categoria
		| categoria derechos imagen
		| categoria imagen derechos
		| derechos categoria imagen
		| derechos imagen categoria
		| imagen categoria derechos
		| imagen derechos categoria
	;
	canal:
		A_CANAL canal_obligatorio items C_CANAL
		| A_CANAL items canal_obligatorio C_CANAL
		| A_CANAL canal_obligatorio canal_opcional items C_CANAL
		| A_CANAL canal_obligatorio items canal_opcional C_CANAL
		| A_CANAL items canal_obligatorio canal_opcional C_CANAL
		| A_CANAL items canal_opcional canal_obligatorio C_CANAL
		| A_CANAL canal_opcional canal_obligatorio items C_CANAL
		| A_CANAL canal_opcional items canal_obligatorio C_CANAL
	;
	documento:
		defXML defRSS canal C_RSS
		| defRSS canal C_RSS
	;
%%
yyerror(char *msg)
{
	printf("%s\n",msg);
}
eval_parse(int salida)
{
	switch (salida)
	{
		case 0:
			printf("Compilado exitoso\n");
			break;
		case 1:
			printf("l: %i\n",yylineno);
			break;
		case 2:
			printf("ERROR, falta de memoria");
			break;
	}
}	
int main(int argc, char **argv){
	if(argc==2)
	{
		yyin=fopen(argv[1],"r");
		if(yyin==NULL)
		{
			printf("Archivo inexistente\n");
		}
		else
		{
			eval_parse(yyparse());
			fclose(yyin);
		}
	}
	else
	{
		printf("Ingrese por teclado\n");
		yyin=stdin;
		eval_parse(yyparse());
	}
}