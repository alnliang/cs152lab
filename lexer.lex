%{
#include <stdio.h>
%}

DIGIT [0-9]
ALPHA [a-zA-Z]
COMMENT $.*\n
WHITESPACE [ \n\t]

%%
";" {printf("SEMICOLON\n");}
"(" {printf("LFTPAREN\n");}
")" {printf("RGTPAREN\n");}
"{" {printf("LEFTCURLY\n");}
"}" {printf("RIGHTCURLY\n");}
"[" {printf("LEFTBRACK\n");}
"]" {printf("RIGHTBRACK\n");}
"," {printf("COMMA\n");}
"+" {printf("PLUS\n");}
"-" {printf("SUBTRACT\n");}
"*" {printf("MULT\n");}
"/" {printf("DIVIDE\n");}
"%" {printf("MOD\n");}
"=" {printf("EQUALS\n");}
"<" {printf("Less\n");}
"<=" {printf("LessEql\n");}
">" {printf("Greater\n");}
">=" {printf("GreaterEql\n");}
"==" {printf("Equality\n");}
"!=" {printf("NotEql\n");}
"func "({ALPHA} | {DIGIT})+"("({ALPHA}+ | "," | {DIGIT}+)*")" {printf("FUNCTION\n");}
"return" {printf("RETURN\n");}
"int" {printf("INTEGER\n");}
"clog" {printf("PRINT\n");}
"cfetch" {printf("READ\n");}
"while" {printf("WHILE\n");}
"if" {printf("IF\n");}
"else" {printf("ELSE\n");}
"break" {printf("BREAK\n");}
"continue" {printf("CONT\n");}
"for" {printf("FOR LOOP\n");}
"\n"{DIGIT}+{ALPHA}+ {printf("ERROR");}
{DIGIT}+ {printf("NUMBER: %s\n", yytext);}
{ALPHA}+ {printf("ALPHA: %s\n", yytext);}
{COMMENT} 
{WHITESPACE}+ 
%%

main()
	{
	yylex();
	printf("Finished");
	}

