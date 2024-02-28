%{
#include <stdio.h>
#include <stdlib.h>
#include <map>
#include <string>
#include <vector>
#include <iostream>
#include <sstream>
struct CodeNode {
    std::string code = "";
    std::string result = "noResult";
    std::string name = "noName";
    std::string index = "-1";
    bool temp = false;
    bool array = false;
};
extern int yylex();
extern int lineNum;
extern int lineCol;
/*the reason I used extern int here and didn't directly define it is because it's already defined in another file */
void yyerror(const char *s);
int tempNum = 0;
std::string newTemp();
enum Type { Integer, Array };
struct Symbol {
  std::string name;
  Type type;
};

struct Function {
  std::string name;
  std::vector<Symbol> declarations;
};

std::vector <Function> symbol_table;

std::string keywords[44] = {"return", "int", "clog", "cfetch", 
"while", "if", "else", "break", 
"continue", "for", "func", "SEMICOLON", 
"LFTPAREN", "RGTPAREN", "LEFTCURLY", "RIGHTCURLY", 
"LEFTBRACK", "RIGHTBRACK", "COMMA", "PLUS", 
"MINUS", "TIMES", "DIVIDE", "MOD", 
"EQUALS", "LESS", "LESSEQL", "GREATER", 
"GREATEREQL", "EQUALITY", "NOTEQL", "RETURN", 
"INTEGER", "PRINT", "READ", "WHILE", 
"IF", "ELSE", "BREAK", "CONT", 
"FOR", "FUNCTION", "IDENTIFIER", "NUMBER"};

bool isKeyword(std::string value){
    for(int i = 0; i < 44; i++){
        std::string keyword = keywords[i];
        if(value == keyword){
            return true;
        }
    }
    return false;
}

// remember that Bison is a bottom up parser: that it parses leaf nodes first before
// parsing the parent nodes. So control flow begins at the leaf grammar nodes
// and propagates up to the parents.
Function *get_function() {
  int last = symbol_table.size()-1;
  if (last < 0) {
    printf("***Error. Attempt to call get_function with an empty symbol table\n");
    printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
    printf("calling 'find' or 'add_variable_to_symbol_table'");
    exit(1);
  }
  return &symbol_table[last];
}

// find a particular variable using the symbol table.
// grab the most recent function, and linear search to
// find the symbol you are looking for.
// you may want to extend "find" to handle different types of "Integer" vs "Array"
bool find(std::string &value, Type t) {
  Function *f = get_function();
  for(int i=0; i < f->declarations.size(); i++) {
    Symbol *s = &f->declarations[i];
    if (s->name == value && s->type == t) {
      return true;
    }
  }
  return false;
}

bool findFunction(std::string &value){
    for(int i = 0; i < symbol_table.size(); i++){
        Function *f = &symbol_table.at(i);
        if(f->name == value){
            return true;
        }
    }
    return false;
}

// when you see a function declaration inside the grammar, add
// the function name to the symbol table
void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

// when you see a symbol declaration inside the grammar, add
// the symbol name as well as some type information to the symbol table
void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->declarations.push_back(s);
}

