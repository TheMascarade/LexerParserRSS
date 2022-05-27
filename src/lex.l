%{
#include <stdio.h>
%}
%option noyywrap
%option yylineno

numero 				[0-9]+
version 			{numero}(\.{numero})*
cadena				([a-zA-Z]|@|%|#|&|¿|\?|!|¡|-|_|\+|\/|\|\(|\)|\.)+
espacio				[ \t\n\r]+

caracteres			([a-zA-Z]|[0-9]|-|_|=|\?|&)+
protocolo			(http|https|ftp|ftps)
dominio				{caracteres}(\.{caracteres})*
ruta				{caracteres}(\/caracteres)*
extension			[a-zA-Z]+
archivo 			{caracteres}\.{extension}
puerto				[1-9][0-9]{0,4}

enlace				{protocolo}:\/\/(www.)?{dominio}(:{puerto})?\/({ruta}\/({archivo}#{caracteres})?)?

defXML				<\?xml{espacio}version{espacio}={espacio}"{version}"{espacio}(encoding{espacio}={espacio}"{cadena}")?{espacio}\?>
defRSS				<rss{espacio}version{espacio}={espacio}"{version}"{espacio}>

%%
"<title>"			{printf("Apertura de titulo");}
"</title>"			{printf("Clausura de titulo");}
"<description>"		{printf("Apertura de descripcion");}
"</description>"	{printf("Clausura de descripcion");}
"<category>"		{printf("Apertura de categoria");}
"</category>"		{printf("Clausura de categoria");}
"<copyright>"		{printf("Apertura de copyright");}
"</copyright>"		{printf("Clausura de copyright");}
"<hight>"			{printf("Apertura de alto");}
"</hight>"			{printf("Clausura de alto");}
"<width>"			{printf("Apertura de ancho");}
"</width>"			{printf("Clausura de ancho");}
"<link>"			{printf("Apertura de link");}
"</link>"			{printf("Clausura de link");}
"<url>"				{printf("Apertura de url");}
"</url>"			{printf("Clausura de url");}
{cadena}			{printf("Cadena de caracteres");}
{enlace}			{printf("Enlace");}
{version}			{printf("Version");}
{defRSS}			{printf("Apertura de documento rss");}
{defXML}			{printf("Definicion XML");}
"</rss>"			{printf("Clausura de documento RSS");}
"<channel>"			{printf("Apertura de canal");}
"</channel>"		{printf("Clausura de canal");}
"<item>"			{printf("Apertura de item");}
"</item>"			{printf("Clausura de item");}
"<image>"			{printf("Apertura de imagen");}
"</image>"			{printf("Clausura de imagen");}
{espacio}			{}
.					{printf("ERROR: lexema no identificado.");}

%%
