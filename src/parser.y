%{
	#include <stdio.h>
	#include "lex.yy.c"
%}
%glr-parser // Hace que el parser generado actúe como un APD (con backtracking) y pueda procesar gramáticas ambiguas.
%define parse.error detailed // Mas informacion de errores.
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
		%empty
		| A_CAT CAD C_CAT
	;
	derechos:
		%empty
		| A_DER CAD C_DER
	;
	alto:
		%empty
		| A_ALT NUM C_ALT
	;
	ancho:
		%empty
		| A_ANCHO NUM C_ANCHO
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
		%empty
		| D_XML
	;
	imagen_obligatorio:
		url titulo link
	;
	imagen_opcional:
		alto ancho
	;
	imagen:
		%empty
		| A_IMG imagen_obligatorio imagen_opcional C_IMG
	;
	item_obligatorio:
		titulo link descripcion
	;
	item_opcional:
		categoria
	;
	item:
		%empty
		| A_ITEM item_obligatorio item_opcional C_ITEM
	;
	items:
		item %dprec 1
		| item items %dprec 2
	;
	canal_obligatorio:
		titulo link descripcion
	;
	canal_opcional:
		categoria derechos imagen
	;
	canal:
		A_CANAL canal_obligatorio canal_opcional items C_CANAL
	;
	documento:
		defXML defRSS canal C_RSS
	;
%%
yyerror(char *msg)
{
	printf("%s\n",msg);
}
int eval_parse(int salida)
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
		yyin=fopen(argv[1],"rt");
		if(yyin==NULL)
		{
			printf("Archivo inexistente\n");
		}
		else
		{
			eval_parse(yyparse());
		}
	}
	else
	{
		printf("Ingrese por teclado\n");
		yyin=stdin;
		eval_parse(yyparse());
	}
	fclose(yyin);
	return 0;
}