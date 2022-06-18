%{
	#include<stdio.h>
	int yylex(int);
	void yyerror(void);
%}
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
	D_RSS
	D_XML
	CAD ENLACE NUM
%start documento


%%
	titulo:
		A_TITULO CAD C_TITULO
	descripcion:
		A_DESC CAD C_DESC
	categoria:
		A_CAT CAD C_CAT
	derechos:
		A_DER CAD C_DER
	alto:
		A_ALT NUM C_ALT
	ancho:
		A_ANCHO NUM C_ANCHO
	url:
		A_URL ENLACE C_URL
	link:
		A_LINK ENLACE C_LINK
	defRSS:
		D_RSS
	defXML:
		D_XML	
%%