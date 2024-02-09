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


%%
program: %empty
{printf("Program -> epsilon\n");}
    | Function program
    {printf("Program -> Function Program\n");}
;

Function: FUNCTION IDENTIFIER RGTPAREN Parameters LFTPAREN LEFTCURLY FuncBody RIGHTCURLY
{printf("Function -> FUNC IDENTIFIER RGTPAREN Parameters LFTPAREN LEFTCURLY FuncBody RIGHTCURLY\n");}
;

Parameter: INTEGER IDENTIFIER
{printf("Parameter -> INTEGER IDENTIFIER\n");}
;

Parameters: %empty
{printf("Parameters -> epsilon\n");}
    | Parameter COMMA Parameters
    {printf("Parameters -> Parameter COMMA Parametersn");}
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
{printf("Statement -> Var EQUALS Expression");}
    | IF RGTPAREN TrueFalse LFTPAREN RIGHTCURLY FuncBody LEFTCURLY
    {printf("Statement -> IF RGTPAREN TrueFalse LFTPAREN RIGHTCURLY FuncBody LEFTCURLY\n");}
    | WHILE RGTPAREN TrueFalse LFTPAREN RIGHTCURLY FuncBody LEFTCURLY
    {printf("Statement -> WHILE RGTPAREN TrueFalse LFTPAREN RIGHTCURLY FuncBody LEFTCURLY\n");}
    | FOR RGTPAREN INTEGER IDENTIFIER EQUALS NUMBER SEMICOLON TrueFalse SEMICOLON Expression
    {printf("Statement -> FOR RGTPAREN INTEGER IDENTIFIER EQUALS NUMBER SEMICOLON TrueFalse SEMICOLON Expression\n");}
    | READ Vars
    {printf("Statement -> READ Vars\n");}
    | PRINT Vars
    {printf("Statement -> PRINT Vars\n");}
    | CONT
    {printf("Statement -> CONT\n");}
    | RETURN Expression
    {printf("Statement -> RETURN Expression\n");}
;

ElseStatement: %empty
{printf("ElseStatement -> epsilon\n");}
    | ELSE RIGHTCURLY Statements LEFTCURLY
    {printf("ElseStatement -> ELSE RIGHTCURLY Statements LEFTCURLY\n");}
;

Expression: MultExp
{printf("Expression -> MultExp");}
    | MultExp PLUS Expression
    {printf("Expression -> MultExp PLUS Expression\n");}
    | MultExp MINUS Expression
    {printf("Expression -> MultExp MINUS Expression\n");}
;

Expressions: %empty
{printf("Expressions -> epsilon\n");}
    | Expression COMMA Expressions
    {printf("Expressions -> Expression COMMA Expressions\n");}
    | Expression
    {printf("Expression -> Expression\n");}
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
    | LFTPAREN Expression RGTPAREN
    {printf("Term -> LFTPAREN Expression RGTPAREN\n");}
;


Var: IDENTIFIER LEFTBRACK Expression RIGHTBRACK
{printf("Var -> IDENTIFIER LEFTBRACK Expression RIGHTBRACK\n");}
    | IDENTIFIER
    {printf("Var -> IDENTIFIER\n");}
;

Vars: Var
{printf("Vars -> Var\n");}
     Var COMMA Vars
    {printf("Vars -> Var COMMA Vars\n");}
;

TrueFalse: Var EQUALITY Var
{printf("TrueFalse -> RELATION\n");}
; 


%%


void yyerror(const char *s){
    printf("Error: %s\n", s);
}
