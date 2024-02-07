%{
#include <stdio.h>
extern int yylex();
extern int lineNum;
extern int lineCol;
/*the reason I used extern int here and didnt directly define it is because it's already defined in another file */
%} 

%union {
 char *id;
 float num;
/* char *identoralpha; "wasn't sure about this type so left it in a comment for now */
}

%start input

%token <num> NUMBER
%token <id> IDENTIFIER
%token MAIN FUNCTION
%token SEMICOLON
%token LEFTCURLY
%token RIGHTCURLY
%token LEFTBRACK
%token RIGHTBRACK
%left PLUS MINUS 
%left TIMES DIVIDE MOD
%left LFTPAREN RGTPAREN
