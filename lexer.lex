%{
#include <stdio.h>
}%

DIGIT [0-9]
ALPHA [a-zA-Z]
COMMENT //.*\n

%%
{DIGIT}+ {printf("NUMBER: %s\n", yytext);}
{ALPHA}+ {printf("ALPHA: %s\n", yytext);}
";" {printf("SEMICOLON\n");}
"func" {printf("FUNCTION\n");}
"return" {printf("RETURN\n");}
"int" {printf("INTEGER\n");}
"clog" {printf("PRINT\n");}
"cfetch" {printf("READ\n");}
"while" {printf("WHILE\n");}
"if" {printf("IF\n");}
"else" {printf("ELSE\n");}
"break" {printf("BREAK\n");}
"continue" {printf("CONT\n");}
"(" {printf("LFTPAREN\n");}
")" {printf("RGTPAREN\n");}
"{" {printf("LEFTCURLY\n");}
"}" {printf("RIGHTCURLY\n");}
"[" {printf("LEFTBRACK\n");}
"]" {printf("RIGHTBRACK\n");}
"," {printf("COMMA\n");}
"+" {printf("PLUS\n");}
"-" {printf("SUBTRACT\n");}
%%



