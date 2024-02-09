%{
#include <stdio.h>
#include "lexer.tab.h"
int lineNum = 1;
int lineCol = 0;
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
COMMENT $.*\n
WHITESPACE [ \t]
NEWLINE [\n]
IDENTIFIER {ALPHA}+(({ALPHA}|{DIGIT})*"_")*({ALPHA}|{DIGIT})+
IDENTORALPHA {IDENTIFIER}|{ALPHA}
INVALID_START ({DIGIT}|"_")+({ALPHA}|{IDENTIFIER})
INVALID_UNDERSCORE {IDENTIFIER}"_"+
FUNC "func "{IDENTORALPHA}"("(" ")*")"
FUNCPARAM "func "{IDENTORALPHA}"("((" ")*"int "{IDENTORALPHA}(" ")*","(" ")+)*((" ")*"int "{IDENTORALPHA}(" ")*)")"
MAINFUNC ("func ")"main("((" ")*"int "{IDENTORALPHA}(" ")*","(" ")+)*((" ")*"int "{IDENTORALPHA}(" ")*)")"
MAINFUNCNOPARAM ("func ")"main("(" ")*")"

%%
";" { return SEMICOLON; }
"(" { return LFTPAREN; }
")" { return RGTPAREN; }
"{" { return LEFTCURLY; }
"}" { return RIGHTCURLY; }
"[" { return LEFTBRACK; }
"]" { return RIGHTBRACK; }
"," { return COMMA; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"/" { return DIVIDE; }
"%" { return MOD; } 
"=" { return EQUALS; }
"<" { return LESS; }
"<=" { return LESSEQL; }
">" { return GREATER; }
">=" { return GREATEREQL; }
"==" { return EQUALITY; }
"!=" { return NOTEQL; }
"return" { return RETURN; }
"int" { return INTEGER; }
"clog" { return PRINT; }
"cfetch" { return READ; }
"while" { return WHILE; }
"if" { return IF; }
"else" { return ELSE; }
"break" { return BREAK; }
"continue" { return CONT; }
"for" { return FOR; }
{IDENTIFIER} { return IDENTIFIER; }
{DIGIT}+ { return NUMBER; }
{ALPHA}+ { return ALPHA; }
{MAINFUNC} { return MAINFUNC; }

{FUNC} { return FUNCTION; }
{COMMENT} 
{WHITESPACE}+ {lineCol += yyleng;}
{NEWLINE} {++lineNum;}
. {
  printf("Error at line %d, column %d: unrecognized symbol \"%s\" \n",
	   lineNum, lineCol, yytext);
  exit(1);
}

{INVALID_START} { 
			printf("Error at line %d, column %d: incorrect symbol \"%s\" must begin with a letter \n", lineNum, lineCol, yytext); 
			exit(1);   
}

{INVALID_UNDERSCORE}  { 
			printf("Error at line %d, column %d: incorrect symbol \"%s\" cannot end with an underscore \n", lineNum, lineCol, yytext); 
			exit(1); 
}
%%

