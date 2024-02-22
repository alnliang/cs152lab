%{
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
struct CodeNode {
    std::string code;
    std::string name;
};
extern int yylex();
extern int lineNum;
extern int lineCol;
/*the reason I used extern int here and didn't directly define it is because it's already defined in another file */
void yyerror(const char *s);
%} 

%union {
 char *id;
 float num;
 char *op_value;
/* char *identoralpha; "wasn't sure about this type so left it in a comment for now */
 struct CodeNode *codenode;
}

%start program

%token <id> NUMBER
%token <id> IDENTIFIER
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

%type <codenode> Functions
%type <codenode> Function
%type <codenode> Parameters
%type <codenode> Statements
%type <codenode> Statement
%type <codenode> Vars
%type <codenode> Var
%type <codenode> ParamCall
%type <codenode> ParamCalls

%%
program: Functions
    {
        struct CodeNode *node = $1;
        printf("%s\n", node->code.c_str()); 
    }
;

Functions: Function Functions
    {
        struct CodeNode *function = $1;
        struct CodeNode *functions = $2;
        struct CodeNode *node = new CodeNode;
        node->code = function->code + functions->code;
        $$ = node;
    }
    | %empty
    {
        struct CodeNode *node = new CodeNode;
        $$ = node;
    }
;

Function: FUNCTION IDENTIFIER LFTPAREN Parameters RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
{
    struct CodeNode *node = new CodeNode;
    node->code += std::string("func ") + std::string($2) + std::string("\n");

    node->code += std::string("endfunc\n");
    $$ = node;
}
;

Parameter: INTEGER IDENTIFIER
{
    struct CodeNode *node = new CodeNode;
    node->code += std::string(".") + std::string($2);
}
;

Parameters: %empty
{
    struct CodeNode *node = new CodeNode;
    $$ = node;
}
    | Parameters COMMA Parameter
    {
        struct CodeNode *node = new CodeNode;

    }
    | Parameter
    {}
;

FuncBody: %empty
{}
    | Statements
    {}
;

Statements: Statement SEMICOLON Statements
{
    struct CodeNode *statement = $1;
    struct CodeNode *statements = $3;
    struct CodeNode *node = new CodeNode;
    node->code = (statement->code) + std::string("\n") + (statements->code);
    node = $$;
}
    | Statement SEMICOLON
    {
        struct CodeNode *statement = $1;
        struct CodeNode *node = new CodeNode;
        node->code = (statement->code) + std::string("\n");
        node = $$;
    }
;

Statement: Var EQUALS Expression
{

}
    | VarArray EQUALS Expression
    {}
    | INTEGER VarArray
    {}
    | INTEGER Var
    {}
    | INTEGER Var EQUALS Expression
    {}
    | IF LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY ElseStatement
    {}
    | WHILE LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
    {}
    | FOR LFTPAREN INTEGER IDENTIFIER EQUALS NUMBER SEMICOLON TrueFalse SEMICOLON Expression RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
    {}
    | READ Var
    {}
    | PRINT Var
    {}
    | CONT
    {}
    | RETURN Expression
    {}
    | BREAK
    {}
;

ElseStatement: %empty
{}
    | ELSE LEFTCURLY Statements RIGHTCURLY
    {}
;

Expressions: %empty
{}
    | Expression COMMA Expressions
    {}
    | Expression
    {}

Expression: MultExp
{}
    | MultExp PLUS Expression
    {}
    | MultExp MINUS Expression
    {}
;

FuncCall: IDENTIFIER LFTPAREN ParamCall RGTPAREN
{

}
;

ParamCalls: ParamCall COMMA ParamCalls
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *ParamCall = $1;
    struct CodeNode *ParamCalls = $3;
    node->code = ParamCall->code + ParamCalls->code;
    $$ = node;
} | %empty
    {
        struct CodeNode *node = new CodeNode;
        $$ = node;
    }
;

ParamCall: Var
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *var = $1;
    node->code = std::string("param ") + var->code + std::string("\n");
    $$ = node;
}
;

MultExp: Term
{}
    | Term TIMES MultExp
    {}
    | Term DIVIDE MultExp
    {}
    | Term MOD MultExp
    {}
;

Term: Var
{}
    | MINUS Var
    {}
    | NUMBER
    {}
    | MINUS NUMBER
    {}
;


Var: IDENTIFIER
{
    struct CodeNode *node = new CodeNode;
    node->code = std::string($1);
    $$ = node;
}
    | LFTPAREN Expression RGTPAREN
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *expression = $2;
        node->code = expression->code;
        $$ = node;
    }
;

Vars: Var
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *var = $1;
    node->code = var->code;
    $$ = node;
}
    | Var COMMA Vars
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *var = $1;
        struct CodeNode *vars = $3;
        node->code
    }
;

VarArray: IDENTIFIER LEFTBRACK Var RIGHTBRACK
{
    
}
;

TrueFalse: Term EQUALITY Term
{}
    | Term NOTEQL Term
    {}
    | Term LESS Term
    {}
    | Term LESSEQL Term
    {}
    | Term GREATER Term
    {}
    | Term GREATEREQL Term
    {}
; 


%%

int main(void){
    yyparse();
}

void yyerror(const char *s){
    printf("Error: %s\n", s);
}