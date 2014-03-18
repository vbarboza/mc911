%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

FILE *F;

int yylex(void);
int yyerror(const char* errmsg);
char *concat(int count, ...);

%}
 
%union{
	char *str;
	int  integer;
}

%token <str> T_WORD
%token <integer> T_INT
%token T_NEWSPAPER
%token T_TITLE
%token T_DATE
%token T_STRUCTURE
%token T_COL
%token T_SHOW
%token T_IMAGE
%token T_ABSTRACT
%token T_TEXT
%token T_AUTHOR
%token T_SOURCE
%token T_INDENT
%token T_BULLET
%token T_ENUM


%type <str> newspaper_stmt string word_list

%start stmt_list

%error-verbose
 
%%

stmt_list:
		stmt
;

stmt:
		newspaper_stmt		{printf("%s",$1);}
;

newspaper_stmt:
		T_NEWSPAPER '{'
			T_TITLE '=' string
			T_DATE '=' string
			T_STRUCTURE '{'
				T_COL '=' T_INT
			'}'
		'}'
							{
								printf("%s\n%s\n%d\n", $5, $8, $13);
                                $$ = $5;
							}
;

string: '"' word_list '"' { $$ = $2; }
;

word_list: word_list word_list {$$ = concat(2,$1,$2); }
	| T_WORD				{ $$ = $1; }
	| T_INT					{   char str[5];
								sprintf(str,"%d", $1);
								$$ = str;
								}
	|						{$$ = '\0';}
;


%%

char* concat(int count, ...)
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

int yyerror(const char* errmsg)
{
	printf("\n*** Erro: %s\n", errmsg);
}
 
int main(int argc, char** argv)
{
	yyparse();
    return 0;
}