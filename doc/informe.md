# Trabajo Práctico Integrador

- Grupo número: 6
- Integrantes:
	- Bella Matias Nicolas.
	- Molinas González Víctor.
	- Lezcano Claudio Federico.
	- Gomes Martin Maximiliano.
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

    4. [Tokens Utilizados]

<div style="page-break-after: always"></div>

## Introducción

El trabajo documentado a continuación consiste en el desarrollo de un analizador léxico y sintáctico para la validación de contenido distribuido en el formato web *RSS*.

RSS es un formato de sindicación de contenido web derivado de XML, su propósito es facilitar la distribución de contendido actualizado de forma frecuente mediante un sistema de suscripciones y sin la necesidad de acceder al sitio web o blog en sí mismo.

Se trabajará a lo largo de tres etapas principales:

### 1. Desarrollo de la gramática

Se utilizaron conocimientos de teoría de lenguajes y gramáticas formales para formular un conjunto de producciones, estas comprenderán la gramática a modo de una descripción formal de RSS.

En esta primer etapa fué crítico, como primera instancia, evaluar la complejidad que se requería de las producciones gramaticales para establecer un conjunto de reglas coherentes y fáciles de entender; éstas deben permitir generar sólamente contenido válido en formato RSS a la vez que evitar complejidades que podrían afectar su interpretación y, potencialmente, el desempeño del parser.