// a function to print out the symbol table to the screen
// largely for debugging purposes.
void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].declarations.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].declarations[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

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
%type <codenode> Parameter
%type <codenode> Statements
%type <codenode> Statement
%type <codenode> Var
%type <codenode> ParamCall
%type <codenode> ParamCalls
%type <codenode> FuncCall
%type <codenode> MultExp
%type <codenode> FuncBody
%type <codenode> Term
%type <codenode> VarArray
%type <codenode> Expression
%type <codenode> func_header

%%
program: Functions
    {
        std::string func_name = "main";
        if(findFunction(func_name) == false){
            yyerror("main function not declared");
        }
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

func_header: FUNCTION IDENTIFIER
{
    std::string function_name = std::string($2);
    add_function_to_symbol_table(function_name);
    struct CodeNode *node = new CodeNode;
    node->code = std::string($2);
    $$ = node;
}

Function: func_header LFTPAREN Parameters RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *header = $1;
    node->code += std::string("func ") + header->code + std::string("\n");
    struct CodeNode *Parameters = $3;
    std::string paramString = Parameters->code;
    node->code += Parameters->code;
    int paramNum = 0;
    while(paramString.find(".") != std::string::npos){
        size_t position = paramString.find(".");
        paramString.replace(position, 1, "=");
        std::string param = ", $";
        std::stringstream stream;
        stream << paramNum;
        param += stream.str();
        // param += std::stoi(paramNum);
        paramNum += 1;
        param += std::string("\n");
        paramString.replace(paramString.find("\n", position), 1, param);
    }
    node->code += paramString;
    struct CodeNode *Statements = $6;
    node->code += Statements->code;
    node->code += std::string("endfunc\n\n");
    $$ = node;
}
;

Parameter: INTEGER IDENTIFIER
{
    struct CodeNode *node = new CodeNode;
    std::string variable_name = std::string($2);
    if(find(variable_name, Integer)){
        yyerror("Duplicate variable.");
    } else if(find(variable_name, Array)){
        yyerror("Duplicate variable.");
    } else if(isKeyword(variable_name)){
        yyerror("Variable name cannot be keyword");
    }
    node->code += std::string(". ") + std::string($2) + std::string("\n");
    $$ = node;
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
        struct CodeNode *Parameters = $1;
        struct CodeNode *Parameter = $3;
        node->code = Parameters->code + Parameter->code;
        $$ = node;
    }
    | Parameter
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *Parameter = $1;
        node->code = Parameter->code;
        $$ = node;
    }
;

FuncBody: %empty
{
    struct CodeNode *node = new CodeNode;
    $$ = node;
}
    | Statements
    {
        struct CodeNode *Statements = $1;
        struct CodeNode *node = new CodeNode;
        node->code = Statements->code;
        $$ = node;
    }
;

Statements: Statement SEMICOLON Statements
{
    struct CodeNode *statement = $1;
    struct CodeNode *statements = $3;
    struct CodeNode *node = new CodeNode;
    node->code = (statement->code) + std::string("\n") + (statements->code);
    $$ = node;
}
    | Statement SEMICOLON
    {
        struct CodeNode *statement = $1;
        struct CodeNode *node = new CodeNode;
        node->code = (statement->code) + std::string("\n");
        $$ = node;
    }
;

