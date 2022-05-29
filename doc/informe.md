# Trabajo Práctico Integrador

- Grupo número: 6
- Integrantes:
	- Bella Matias Nicolas.
	- Molinas González Víctor.
	- Lezcano Claudio Federico.
	- Gomes Martin.
- Asignatura: Sintaxis y semántica de los lenguajes.
- Carrera: Ingeniería de Sistemas de Información.
- Primer cuatrimestre.
- Ciclo académico: 2022.
- Universidad Tecnológica Nacional facultad regional de Resistencia.

<div style="page-break-after: always"></div>

## Índice

1. [Introducción](#introducción)

2. [Gramática](#gramática)

	1. [Tipos de datos y derivados](#tipos-de-datos-y-derivados)
     
		1. [Números enteros](#números-enteros)
     
		3. [Cadena de caracteres](#cadena-de-caracteres)
     
		4. [URL](#url)
  
    2. [Cuerpo del documento](#cuerpo-del-documento)
     
		1. [Cabecera](#cabecera)
     
        2. [Canal](#canal)

    	3. [Items](#items)

		4. [Imagen](#imágen)
     
    3. [Símbolos no terminales](#símbolos-no-terminales)
     
    4. [Símbolos terminales](#símbolos-terminales)

3. [Lexer](#lexer)

<div style="page-break-after: always"></div>

## Introducción

El trabajo documentado a continuación consiste en el desarrollo de un analizador léxico y sintáctico para la validación de contenido distribuido en el formato web *RSS*.

RSS es un formato de sindicación de contenido web derivado de XML, su propósito es facilitar la distribución de contendido actualizado de forma frecuente mediante un sistema de suscripciones y sin la necesidad de acceder al sitio web o blog en sí mismo.

Se trabajará a lo largo de tres etapas principales, la primera de ellas utilizando conocimientos de teoría de lenguajes y gramáticas formales para formular un conjunto de producciones, estas comprenderán la gramática libre de contexto a modo de una descripción formal de RSS.

La segunda etapa consistirá en la conformación de un lexer que deberá ser capaz de identificar cada uno de los tokens dentro del documento, este conformará la primer etapa de detección de errores en el contenido, ya sean lexicos o sintácticos.

<div style="page-break-after: always"></div>

## Gramática

### Tipos de datos y derivados

#### Números enteros

```
<NUM> --> 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0

<VERSION> --> <NUM> | <NUM>.<VERSION>
<ALTO> --> <height><NUM></height>
<ANCHO> --> <width><NUM></width>
```

#### Cadena de caracteres

```
<CAD> -->  \b | \t | \n | a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | , | . | ¿ | ? | ¡ | ! | / | \ | $ | ` | ´ | " | # | % | @ | & | - | _

<CAD> --> A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z

<TITULO> --> <title><CAD></title>
<DESC> --> <description><CAD><description>
<CATEGORÍA> --> <category><CAD></category>
<DERECHOS> --> <copyright><CAD></copyright>
```

#### URL

```
<PROT> --> http | https | ftp | ftps

<CAR> --> a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | _ | - | & | ? | =

<CAR> --> A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z

<RUTA> --> <CAR> | <CAR>/<RUTA>
<DOMINIO> --> <CAR> | <CAR>.<DOMINIO>
<PUERTO> --> <NUM>

<ENLACE> --> <PROT>:// | <PROT>://<DOMINIO>/ | <PROT>://<DOMINIO>/<RUTA> | <PROT>://<DOMINIO>:<PUERTO>/ | <PROT>://<DOMINIO>:<PUERTO>/<RUTA>#<CAR> | <PROT>://<DOMINIO>/<RUTA>#<CAR>

<LINK> --> <link><ENLACE></link>
<URL> --> <url><ENLACE></url>
```

### Cuerpo del documento

#### Cabecera

```
<SIGMA> --> <DEFXML><DEFRSS>

<VERSIONADO> --> version
<CODIFICACION> --> encoding
<IGUAL> --> =

<DEFXML> --> <?xml<VERSIONADO><IGUAL>"<VERSION>"<CODIFICACION><IGUAL>"<CAD>"?> | <?xml<VERSIONADO><IGUAL>"<VERSION>”?>
<DEFRSS> --> <rss<VERSIONADO><IGUAL>"<VERSION>"><CANAL></rss>
```

#### Canal

```
<CANAL-OBLIGATORIO> --> <TITULO><LINK><DESC>

<CANAL-OPCIONAL> --> <CATEGORIA><DERECHOS><IMAGEN> |  <CATEGORIA><DERECHOS> | <CATEGORIA><IMAGEN> | <DERECHOS><IMAGEN> | <CATEGORIA> | <DERECHOS> | <IMAGEN>

<CANAL-VACIO> --> <channel><CANAL-OBLIGATORIO></channel> | <channel><CANAL-OBLIGATORIO><CANAL-OPCIONAL></channel>

<CANAL-ITEMS> --> <channel><CANAL-OBLIGATORIO><ITEMS></channel> | <channel><CANAL-OBLIGATORIO><CANAL-OPCIONAL><ITEMS></channel>

<CANAL> --> <CANAL-VACIO> | <CANAL-ITEMS>
```

#### Items

```
<ITEM-OBLIGATORIO> --> <TITULO><LINK><DESC> | <TITULO><DESC><LINK> | <LINK><TITULO><DESC> | <LINK><DESC><TITULO> | <DESC><LINK><TITULO> | <DESC><TITULO><LINK>

<ITEM> --> <item><ITEM-OBLIGATORIO></item> | <item><CATEGORIA><ITEM-OBLIGATORIO></item> | <item><ITEM-OBLIGATORIO><CATEGORIA></item>

<ITEMS> --> <ITEM><ITEMS> | <ITEM>
```

#### Imágen

```
<IMAGEN-OBLIGATORIO> --> <TITULO><URL><LINK> | <TITULO><LINK><URL> | <LINK><TITULO><URL> | <LINK><URL><TITULO> | <URL><TITULO><LINK> | <URL><LINK<TITULO>

<IMAGEN-OPCIONAL> --> <ALTO><ANCHO> | <ANCHO><ALTO> | <ALTO> | <ANCHO>

<IMAGEN> --> <image><IMAGEN-OBLIGATORIO></image> | <image><IMAGEN-OBLIGATORIO><IMAGEN-OPCIONAL></image> | <image><IMAGEN-OPCIONAL><IMAGEN-OBLIGATORIO></image>
```

#### Símbolos no terminales

```
<NUM>
<CAD>
<TÍTULO>
<DESC>
<CATEGORÍA>
<DERECHOS>
<PROT>
<CAR>
<LINK>
<URL>
<DEFXML>
<DEFRSS>
<CANAL-OBLIGATORIO>
<CANAL-OPCIONAL>
<CANAL-VACIO>
<CANAL-ITEMS> 
<ITEM>
<ITEMS>
<ITEM-OBLIGATORIO>
<ALTURA>
<ANCHO>
<IMAGEN-OBLIGATORIO>
<IMAGEN-OPCIONAL>
<IMAGEN>
<DOMINIO>
<VERSION>
<RUTA>
<VERSIONADO>
<CODIFICACION>
<IGUAL>
```

#### Símbolos terminales

```
1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 - 0 - a - b - c - d - f - g - h - i - j - k - l - m - n - o - p - q - r - s - t - u - v - w - x - y - z - A - B - C - D - E - F - G - H - I - J - K - L - M - N - O - P - Q - R - S - T - U - V - W - X - Y - Z - , -. - ¿ - ? - ¡ - ! - / - \ - $ - ` - ´ - " - # - % - @ - & - _ - - - \    b - \t - \n - <title> - </title> - <description> - <description> - <category> - </category> - <?xml - ?> - <rss - > - </rss> - <channel> - </channel> - <item> - </item> - <copyright> - </copyright> -
</image> - <image> - </width> - <width> - http - https - ftp - ftps
```

<div style="page-break-after: always"></div>

## Lexer
