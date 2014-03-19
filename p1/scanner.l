%{
#include "parser.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

char* concat2(int count, ...);
%}

WORD		[a-z][a-zA-Z0-9\x80-\xf3]*
INTEGER		[0-9]+
WHITESPACE	[ \n\r\t]+
COMMENT	\/\/.*\n
INDENT	[:]+
BULLET	[\*]+[a-zA-Z0-9\x80-\xf3| \r\t|!#$%&'()*+./:;<>?@\^_`~-]*
ENUM	[\#]+[a-zA-Z0-9\x80-\xf3| \r\t|!#$%&'()*+./:;<>?@\^_`~-]*
ANY_CHAR .
URL		[./:]*[a-zA-Z0-9][a-zA-Z0-9:/.]+
PUNCTUATION	[!#$%&'()*+./:;<>?@\^_`~-]|\"
INTITLE		===[a-zA-Z0-9\x80-\xf3| \r\t|!#$%&'()*+./:;<>?@\^_`~-]*===



%option case-insensitive
%option debug

%%


{WHITESPACE} /* ignore */

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

"\\\""		{return '"';} 
"\""		{return '"';}
"{"			{return '{';}
"}"			{return '}';}
"["			{return '[';}
"]"			{return ']';}
"|"			{return '|';}
","			{return ',';}

{INTITLE} 	{ 	char *buff = (char *) strdup(yytext);
				buff = &buff[3];
				int len = strlen(buff);
				buff[len-3] = '\0';
				yylval.str = concat2(3,"<h4>",buff,"</h4>"); return T_WORD; }
				
{INDENT}	{	int i = strlen(yytext);
				char *buff = "<br>";
				for(int count=0;count<i;count++)
					buff = concat2(2,buff,"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
				yylval.str = buff;
				return T_WORD;}
{BULLET}	{yylval.str = (char *) strdup(yytext); return T_BULLET;}
{ENUM}		{yylval.str = (char *) strdup(yytext); return T_ENUM;}

"'''"		{yylval.str = "<b>"; return T_WORD; }
"''"		{yylval.str = "<i>"; return T_WORD; }
"="			{return '=';}


{INTEGER} {	
	yylval.integer = atoi(yytext);
	return T_INT;
}

{URL} {
	yylval.str = (char *) strdup(yytext);
	return T_WORD;
}

{COMMENT}  	/* ignore */;

{PUNCTUATION}	{
	yylval.str = (char *) strdup(yytext);
	return T_PUNCTUATION;
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

char* concat2(int count, ...)
{
    va_list ap;
    int len = 1, i;

    va_start(ap, count);
    for(i=0 ; i<count ; i++)
        len += strlen(va_arg(ap, char*));
    va_end(ap);

    char *result = (char*) calloc(sizeof(char),len);
    int pos = 0;

    // Actually concatenate strings
    va_start(ap, count);
    for(i=0 ; i<count ; i++)
    {
        char *s = va_arg(ap, char*);
        strcpy(result+pos, s);
        pos += strlen(s);
    }
    va_end(ap);

    return result;
}

