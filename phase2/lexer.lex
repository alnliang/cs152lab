%{
#include "y.tab.h"
#include <stdio.h>
int lineNum = 1;
int lineCol = 0;
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
COMMENT $.*\n
WHITESPACE [ \t]
NEWLINE [\n]
IDENTIFIER {ALPHA}+(({ALPHA}|{DIGIT})*"_")*({ALPHA}|{DIGIT})+
INVALID_START ({DIGIT}|"_")+({ALPHA}|{IDENTIFIER})
INVALID_UNDERSCORE {IDENTIFIER}"_"+

%%
";" {return SEMICOLON; ++lineCol;}
"(" {return LFTPAREN; ++lineCol;}
")" {return RGTPAREN; ++lineCol;}
"{" {return LEFTCURLY; ++lineCol;}
"}" {return RIGHTCURLY; ++lineCol;}
"[" {return LEFTBRACK; ++lineCol;}
"]" {return RIGHTBRACK; ++lineCol;}
"," {return COMMA; ++lineCol;}
"+" {return PLUS; ++lineCol;}
"-" {return MINUS; ++lineCol;}
"*" {return TIMES; ++lineCol;}
"/" {return DIVIDE; ++lineCol;}
"%" {return MOD; ++lineCol;} 
"=" {return EQUALS; ++lineCol;}
"<" {return LESS; ++lineCol;}
"<=" {return LESSEQL; ++lineCol; ++lineCol;}
">" {return GREATER; ++lineCol;}
">=" {return GREATEREQL; ++lineCol; ++lineCol;}
"==" {return EQUALITY; ++lineCol; ++lineCol;}
"!=" {return NOTEQL; ++lineCol; ++lineCol;}
"return" {return RETURN; lineCol += 6;}
"int" {return INTEGER; lineCol += 3;}
"clog" {return PRINT; lineCol += 4;}
"cfetch" {return READ; lineCol += 6;}
"while" {return WHILE; lineCol += 5;}
"if" {return IF; lineCol += 2;}
"else" {return ELSE; lineCol += 4;}
"break" {return BREAK; lineCol += 5;}
"continue" {return CONT; lineCol += 8;}
"for" {return FOR; lineCol += 3;}
"func" {return FUNCTION; lineCol += 4;}
{IDENTIFIER} {return IDENTIFIER; lineCol += yyleng;}
{DIGIT}+ {return NUMBER; lineCol += yyleng;}
{ALPHA}+ {printf("ALPHA: %s\n", yytext); lineCol += yyleng;}
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

int yyparse();

main()
	{
	yylex();
	printf("Finished");
	}

