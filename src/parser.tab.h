/* A Bison parser, made by GNU Bison 3.7.6.  */

/* Skeleton interface for Bison GLR parsers in C

   Copyright (C) 2002-2015, 2018-2021 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

#ifndef YY_YY_PARSER_TAB_H_INCLUDED
# define YY_YY_PARSER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    A_TITULO = 258,                /* A_TITULO  */
    C_TITULO = 259,                /* C_TITULO  */
    A_DESC = 260,                  /* A_DESC  */
    C_DESC = 261,                  /* C_DESC  */
    A_CAT = 262,                   /* A_CAT  */
    C_CAT = 263,                   /* C_CAT  */
    A_DER = 264,                   /* A_DER  */
    C_DER = 265,                   /* C_DER  */
    A_ALT = 266,                   /* A_ALT  */
    C_ALT = 267,                   /* C_ALT  */
    A_ANCHO = 268,                 /* A_ANCHO  */
    C_ANCHO = 269,                 /* C_ANCHO  */
    A_LINK = 270,                  /* A_LINK  */
    C_LINK = 271,                  /* C_LINK  */
    A_URL = 272,                   /* A_URL  */
    C_URL = 273,                   /* C_URL  */
    A_CANAL = 274,                 /* A_CANAL  */
    C_CANAL = 275,                 /* C_CANAL  */
    A_ITEM = 276,                  /* A_ITEM  */
    C_ITEM = 277,                  /* C_ITEM  */
    A_IMG = 278,                   /* A_IMG  */
    C_IMG = 279,                   /* C_IMG  */
    D_RSS = 280,                   /* D_RSS  */
    C_RSS = 281,                   /* C_RSS  */
    D_XML = 282,                   /* D_XML  */
    CAD = 283,                     /* CAD  */
    ENLACE = 284,                  /* ENLACE  */
    NUM = 285                      /* NUM  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_PARSER_TAB_H_INCLUDED  */
