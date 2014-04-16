%{
#include "parser.h" 
%}

STRING [a-z][a-zA-Z0-9]*
DIGIT  [0-9]+
ANY_CHAR .

%%

{STRING}	{
			yylval.str = (char*) strdup(yytext);	
			return T_STRING;
		}

{DIGIT}	{
			yylval.intval = (int) yytext;
			return T_DIGIT;
		}

";"		{return ';';}
"="		{return '=';}		
"+"		{return '+';}		

{ANY_CHAR} {
	printf("Caracter %c (ASCII %d) inesperado.\n", yytext[0], yytext[0]);
}
	
%%

// Codigo C


