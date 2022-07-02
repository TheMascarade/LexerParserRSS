/bin/parserRSS.sh: src/parser.tab.c
	gcc src/parser.tab.c -o bin/parserRSS.sh
/src/parser.tab.c: src/lex.yy.c
	bison -d src/parser.y
/src/lex.yy.c:
	flex src/lex.l