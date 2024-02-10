all:
	bison -t -d -v lexer.y
	flex lexer.lex
	g++ lex.yy.c lexer.tab.c -lfl
