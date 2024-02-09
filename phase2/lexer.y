%{
#include <stdio.h>
#include <stdlib.h>
extern int yylex();
extern int lineNum;
extern int lineCol;
/*the reason I used extern int here and didn't directly define it is because it's already defined in another file */
void yyerror(const char *s);
%} 

%union {
 char *id;
 float num;
/* char *identoralpha; "wasn't sure about this type so left it in a comment for now */
}

%start program

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


%left PLUS
%left MINUS 
%left TIMES
%left DIVIDE
%left MOD
%left LFTPAREN
%left RGTPAREN
%left EQUALS
%left LESS
%left LESSEQL
%left GREATER
%left GREATEREQL
%left EQUALITY
%left NOTEQL


%%
program: Functions
    {printf("program -> Functions\n");}
;

Functions: Function Functions
    {printf("Functions -> Function Functions\n");}
    | %empty
    {printf("Functions -> epsilon\n");}
;

Function: FUNCTION IDENTIFIER LFTPAREN Parameters RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
{printf("Function -> FUNCTION IDENTIFIER LFTPAREN Parameters RGTPAREN LEFTCURLY FuncBody RIGHTCURLY\n");}
;

Parameter: INTEGER IDENTIFIER
{printf("Parameter -> INTEGER IDENTIFIER\n");}
;

Parameters: %empty
{printf("Parameters -> epsilon\n");}
    | Parameters COMMA Parameter
    {printf("Parameters -> Parameter COMMA Parameters\n");}
    | Parameter
    {printf("Parameters -> Parameter\n");}
;

FuncBody: %empty
{printf("FuncBody -> epsilon\n");}
    | Statements
    {printf("FuncBody -> Statements\n");}
;

Statements: Statement SEMICOLON Statements
{printf("Statements -> Statement SEMICOLON Statements\n");}
    | Statement SEMICOLON
    {printf("Statements -> Statement SEMICOLON\n");}
;

Statement: Var EQUALS Expression
{printf("Statement -> Var EQUALS Expression\n");}
    | INTEGER Var
    {printf("Statement -> INTEGER Var\n");}
    | INTEGER Var EQUALS Expression
    {printf("Statement -> INTEGER Var EQUALS Expression");}
    | IF LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY ElseStatement
    {printf("Statement -> IF LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY ElseStatement\n");}
    | WHILE LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
    {printf("Statement -> WHILE LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY\n");}
    | FOR LFTPAREN INTEGER IDENTIFIER EQUALS NUMBER SEMICOLON TrueFalse SEMICOLON Expression RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
    {printf("Statement -> FOR LFTPAREN INTEGER IDENTIFIER EQUALS NUMBER SEMICOLON TrueFalse SEMICOLON Expression RGTPAREN LEFTCURLY FuncBody RIGHTCURLY\n");}
    | READ Vars
    {printf("Statement -> READ Vars\n");}
    | PRINT Vars
    {printf("Statement -> PRINT Vars\n");}
    | CONT
    {printf("Statement -> CONT\n");}
    | RETURN Expression
    {printf("Statement -> RETURN Expression\n");}
    | BREAK
    {printf("Statement -> BREAK\n");}
;

ElseStatement: %empty
{printf("ElseStatement -> epsilon\n");}
    | ELSE LEFTCURLY Statements RIGHTCURLY
    {printf("ElseStatement -> ELSE LEFTCURLY Statements RIGHTCURLY\n");}
;

Expression: MultExp
{printf("Expression -> MultExp\n");}
    | MultExp PLUS Expression
    {printf("Expression -> MultExp PLUS Expression\n");}
    | MultExp MINUS Expression
    {printf("Expression -> MultExp MINUS Expression\n");}
    | IDENTIFIER LFTPAREN Vars RGTPAREN
    {printf("Expression -> IDENTIFIER LFTPAREN Vars RGTPAREN\n");}
;

MultExp: Term
{printf("MultExp -> Term\n");}
    | Term TIMES MultExp
    {printf("MultExp -> Term TIMES MultExp\n");}
    | Term DIVIDE MultExp
    {printf("MultExp -> Term DIVIDE MultExp\n");}
    | Term MOD MultExp
    {printf("MultExp -> Term MOD MultExp\n");}
;

Term: Var
{printf("Term -> IDENTIFIER\n");}
    | MINUS Var
    {printf("Term -> MINUS Var\n");}
    | NUMBER
    {printf("Term -> NUMBER\n");}
    | MINUS NUMBER
    {printf("Term -> MINUS NUMBER\n");}
;


Var: IDENTIFIER LEFTBRACK Expression RIGHTBRACK
{printf("Var -> IDENTIFIER LEFTBRACK Expression RIGHTBRACK\n");}
    | IDENTIFIER
    {printf("Var -> IDENTIFIER\n");}
    | LFTPAREN Expression RGTPAREN
    {printf("Var -> LFTPAREN Expression RGTPAREN\n");}
;

Vars: Var
{printf("Vars -> Var\n");}
    | Var COMMA Vars
    {printf("Vars -> Var COMMA Vars\n");}
;

TrueFalse: Var EQUALITY Var
{printf("TrueFalse -> RELATION\n");}
    | Var NOTEQL Var
    {printf("TrueFalse -> Var NOTEQL Var\n");}
    | Var LESS Var
    {printf("TrueFalse -> Var LESS Var\n");}
    | Var LESSEQL Var
    {printf("TrueFalse -> Var LESSEQL Var\n");}
    | Var GREATER Var
    {printf("TrueFalse -> Var GREATER Var\n");}
    | Var GREATEREQL Var
    {printf("TrueFalse -> Var GREATER EQL Var\n");}
; 


%%

int main(void){
    yyparse();
}

void yyerror(const char *s){
    printf("Error: %s\n", s);
}
