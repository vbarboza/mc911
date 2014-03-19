%{
#include "parser.h"
#include <stdlib.h>
%}

WORD		[a-z][a-zA-Z0-9\x80-\xf3]*
INTEGER		[0-9]+
WHITESPACE	[ \n\r\t]+
COMMENT	\/\/.*\n
INDENT	\n[\:]+
BULLET	\n[\*]+[a-zA-Z0-9\x80-\xf3| \r\t|!#$%&'()*+./:;<>?@\^_`~-]*
ENUM	\n[\#]+[a-zA-Z0-9\x80-\xf3 \r\t!#$%&'()*+./:;<>?@\^_`~-]*
ANY_CHAR .
PUNCTUATION	[!#$%&'()*+./:;<>?@\^_`~-]|\"
URL		[a-zA-Z0-9:/.]+


%option case-insensitive
%option debug

%%

{WHITESPACE} /* ignore */
{COMMENT}  	/* ignore */;
"newspaper"	{yylval.str = (char *) strdup(yytext); return T_NEWSPAPER;}
"title" 	{yylval.str = (char *) strdup(yytext); return T_TITLE;}
"date"		{yylval.str = (char *) strdup(yytext); return T_DATE;}
"structure"	{yylval.str = (char *) strdup(yytext); return T_STRUCTURE;}
"col"		{yylval.str = (char *) strdup(yytext); return T_COL;}
"show"		{yylval.str = (char *) strdup(yytext); return T_SHOW;}
"image"		{yylval.str = (char *) strdup(yytext); return T_IMAGE;}
"abstract"	{yylval.str = (char *) strdup(yytext); return T_ABSTRACT;}
"text"		{yylval.str = (char *) strdup(yytext); return T_TEXT;} 
"author" 	{yylval.str = (char *) strdup(yytext); return T_AUTHOR;}
"source"	{yylval.str = (char *) strdup(yytext); return T_SOURCE;}
"="			{return '=';}
"\\\""		{return '"';} 
"\""		{return '"';}
"{"			{return '{';}
"}"			{return '}';}
"["			{return '[';}
"]"			{return ']';}
"|"			{return '|';}
","			{return ',';}
{INDENT}	{	int i = strlen(yytext)-1;
				char *str = (char *)malloc((i*6*6+1)*sizeof(char));
				int count=0;
				for(count=0;count<i;count++)
					sprintf(&str[6*count],"&nbsp;");
				yylval.str = str;
				return T_WORD;}
{BULLET}	{yylval.str = (char *) strdup(yytext); return T_BULLET;}
{ENUM}		{yylval.str = (char *) strdup(yytext); return T_ENUM;}
"'''"		{yylval.str = "<b>"; return T_WORD; }
"''"		{yylval.str = "<i>"; return T_WORD; }

{PUNCTUATION}	{
	yylval.str = (char *) strdup(yytext);
	return T_PUNCTUATION;
}

{INTEGER} {	
	yylval.integer = atoi(yytext);
	return T_INT;
}

{URL} {
	yylval.str = (char *) strdup(yytext);
	return T_WORD;
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