Statement: Var EQUALS NUMBER 
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *Var = $1;
    std::string variable_name = Var->name;
    if(Var->array == true){
        if(find(variable_name, Array) == false){
            yyerror("Variable not initialized");
        }
        if(find(variable_name, Integer)){
            yyerror("Variable is an integer type");
        }
    } else {
        if(find(variable_name, Integer) == false){
            yyerror("Variable not initialized");
        }
        if(find(variable_name, Array)){
            yyerror("Variable is an array type");
        }
    }
    if(Var->array == true){
        node->code = std::string("[]= ");
    } else {
        node->code = std::string("= ");
    }
    node->code += Var->name + std::string(", ");
    if(Var->array == true){
        node->code += Var->index + std::string(", ");
    }
    node->code += std::string($3);
    $$ = node;
}
    | INTEGER IDENTIFIER EQUALS NUMBER 
    {
        struct CodeNode *node = new CodeNode;
        std::string variable_name = std::string($2);
        if(find(variable_name, Integer)){
            yyerror("Duplicate variable.");
        } else if(find(variable_name, Array)){
            yyerror("Duplicate variable.");
        } else if(isKeyword(variable_name)){
            yyerror("Variable name cannot be keyword");
        }
        add_variable_to_symbol_table(variable_name, Integer);
        node->code = std::string(". ") + std::string($2) + std::string("\n"); 
        node->code += std::string("= ") + std::string($2) + std::string(", ") + std::string($4);
        $$ = node;
    }
    | Var EQUALS Expression
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *Var = $1;
        struct CodeNode *Expression = $3;
        std::string variable_name = Var->name;
        if(Var->array == true){
            if(find(variable_name, Array) == false){
                yyerror("Variable not initialized");
            }
            if(find(variable_name, Integer)){
                yyerror("Variable is an integer type");
            }
        } else {
            if(find(variable_name, Integer) == false){
                yyerror("Variable not initialized");
            }
            if(find(variable_name, Array)){
                yyerror("Variable is an array type");
            }
        }
        if(Expression->temp == true || Expression->array == true){
            node->code = Expression->code;
        }
        if(Var->array == true){
            node->code += std::string("[]");
        }
        node->code += std::string("= ") + Var->name + std::string(", ");
        if(Var->array == true){
            node->code += Var->index + std::string(", ");
        }
        node->code += Expression->result;
        $$ = node;
    }
    | INTEGER Var
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *Var = $2;
        std::string variable_name = Var->name;
        if(find(variable_name, Integer)){
            yyerror("Duplicate variable.");
        } else if(find(variable_name, Array)){
            yyerror("Duplicate variable.");
        } else if(isKeyword(variable_name)){
            yyerror("Variable name cannot be keyword");
        }
        node->code = std::string(".");
        if(Var->array == true){
            node->code += std::string("[]");
        }
        node->code += std::string(" ") + Var->name;
        if(Var->array == true){
            node->code += std::string(", ") + Var->index;
            std::stringstream ss;
            ss << Var->index;
            int i;
            ss >> i;
            if(i <= 0){
                yyerror("Array index cannot be less than 0");
            }
            add_variable_to_symbol_table(variable_name, Array);
        } else {
            add_variable_to_symbol_table(variable_name, Integer);
        }
        $$ = node;
    }
    | INTEGER IDENTIFIER EQUALS Expression
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *Expression = $4;
        std::string variable_name = std::string($2);
        if(find(variable_name, Integer)){
            yyerror("Duplicate variable.");
        } else if(find(variable_name, Array)){
            yyerror("Duplicate variable.");
        }
        add_variable_to_symbol_table(variable_name, Integer);
        if(Expression->array == true || Expression->temp == true){
            node->code = Expression->code;
        }
        node->code += std::string(". ") + std::string($2) + std::string("\n");
        node->code += std::string("= ") + std::string($2) + std::string(", ") + Expression->result;
        $$ = node;
    }
    | IF LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY ElseStatement
    {}
    | WHILE LFTPAREN TrueFalse RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
    {}
    | FOR LFTPAREN INTEGER IDENTIFIER EQUALS NUMBER SEMICOLON TrueFalse SEMICOLON Expression RGTPAREN LEFTCURLY FuncBody RIGHTCURLY
    {}
    | READ Var
    {}
    | PRINT Expression
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *Expression = $2;
        if(Expression->array == true || Expression->temp == true){
            node->code = Expression->code;
        }
        node->code += std::string(".> ") + Expression->result;
        $$ = node;
    }
    | CONT
    {}
    | RETURN Expression
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *Expression = $2;
        if(Expression->array == true || Expression->temp == true){
            node->code = Expression->code;
        }
        node->code += std::string("ret ") + Expression->result;
        $$ = node;
    }
    | BREAK
    {}
;

ElseStatement: %empty
{}
    | ELSE LEFTCURLY Statements RIGHTCURLY
    {}
;

FuncCall: IDENTIFIER LFTPAREN ParamCalls RGTPAREN
{
    std::string temp = newTemp();
    struct CodeNode *node = new CodeNode;
    struct CodeNode *ParamCall = $3;
    std::string func_name = std::string($1);
    if(findFunction(func_name) == false){
        yyerror("Function not defined");
    }
    node->code = ParamCall->code;
    node->code += std::string(". ") + temp + std::string("\n");
    node->code += std::string("call ") + std::string($1) + std::string(", ") + temp + std::string("\n");
    node->result = temp;
    node->temp = true;
    $$ = node;
}
;

ParamCalls: ParamCall COMMA ParamCalls
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *ParamCall = $1;
    struct CodeNode *ParamCalls = $3;
    node->code = ParamCall->code + ParamCalls->code;
    $$ = node;
}
| ParamCall
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *ParamCall = $1;
    node->code = ParamCall->code;
    $$ = node;
}
| %empty
    {
        struct CodeNode *node = new CodeNode;
        $$ = node;
    }
;

ParamCall: Expression
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *Expression = $1;
    if(Expression->temp == true || Expression->array == true){
        node->code = Expression->code;
    }
    node->code += std::string("param ") + Expression->result + std::string("\n");
    $$ = node;
}
;

