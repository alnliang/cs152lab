%{
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
";" {++lineCol; return SEMICOLON;}
"(" {++lineCol; return LFTPAREN;}
")" {++lineCol; return RGTPAREN}
"{" {++lineCol; return LEFTCURLY;}
"}" {++lineCol; return RIGHTCURLY;}
"[" {++lineCol; return LEFTBRACK;}
"]" {++lineCol; return RIGHTBRACK;}
"," {++lineCol; return COMMA;}
"+" {++lineCol; return PLUS;}
"-" {++lineCol; return SUBTRACT;}
"*" {++lineCol; return MULT;}
"/" {++lineCol; return DIVIDE;}
"%" {++lineCol; return MOD;} 
"=" {++lineCol; return EQUALS;}
"<" {++lineCol; return LESS;}
"<=" {++lineCol; ++lineCol; return LESSEQL;}
">" {++lineCol; return GREATER;}
">=" {++lineCol; ++lineCol; return GREATEREQL;}
"==" {++lineCol; ++lineCol; return EQUALITY;}
"!=" {++lineCol; ++lineCol; return NOTEQL;}
"return" {lineCol += 6; return RETURN;}
"int" {lineCol += 3; return INTEGER;}
"clog" {lineCol += 4; return PRINT;}
"cfetch" {lineCol += 6; return READ;}
"while" {lineCol += 5; return WHILE;}
"if" {lineCol += 2; return IF;}
"else" {lineCol += 4; return ELSE;}
"break" {lineCol += 5; return BREAK;}
"continue" {lineCol += 8; return CONT;}
"for" {lineCol += 3; return FOR;}
"func" {lineCol += 4; return FUNCTION;}
{IDENTIFIER} {lineCol += yyleng; return IDENTIFIER;}
{DIGIT}+ {lineCol += yyleng; return NUMBER;}
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

main()
	{
	yylex();
	printf("Finished");
	}

