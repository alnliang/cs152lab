%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int lineNum;
extern int lineCol;
/*the reason I used extern int here and didn't directly define it is because it's already defined in another file */
%} 

%union {
 char *id;
 float num;
/* char *identoralpha; "wasn't sure about this type so left it in a comment for now */
}

%start input

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
program: %empty
{printf("Program -> epsilon\n");}
    | Function program
    {printf("Program -> Function Program\n");}
;

Function: FUNC IDENTIFIER RGTPAREN Parameters LFTPAREN LEFTCURLY FuncBody RIGHTCURLY
{printf("Function -> FUNC IDENTIFIER RGTPAREN Parameters LFTPAREN LEFTCURLY FuncBody RIGHTCURLY\n");}
;

Parameter: IDENTIFIER COMMA INTEGER
{printf("Parameter -> IDENTIFIER COMMA INTEGER\n");}
;

Parameters: %empty
{printf("Parameters -> epsilon\n");}
    | Parameter COMMA Parameters
    {printf("Parameters -> Parameter COMMA Parameters");}
;



%%
