%{
#include <stdio.h>
%}
%option noyywrap
%option yylineno

numero				[0-9]+
letra				[À-ÿa-zA-Z0-9\/,._\-%&()#!?¡¿:*;'@#$%&=+`~|°\"]
vers_num 			{qu}{numero}(\.{numero})*{qu}
qu					["]
espacio				[" "]
cadena				({letra}+|{espacio}*|{numero}*)+

caracter_url		[a-zA-Z0-9]|[-_.?&%=]
texto_url			{caracter_url}{caracter_url}*

dp					[:]
sl					[/]
hs					[#]
dominio				{texto_url}(\.{texto_url})+
puerto				{dp}{numero}
ruta				{sl}({texto_url}{sl})*
fragmento			{hs}?{texto_url}
protocolo			(http|https|ftp|ftps){dp}{sl}{sl}
enlace				{protocolo}(www)?{dominio}{puerto}?({ruta}{fragmento}?)?

may					">"
rss					"<rss"
version				(version{espacio}*={espacio}*{vers_num})
encoding			(encoding{espacio}*={espacio}*{qu}{cadena}{qu})
xml					"<?xml"
cxml				"\?>"

defXML				({xml}{espacio}*{version}{espacio}*{encoding}{espacio}*{cxml})
defRSS				({rss}{espacio}*{version}{espacio}*{may})

%%
"quit"					{quit(); return 0;}
"<title>"			    {printf("-Apertura de titulo: %s\n", yytext);}
"</title>"			    {printf("-Clausura de titulo: %s\n", yytext);}
"<description>"		    {printf("-Apertura de descripcion: %s\n", yytext);}
"</description>"	    {printf("-Clausura de descripcion: %s\n", yytext);}
"<category>"		    {printf("-Apertura de categoria: %s\n", yytext);}
"</category>"		    {printf("-Clausura de categoria: %s\n", yytext);}
"<copyright>"		    {printf("-Apertura de copyright: %s\n", yytext);}
"</copyright>"		    {printf("-Clausura de copyright: %s\n", yytext);}
"<height>"			    {printf("-Apertura de alto: %s\n", yytext);}
"</height>"			    {printf("-Clausura de alto: %s\n", yytext);}
"<width>"			    {printf("-Apertura de ancho: %s\n", yytext);}
"</width>"			    {printf("-Clausura de ancho: %s\n", yytext);}
"<link>"			    {printf("-Apertura de link: %s\n", yytext);}
"</link>"			    {printf("-Clausura de link: %s\n", yytext);}
"<url>"				    {printf("-Apertura de url: %s\n", yytext);}
"</url>"			    {printf("-Clausura de url: %s\n", yytext);}
"<channel>"			    {printf("-Apertura de canal: %s\n", yytext);}
"</channel>"		    {printf("-Clausura de canal: %s\n", yytext);}
"<item>"			    {printf("-Apertura de item: %s\n", yytext);}
"</item>"			    {printf("-Clausura de item: %s\n", yytext);}
"<image>"			    {printf("-Apertura de imagen: %s\n", yytext);}
"</image>"			    {printf("-Clausura de imagen: %s\n", yytext);}
"</rss>"			    {printf("-Clausura de documento RSS: %s\n", yytext);}
{version}				{printf("-Version: %s\n", yytext);}
{xml}					{printf("-Apertura XML: %s\n", yytext);}
{cxml}					{printf("-Clausura XML: %s\n", yytext);}
{rss}					{printf("-Apertura RSS: %s\n", yytext);}
{defRSS}				{printf("-Apertura de documento RSS: %s\n", yytext);}
{defXML}				{printf("-Definicion XML: %s\n", yytext);}
{enlace}				{printf("-Enlace: %s\n", yytext);}
{cadena}				{printf("-Cadena de caracteres: %s\n", yytext);}
{espacio} 				{;}
"\n"					{;}
"\t"					{;}
.						{printf("-Sentencia no reconocida: %s\n", yytext);}
%%

// Abre archivo o permite el ingreso manual
int main (int argc, char *argv[]){
    if (argc == 2){
        if ( (yyin = fopen(argv[1], "rt")) == NULL){
            printf ("\nNo se puede abrir el archivo (%s)\n", argv[1]);
            return 1;
        } else{
            printf("\nArchivo (%s) abierto.\n", argv[1]);
            yylex();
        }
        printf ("\nFin del archivo (%s)\n", argv[1]);
        fclose(yyin);
        return 0;
    } else{
        yyin = stdin;
        printf ("\nIngrese manualmente las sentencias. Escriba quit para salir\n");
        yylex();
    }
}
quit(){
    printf("Saliendo\n");
}