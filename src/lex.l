
%{
#include <stdio.h>
%}
%option noyywrap
%option yylineno

numero 				[0-9]+
letra               [À-ÿa-zA-Z0-9\/,._\-%&()#!?¡¿:*;'@#$%&=+`~|°]
vers_num 			{qu}{numero}(\.{numero})*{qu}
qu                  ["]
espacio				[ \t\n\r]
cadena              {espacio}*{letra}{letra}*{espacio}*

caracter_url        [a-zA-Z0-9]|[-_.?&%=]
texto_url           {caracter_url}{caracter_url}*

dp                  [:]
sl                  [/]
hs                  [#]
dominio             {texto_url}{texto_url}*+{sl}?
puerto              {dp}+{numero}
ruta                {sl}?+{dominio}?
fragmento           {hs}+{dominio}
protocolo           "http"|"https"|"ftp"|"ftps"
enlace              {protocolo}{dp}{sl}{sl}{dominio}{dominio}*{puerto}?{ruta}*{fragmento}*

defXML				<?xml{espacio}version{espacio}={espacio}"{version}"{espacio}(encoding{espacio}={espacio}"{cadena}")?{espacio}?>
defRSS				<rss{espacio}version{espacio}={espacio}"{version}"{espacio}>

%%
"quit"                  {quit(); return 0;}
"<title>"			    {printf("-Apertura de titulo: %s\n", yytext);}
"</title>"			    {printf("-Clausura de titulo: %s\n", yytext);}
"<description>"		    {printf("-Apertura de descripcion: %s\n", yytext);}
"</description>"	    {printf("-Clausura de descripcion: %s\n", yytext);}
"<category>"		    {printf("-Apertura de categoria: %s\n", yytext);}
"</category>"		    {printf("-Clausura de categoria: %s\n", yytext);}
"<copyright>"		    {printf("-Apertura de copyright: %s\n", yytext);}
"</copyright>"		    {printf("-Clausura de copyright: %s\n", yytext);}
"<hight>"			    {printf("-Apertura de alto: %s\n", yytext);}
"</hight>"			    {printf("-Clausura de alto: %s\n", yytext);}
"<width>"			    {printf("-Apertura de ancho: %s\n", yytext);}
"</width>"			    {printf("-Clausura de ancho: %s\n", yytext);}
"<link>"			    {printf("-Apertura de link: %s\n", yytext);}
"</link>"			    {printf("-Clausura de link: %s\n", yytext);}
"<url>"				    {printf("-Apertura de url: %s\n", yytext);}
"</url>"			    {printf("-Clausura de url: %s\n", yytext);}

{vers_num}			    {printf("-Version: %s\n", yytext);}
{defRSS}			    {printf("-Apertura de documento rss: %s\n", yytext);}
{defXML}			    {printf("-Definicion XML: %s\n", yytext);}
"</rss>"			    {printf("-Clausura de documento RSS: %s\n", yytext);}
"<channel>"			    {printf("-Apertura de canal: %s\n", yytext);}
"</channel>"		    {printf("-Clausura de canal: %s\n", yytext);}
"<item>"			    {printf("-Apertura de item: %s\n", yytext);}
"</item>"			    {printf("-Clausura de item: %s\n", yytext);}
"<image>"			    {printf("-Apertura de imagen: %s\n", yytext);}
"</image>"			    {printf("-Clausura de imagen: %s\n", yytext);}
{enlace}			    {printf("-Enlace: %s\n", yytext);}
({cadena}*|{numero}*)   {printf("-Cadena de caracteres: %s\n", yytext);}
{espacio}               {;}
.					    {printf("-Sentencia no reconocido: %s\n", yytext);}

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