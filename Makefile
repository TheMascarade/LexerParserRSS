FLEX=*.l
BISON=*.y
SRC=src/
BIN=bin/

all: flex bison parser

flex:
	flex -o $(SRC)lex.yy.c $(SRC)$(FLEX)

bison:
	bison -o $(SRC)parser.tab.c -d $(SRC)$(BISON) 
parser:
	gcc -o $(BIN)parserRSS.sh $(SRC)parser.tab.c 