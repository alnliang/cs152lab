/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    NUMBER = 258,
    IDENTIFIER = 259,
    FUNCTION = 260,
    SEMICOLON = 261,
    LEFTCURLY = 262,
    RIGHTCURLY = 263,
    LEFTBRACK = 264,
    RIGHTBRACK = 265,
    COMMA = 266,
    RETURN = 267,
    INTEGER = 268,
    PRINT = 269,
    READ = 270,
    WHILE = 271,
    IF = 272,
    ELSE = 273,
    BREAK = 274,
    CONT = 275,
    FOR = 276,
    PLUS = 277,
    MINUS = 278,
    TIMES = 279,
    DIVIDE = 280,
    MOD = 281,
    LFTPAREN = 282,
    RGTPAREN = 283,
    EQUALS = 284,
    LESS = 285,
    LESSEQL = 286,
    GREATER = 287,
    GREATEREQL = 288,
    EQUALITY = 289,
    NOTEQL = 290
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 11 "lexer.y" /* yacc.c:1909  */

 char *id;
 float num;
/* char *identoralpha; "wasn't sure about this type so left it in a comment for now */

#line 96 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
