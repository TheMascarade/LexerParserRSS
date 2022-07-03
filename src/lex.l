%{
#include <stdio.h>
#include "parser.tab.h"
%}
%option noyywrap
%option yylineno

numero 				[0-9]+
letra               [À-ÿa-zA-Z0-9\/,._\-%&()#!?¡¿:*;'@#$%&=+`~|°\"]
vers_num 			{qu}{numero}(\.{numero})*{qu}
qu                  ["]
espacio				[" "]
cadena				({espacio}*|{letra}+)+ 

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
a_xml				"<?xml"
c_xml				"\?>"
c_rss				"</rss>"

defXML				({a_xml}{espacio}*{version}{espacio}*{encoding}{espacio}*{c_xml})
defRSS				({rss}{espacio}*{version}{espacio}*{may})

%%
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
{defRSS}		        {return(D_RSS);}
{c_rss}					{return(C_RSS);}
{defXML}			    {return(D_XML);}
{enlace}			    {return(ENLACE);}
{cadena}			  	{return(CAD);}
{numero}				{return(NUM);}
{espacio}               {;}
"\n"                    {;}
"\t"                    {;}
.					    {;}
%%