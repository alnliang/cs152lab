%{

#include <stdlib.h>
int yylex();
void yyerror(const char *s);

%}


%token NUMBER
%token IDENTIFIER
%token FUNCTION
%token SEMICOLON
%token LEFTCURLY
%token RIGHTCURLY
%token LEFTBRACK
%token RIGHTBRACK
%token COMMA
%token RETURN
%token INTEGER
%token PRINT 
%token READ
%token WHILE
%token IF 
%token ELSE
%token BREAK
%token CONT 
%token FOR 
%token MAINFUNC
%token ALPHA


%left PLUS MINUS 
%left TIMES DIVIDE MOD
%left LFTPAREN RGTPAREN
%left EQUALS
%left LESS
%left LESSEQL
%left GREATER
%left GREATEREQL
%left EQUALITY
%left NOTEQL



%start program

%%
program: %empty;
%%

int main(void) {
yyparse();
}

void yyerror(const char *s) {
 printf("Error: %s\n", s);
}
