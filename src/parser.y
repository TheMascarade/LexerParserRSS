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
	A_RSS D_RSS C_RSS
	A_XML D_XML C_XML
	CAD ENLACE VERSION


%%

%%