Expression: MultExp
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *MultExp = $1;
    node->result = MultExp->result;
    if(MultExp->array == true || MultExp->temp == true){
        node->code = MultExp->code;
    }
    node->array = MultExp->array;
    node->temp = MultExp->temp;
    node->name = MultExp->name;
    node->index = MultExp->index;
    $$ = node;
}
    | MultExp PLUS Expression
    {
        std::string temp = newTemp();
        struct CodeNode *node = new CodeNode;
        struct CodeNode *MultExp = $1;
        struct CodeNode *Expression = $3;
        node->code = std::string(". ") + temp + std::string("\n");
        if(MultExp->array == true || Expression->array == true){
            if(MultExp->array == false){
                node->code += Expression->code;
            } else if(Expression->array == false){
                node->code += MultExp->code;
            } else {
                node->code += MultExp->code;
                node->code += Expression->code;
            }
        } if((MultExp->temp == true && MultExp->array == false) || (Expression->temp == true && Expression->array == false)){
            if(MultExp->temp == false){
                node->code += Expression->code;
            } else if(Expression->temp == false){
                node->code += MultExp->code;
            } else {
                node->code += MultExp->code;
                node->code += Expression->code;
            }
        }
        node->code += std::string("+ ") + temp + std::string(", ") + MultExp->result + std::string(", ") + Expression->result + std::string("\n");
        node->result = temp;
        node->name = temp;
        node->temp = true;
        $$ = node;
    }
    | MultExp MINUS Expression
    {
        std::string temp = newTemp();
        struct CodeNode *node = new CodeNode;
        struct CodeNode *MultExp = $1;
        struct CodeNode *Expression = $3;
        node->code = std::string(". ") + temp + std::string("\n");
        if(MultExp->array == true || Expression->array == true){
            if(MultExp->array == false){
                node->code += Expression->code;
            } else if(Expression->array == false){
                node->code += MultExp->code;
            } else {
                node->code += MultExp->code;
                node->code += Expression->code;
            }
        } if((MultExp->temp == true && MultExp->array == false) || (Expression->temp == true && Expression->array == false)){
            if(MultExp->temp == false){
                node->code += Expression->code;
            } else if(Expression->temp == false){
                node->code += MultExp->code;
            } else {
                node->code += MultExp->code;
                node->code += Expression->code;
            }
        }
        node->code += std::string("- ") + temp + std::string(", ") + MultExp->result + std::string(", ") + Expression->result + std::string("\n");
        node->result = temp;
        node->name = temp;
        node->temp = true;
        $$ = node;
    }
    | FuncCall
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *FuncCall = $1;
        node->code = FuncCall->code;
        node->result = FuncCall->result;
        node->name = FuncCall->result;
        node->temp = true;
        $$ = node;
    }
;

