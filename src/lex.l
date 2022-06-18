%{
#include <stdio.h>
%}
%option noyywrap
%option yylineno

numero 				[0-9]+
letra               [À-ÿa-zA-Z0-9\/,._\-%&()#!?¡¿:*;'@#$%&=+`~|°\"]
vers_num 			{qu}{numero}(\.{numero})*{qu}
qu                  ["]
espacio				[" "]
cadena              {espacio}*{letra}{letra}*{espacio}*

caracter_url        [a-zA-Z0-9]|[-_.?&%=]
texto_url           {caracter_url}{caracter_url}*

dp                  [:]
sl                  [/]
hs                  [#]
dominio             {texto_url}(\.{texto_url})+
puerto              {dp}{numero}
ruta                {sl}({texto_url}{sl})*
fragmento           {hs}?{texto_url}
protocolo           (http|https|ftp|ftps){dp}{sl}{sl}
enlace              {protocolo}(www)?{dominio}{puerto}?({ruta}{fragmento}?)?

may                 ">"
rss                 "<rss"
version             (version{espacio}*={espacio}*{vers_num})
encoding            (encoding{espacio}*={espacio}*{qu}{cadena}{qu})
xml                 "<?xml"
cxml				"\?>"

defXML				({xml}{espacio}*{version}{espacio}*{encoding}{espacio}*{cxml})
defRSS				({rss}{espacio}*{version}{espacio}*{may})

%%
"quit"                  {quit(); return 0;}
"<title>"			    {return(A_TITULO);}
"</title>"			    {return(C_TITULO);}
"<description>"		    {return(A_DESC);}
"</description>"	    {return(C_DESC);}
"<category>"		    {return(A_CAT);}
"</category>"		    {return(C_CAT);}
"<copyright>"		    {return(A_DER);}
"</copyright>"		    {return(C_DER);}
"<height>"			    {return(A_ALT);}
"</height>"			    {return(C_ALT);}
"<width>"			    {return(A_ANCHO);}
"</width>"			    {return(C_ANCHO);}
"<link>"			    {return(A_LINK);}
"</link>"			    {return(C_LINK);}
"<url>"				    {return(A_URL);}
"</url>"			    {return(C_URL);}
"<channel>"			    {return(A_CANAL);}
"</channel>"		    {return(C_CANAL);}
"<item>"			    {return(A_ITEM);}
"</item>"			    {return(C_ITEM);}
"<image>"			    {return(A_IMG);}
"</image>"			    {return(C_IMG);}
"</rss>"			    {return(C_RSS);}
{version}				{return(VERSION);}
{xml}					{return(A_XML);}
{cxml}					{return(C_XML);}
{rss}					{return(A_RSS);}
{defRSS}		        {return(D_RSS);}
{defXML}			    {return(D_XML);}
{enlace}			    {return(ENLACE);}
({cadena}*|{numero}*)   {return(CAD);}
{espacio}               {;}
"\n"                    {;}
"\t"                    {;}
.					    {return();}
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