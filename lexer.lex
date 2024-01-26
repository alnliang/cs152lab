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
IDENTORALPHA {IDENTIFIER}|{ALPHA}
INVALID_START ({DIGIT}|"_")+({ALPHA}|{IDENTIFIER})
INVALID_UNDERSCORE {IDENTIFIER}"_"+
FUNC "func "{IDENTORALPHA}"("(" ")*")"
FUNCPARAM "func "{IDENTORALPHA}"("((" ")*"int "{IDENTORALPHA}(" ")*","(" ")+)*((" ")*"int "{IDENTORALPHA}(" ")*)")"

%%
";" {printf("SEMICOLON\n"); ++lineCol;}
"(" {printf("LFTPAREN\n"); ++lineCol;}
")" {printf("RGTPAREN\n"); ++lineCol;}
"{" {printf("LEFTCURLY\n"); ++lineCol;}
"}" {printf("RIGHTCURLY\n"); ++lineCol;}
"[" {printf("LEFTBRACK\n"); ++lineCol;}
"]" {printf("RIGHTBRACK\n"); ++lineCol;}
"," {printf("COMMA\n"); ++lineCol;}
"+" {printf("PLUS\n"); ++lineCol;}
"-" {printf("SUBTRACT\n"); ++lineCol;}
"*" {printf("MULT\n"); ++lineCol;}
"/" {printf("DIVIDE\n"); ++lineCol;}
"%" {printf("MOD\n"); ++lineCol;} 
"=" {printf("EQUALS\n"); ++lineCol;}
"<" {printf("Less\n"); ++lineCol;}
"<=" {printf("LessEql\n"); ++lineCol; ++lineCol;}
">" {printf("Greater\n"); ++lineCol;}
">=" {printf("GreaterEql\n"); ++lineCol; ++lineCol;}
"==" {printf("Equality\n"); ++lineCol; ++lineCol;}
"!=" {printf("NotEql\n"); ++lineCol; ++lineCol;}
"return" {printf("RETURN\n"); lineCol += 6;}
"int" {printf("INTEGER\n"); lineCol += 3;}
"clog" {printf("PRINT\n"); lineCol += 4;}
"cfetch" {printf("READ\n"); lineCol += 6;}
"while" {printf("WHILE\n"); lineCol += 5;}
"if" {printf("IF\n"); lineCol += 2;}
"else" {printf("ELSE\n"); lineCol += 4;}
"break" {printf("BREAK\n"); lineCol += 5;}
"continue" {printf("CONT\n"); lineCol += 8;}
"for" {printf("FOR LOOP\n"); lineCol += 3;}
{IDENTIFIER} {printf("IDENTIFIER: %s\n", yytext); lineCol += yyleng;}
{DIGIT}+ {printf("NUMBER: %s\n", yytext); lineCol += yyleng;}
{ALPHA}+ {printf("ALPHA: %s\n", yytext); lineCol += yyleng;}
{FUNC} {printf("FUNCTION"); lineCol += yyleng;}
{FUNCPARAM} {printf("FUNCTION"); lineCol += yyleng;}
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

