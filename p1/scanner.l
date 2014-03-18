%{
#include "parser.h"
#include <stdlib.h>
%}

WORD		[a-z][a-zA-Z0-9\x80-\xf3]*
INTEGER		[0-9]+
WHITESPACE	[ \n\r\t]+
COMMENT	\n\/\/.*\n
INDENT	\n[\:]+
BULLET	\n[\*]+
ENUM	\n[\#]+
ANY_CHAR .
PUNCTUATION	[!#$%&'()*+./:;<>?@\^_`~-]

%option case-insensitive
%option debug

%%

{WHITESPACE} /* ignore */
{COMMENT}  	/* ignore */;
"newspaper"	{return T_NEWSPAPER;}
"title" 	{return T_TITLE; }
"date"		{return T_DATE;}
"structure"	{return T_STRUCTURE;}
"col"		{return T_COL;}
"show"		{return T_SHOW;}
"image"		{return T_IMAGE;}
"abstract"	{return T_ABSTRACT;}
"text"		{return T_TEXT;} 
"author" 	{return T_AUTHOR;}
"source"	{return T_SOURCE;}
"="			{return '=';}
"\""		{return '"';}
"{"			{return '{';}
"}"			{return '}';}
"["			{return '[';}
"]"			{return ']';}
"|"			{return '|';}
","			{return ',';}
{INDENT}	{return T_INDENT;}
{BULLET}	{return T_BULLET;}
{ENUM}		{return T_ENUM;}

{PUNCTUATION}	{
	yylval.str = (char *) strdup(yytext);
	return T_PUNCTUATION;
}

{INTEGER} {	
	yylval.integer = atoi(yytext);
	return T_INT;
}

{WORD} {	
	yylval.str = (char *) strdup(yytext);
	return T_WORD;
}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}

%%

int yywrap(void) {
    return 1;
}