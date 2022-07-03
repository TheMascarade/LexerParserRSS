bin/lexerRSS.sh: src/lex.yy.c
	gcc src/lex.yy.c -o bin/lexerRSS.sh
src/lex.yy.c:
	flex src/lex.l