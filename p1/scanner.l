%{
#include "parser.h"
%}

ID [a-z][a-z0-9_]*
WHITESPACE [ \n\r\t]+
ANY_CHAR .
COMMENT ["//"]+.*
STRING ["]+[a-z0-9_ ]*["]+
NUM [0-9]+

%option case-insensitive

%%

{WHITESPACE} /* ignore */ ;
"newspaper"	{return T_newspaper;}
"title"		{return T_title;}
"date"		{return T_date;}
"abstract"	{return T_abstract;}
"text"		{return T_text;}
"source"	{return T_source;}
"image"		{return T_image;}
"author"	{return T_author;}
"structure"	{return T_structure;}
"col"		{return T_col;}
"show"		{return T_show;}

"{"		{return '{';}
"}"		{return '}';}

{COMMENT} /* ignore */ ;

{ID} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}

{STRING} {	
	yylval.str = (char *) strdup(yytext);
	return T_STRING;
}

{ANY_CHAR} {
	printf ("Caracter %c (ASCII=%d) inesperado\n", yytext[0], yytext[0]);
}

{NUM} {
	return T_NUM;
	}