![Jerarquía de lenguajes - Chomsky](https://i.imgur.com/i6bEltU.png "Jerarquía de lenguajes - Chomsky")

Analizando el formato característico de los documentos RSS y teniendo en cuenta la jerarquía de lenguajes de Chomsky se optó por una gramática de tipo 2, libre de contexto, para la formulación de las producciones.

### 2. Desarrollo del lexer

La segunda etapa consistirá en la conformación de un lexer que deberá ser capaz de identificar cada uno de los tokens dentro del documento, este conformará la primer etapa de detección de errores en el contenido, ya sean lexicos o sintácticos.

En el desarrollo de esta estapa se hizo uso de Flex, una herramienta especializada en la generación de escáners léxicos. La forma en que desempeña su tarea es tomando una entrada, ya sea un archivo o entrada estándar, que es usada como "esqueleto" o descripción del escáner a generar.

La descripción del escáner, en caso de ser un archivo, debe tener la extensión `.l` que deberemos especificar como entrada por medio del comando `$ flex nombre-archivo.l` lo que generará un archivo fuente con extensión `.c`, por defecto `lex.yy.c`, que deberá ser compilado.

Esta descripción estará compuesta de cuatro partes:

![Secciones de la descripción del escáner](https://i.imgur.com/d0fBykE.png)

#### Sección de definiciones

Contiene declaraciones de definiciones nombradas para simplificar las especificaciones del escáner y declaraciones de condiciones de inicio.

Una definición es una palabra que compienza con letra o guión bajo y que puede contener letras, números, guión bajo o medio y que está precedida por una expresión regular de la cual funciona como referencia.

Ej:

```c
DIGITO		[0-9]
```

#### Sección de código C

Nos permite definir macros, importar librerías, etc. que podrán ser útiles en la sección de reglas cuando queramos retornar algún valor o imprimir a salida estándar algún resultado.

Todo lo que esté presente en esta sección será copiado literalmente al archivo `lex.yy.c`.

#### Sección de reglas

Esta sección contiene una serie de reglas que siguen el siguiente patrón:

```
patrón		acción
```

Donde:

- `patrón`: puede ser una referencia a una expresión regular o una expresión en sí mismo y no puede estar indentado.
- `acción`: debe comenzar en la misma línea que el patrón al que está relacionada y refiere a código a ejecutarse cuando se satisfaga el patrón en la entrada.

#### Sección de código de usuario

Esta sección opcional es copiada de forma literal al archivo `lex.yy.c` y es usada para rutinas de acompañamiento que llaman o son llamadas por el escáner.

<div style="page-break-after: always"></div>

---

Una vez generado el archivo `lex.yy.c` este debe ser compilado para obtener el ejecutable.

Llegada esta etapa tendremos dos formas de utilizar el analizador léxico generado:
- Pasarle la entrada mediante consola, es decir, en modo interactivo.
- Definir un archivo de prueba y pasarlo como entrada al ejecutar el lexer.

Independientemente de la forma que tome la entrada el escáner la analizará buscando cadenas de caracteres que coincidan con alguna de las reglas definidas.

Una vez que una coincidencia es determinada el texto correspondiente a ella se hace disponible en el puntero de caracter global `yytext` y su longitud en el puntero entero `yyleng`. La acción correspondiente a la regla es ejecutada y el resto de la entrada es analizada en busca de la siguiente coincidencia.

En el caso de que haya una coincidencia con dos reglas diferentes se tomará la que incluya la mayor cantidad de texto y, si ambas tienen la misma cantidad, se tomará la que haya estado definida primero en la descripción del escáner.

Si no existen coincidencias entonces se ejecutará la regla por defecto: el siguiente caracter en la entrada es considerado como coincidente y copiado a salida estándar.

## Gramática

### Tipos de datos y derivados

#### Números enteros

```
{NUM}		--> 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0
{VERSION}	--> {NUM} | {NUM}.{VERSION}
{ALTO}		--> <height>{NUM}</height>
{ANCHO}		--> <width>{NUM}</width>
```

#### Cadena de caracteres

```
{CAD}		-->  \b | \t | \n | a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | , | . | ¿ | ? | ¡ | ! | / | \ | $ | ` | ´ | " | # | % | @ | & | - | _

{CAD}		--> A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z

{TITULO}	--> <title>{CAD}</title>
{DESC}		--> <description>{CAD}<description>
{CATEGORÍA}	--> <category>{CAD}</category>
{DERECHOS}	--> <copyright>{CAD}</copyright>
```

#### URL

```
{PROT}		--> http | https | ftp | ftps

{CAR}		--> a | b | c | d | e | f | g | h | i | j | k | l | m | n | o | p | q | r | s | t | u | v | w | x | y | z | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 0 | _ | - | & | ? | =

{CAR}		--> A | B | C | D | E | F | G | H | I | J | K | L | M | N | O | P | Q | R | S | T | U | V | W | X | Y | Z

{RUTA}		--> {CAR} | {CAR}/{RUTA}
{DOMINIO}	--> {CAR} | {CAR}.{DOMINIO}
{PUERTO}	--> {NUM}

{ENLACE}	--> {PROT}:// | {PROT}://{DOMINIO}/ | {PROT}://{DOMINIO}/{RUTA} | {PROT}://{DOMINIO}:{PUERTO}/ | {PROT}://{DOMINIO}:{PUERTO}/{RUTA}#{CAR} | {PROT}://{DOMINIO}/{RUTA}#{CAR}

{LINK}		--> <link>{ENLACE}</link>
{URL}		--> <url>{ENLACE}</url>
```

### Cuerpo del documento

#### Cabecera

```
{SIGMA}		--> {DEFXML}{DEFRSS}

{VERSIONADO}	--> version
{CODIFICACION}	--> encoding
{IGUAL}		--> =

{DEFXML}	--> <?xml{VERSIONADO}{IGUAL}"{VERSION}"{CODIFICACION}{IGUAL}"{CAD}"?> | <?xml{VERSIONADO}{IGUAL}"{VERSION}”?>
{DEFRSS}	--> <rss{VERSIONADO}{IGUAL}"{VERSION}">{CANAL}</rss>
```

#### Canal

```
{CANAL-OBLIGATORIO}	--> {TITULO}{LINK}{DESC}

{CANAL-OPCIONAL}	--> {CATEGORIA}{DERECHOS}{IMAGEN} |  {CATEGORIA}{DERECHOS} | {CATEGORIA}{IMAGEN} | {DERECHOS}{IMAGEN} | {CATEGORIA} | {DERECHOS} | {IMAGEN}

{CANAL-VACIO}		--> <channel>{CANAL-OBLIGATORIO}</channel> | <channel>{CANAL-OBLIGATORIO}{CANAL-OPCIONAL}</channel>

{CANAL-ITEMS}		--> <channel>{CANAL-OBLIGATORIO}{ITEMS}</channel> | <channel>{CANAL-OBLIGATORIO}{CANAL-OPCIONAL}{ITEMS}</channel>

{CANAL}			--> {CANAL-VACIO} | {CANAL-ITEMS}
```

#### Items

```
{ITEM-OBLIGATORIO}	--> {TITULO}{LINK}{DES} | {TITULO}{DESC}{LIN} | {LINK}{TITULO}{DES} | {LINK}{DESC}{TITUL} | {DESC}{LINK}{TITUL} | {DESC}{TITULO}{LIN}

{ITEM}			--> <item>{ITEM-OBLIGATORIO}</item> | <item>{CATEGORIA}{ITEM-OBLIGATORIO}</item> | <item>{ITEM-OBLIGATORIO}{CATEGORIA}</item>

{ITEMS}			--> {ITEM}{ITEMS} | {ITEM}
```

#### Imágen

```
{IMAGEN-OBLIGATORIO}	--> {TITULO}{URL}{LINK} | {TITULO}{LINK}{URL} | {LINK}{TITULO}{URL} | {LINK}{URL}{TITULO} | {URL}{TITULO}{LINK} | {URL}{LINK}TITULO}

{IMAGEN-OPCIONAL}	--> {ALTO}{ANCHO} | {ANCHO}{ALTO} | {ALTO} | {ANCHO}

{IMAGEN}		--> <image>{IMAGEN-OBLIGATORIO}</image> | <image>{IMAGEN-OBLIGATORIO}{IMAGEN-OPCIONAL}</image> | <image>{IMAGEN-OPCIONAL}{IMAGEN-OBLIGATORIO}</image>
```

#### Símbolos no terminales

```
{NUM}
{CAD}
{TÍTULO}
{DESC}
{CATEGORÍA}
{DERECHOS}
{PROT}
{CAR}
{LINK}
{URL}
{DEFXML}
{DEFRSS}
{CANAL-OBLIGATORIO}
{CANAL-OPCIONAL}
{CANAL-VACIO}
{CANAL-ITEMS>}
{ITEM}
{ITEMS}
{ITEM-OBLIGATORIO}
{ALTURA}
{ANCHO}
{IMAGEN-OBLIGATORIO}
{IMAGEN-OPCIONAL}
{IMAGEN}
{DOMINIO}
{VERSION}
{RUTA}
{VERSIONADO}
{CODIFICACION}
{IGUAL}
```

#### Símbolos terminales

```
1 - 2 - 3 - 4 - 5 - 6 - 7 - 8 - 9 - 0 - a - b - c - d - f - g - h - i - j - k - l - m - n - o - p - q - r - s - t - u - v - w - x - y - z - A - B - C - D - E - F - G - H - I - J - K - L - M - N - O - P - Q - R - S - T - U - V - W - X - Y - Z - , -. - ¿ - ? - ¡ - ! - / - \ - $ - ` - ´ - " - # - % - @ - & - _ - - - \    b - \t - \n - <title> - </title> - <description> - <description> - <category> - </category> - <?xml - ?> - <rss - > - </rss> - <channel> - </channel> - <item> - </item> - <copyright> - </copyright> -
</image> - <image> - </width> - <width> - http - https - ftp - ftps
```

<div style="page-break-after: always"></div>

## Lexer

### Tokens Utilizados

Los siguientes tokens seran el resultado del análisis en la siguiente etapa.
 
```
<title> - </title> - <description> - </description> - <category> - </category> - <copyright> - </copyright> - <height> - </height> - <width> - </width> - <link> - </link> - <channel> - </channel> - <url> - </url> - <item> - </item> - <image> - </imagen> - </rss> - {version} - {xml} - {cxml} - {rss} - {defRSS} - {defXML} - {enlace} - {cadena de caracteres} - {espacio}
```

Una vez detectado el token se devuelve junto con la porción de la entrada que corresponde con el token.
 
```
    Token: Texto de entrada
```
Ej:

```
    -Enlace: https://www.google.com
```
En el caso de algunos tokens se añadirá si corresponde a una apertura o una clausura de sentencia.

 Ej:

```
    -Apertura de item: <item>
    -Clausura de item: </item>
```