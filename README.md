# Un pequeño lexer/parser de RSS
## Instrucciones para compilar

Si se hacen cambios sobre lex.l es necesario regenerar `lex.yy.c` con:
```sh
flex lex.l
```
Despues de cualquier cambio en la gramática dentro de `parser.y` es necesario regenerar `parser.tab.c` y `parser.tab.h` con:
```sh
bison -d parser.y
```

Para compilar y generar el parser sólamente es necesario correr
```sh
gcc parser.tab.c -o parser.sh
```