MultExp: Term
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *term = $1;
    node->result = term->result;
    node->code = term->code;
    node->array = term->array;
    node->temp = term->temp;
    node->name = term->name;
    node->index = term->index;
    $$ = node;
}
    | Term TIMES MultExp
    {
        std::string temp = newTemp();
        struct CodeNode *node = new CodeNode;
        struct CodeNode *term = $1;
        struct CodeNode *multexp = $3;
        node->code = std::string(". ") + temp + std::string("\n");
        if(term->array == true || multexp->array == true){
            if(term->array == false){
                node->code += multexp->code;
            } else if(multexp->array == false){
                node->code += term->code;
            } else {
                node->code += term->code;
                node->code += multexp->code;
            }
        } if((term->temp == true && term->array == false) || (multexp->temp == true && multexp->array == false)){
            if(term->temp == false){
                node->code += multexp->code;
            } else if(multexp->temp == false){
                node->code += term->code;
            } else {
                node->code += term->code;
                node->code += multexp->code;
            }
        }
        node->code += std::string("* ") + temp + std::string(", ") + term->result + std::string(", ") + multexp->result + std::string("\n");
        node->result = temp;
        node->name = temp;
        node->temp = true;
        $$ = node;
    }
    | Term DIVIDE MultExp
    {
        std::string temp = newTemp();
        struct CodeNode *node = new CodeNode;
        struct CodeNode *term = $1;
        struct CodeNode *multexp = $3;
        node->code = std::string(". ") + temp + std::string("\n");
        if(term->array == true || multexp->array == true){
            if(term->array == false){
                node->code += multexp->code;
            } else if(multexp->array == false){
                node->code += term->code;
            } else {
                node->code += term->code;
                node->code += multexp->code;
            }
        } if((term->temp == true && term->array == false) || (multexp->temp == true && multexp->array == false)){
            if(term->temp == false){
                node->code += multexp->code;
            } else if(multexp->temp == false){
                node->code += term->code;
            } else {
                node->code += term->code;
                node->code += multexp->code;
            }
        }
        node->code += std::string("/ ") + temp + std::string(", ") + term->result + std::string(", ") + multexp->result + std::string("\n");
        node->result = temp;
        node->name = temp;
        node->temp = true;
        $$ = node;
    }
    | Term MOD MultExp
    {
        std::string temp = newTemp();
        struct CodeNode *node = new CodeNode;
        struct CodeNode *term = $1;
        struct CodeNode *multexp = $3;
        node->code = std::string(". ") + temp + std::string("\n");
        if(term->array == true || multexp->array == true){
            if(term->array == false){
                node->code += multexp->code;
            } else if(multexp->array == false){
                node->code += term->code;
            } else {
                node->code += term->code;
                node->code += multexp->code;
            }
        } if((term->temp == true && term->array == false) || (multexp->temp == true && multexp->array == false)){
            if(term->temp == false){
                node->code += multexp->code;
            } else if(multexp->temp == false){
                node->code += term->code;
            } else {
                node->code += term->code;
                node->code += multexp->code;
            }
        }
        node->code += std::string("% ") + temp + std::string(", ") + term->result + std::string(", ") + multexp->result + std::string("\n");
        node->result = temp;
        node->name = temp;
        node->temp = true;
        $$ = node;
    }
;

Term: Var
{
    struct CodeNode *node = new CodeNode;
    struct CodeNode *Var = $1;
    node->code = Var->code;
    node->array = Var->array;
    node->result = Var->result;
    node->name = Var->name;
    if(Var->array == true){
        node->array = true;
        node->temp = true;
        node->index = Var->index;
    }
    $$ = node;
}
| NUMBER
    {
        struct CodeNode *node = new CodeNode;
        node->code = std::string($1);
        node->result = std::string($1);
        $$ = node;
    }
    | LFTPAREN Expression RGTPAREN
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *expression = $2;
        node->code = expression->code;
        node->result = expression->result;
        node->temp = expression->temp;
        node->name = expression->result;
        node->index = expression->index;
        $$ = node;
    }
;


Var: IDENTIFIER
{
    struct CodeNode *node = new CodeNode;
    node->code = std::string($1);
    node->result = node->code;
    node->name = std::string($1);
    $$ = node;
}
    | VarArray
    {
        struct CodeNode *node = new CodeNode;
        struct CodeNode *VarArray = $1;
        node->name = VarArray->name;
        node->index = VarArray->index;
        node->result = VarArray->result;
        node->temp = VarArray->temp;
        node->array = VarArray->array;
        node->code = VarArray->code;
        $$ = node;
    }
;

VarArray: IDENTIFIER LEFTBRACK NUMBER RIGHTBRACK
{
    std::string temp = newTemp();
    struct CodeNode *node = new CodeNode; 
    node->name = std::string($1);
    node->index = std::string($3);
    std::stringstream ss;
    ss << node->index;
    int i;
    ss >> i;
    if(i < 0){
        yyerror("Array index cannot be less than 0");
    }
    node->result = temp;
    node->code = std::string(". ") + temp + std::string("\n");
    node->code += std::string("=[] ") + temp + std::string(", ") + node->name + std::string(", ") + node->index + std::string("\n");
    node->temp = true;
    node->array = true;
    $$ = node;
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

std::string newTemp(){
    std::stringstream stream;        
    stream << tempNum;        
    std::string tempString = std::string("_temp");
    tempString += stream.str();
    tempNum += 1;
    return tempString;
}

int main(void){
    yyparse();
}

void yyerror(const char *s){
    printf("Error: %s\n", s);
}