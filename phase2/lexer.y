%{

#include <stdio.h>

int yylex();
void yyerror(const char *s);
%}


%token IDENT
%token NUMBER
%token FUNC
%token MAINFUNC
%token SEMICOLON
%token COMMA
%token LEFTCURLY
%token RIGHTCURLY
%token LEFTBRACK
%token RIGHTBRACK
%left PLUS MINUS
%left TIMES DIVIDE MOD
%left LFTPAREN RGTPAREN



%start program

%%
program: %empty
%%

int main(void) {
yyparse();
}

void yyerror(const char *s) {
 printf("Error: %s\n", s);
}
