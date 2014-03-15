%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

char *concat(int count, ...);

%}
 
%union{
	char *str;
	int  *intval;
}

%token <str> ID
%token T_newspaper
%token T_title
%token T_date
%token T_abstract
%token T_text
%token T_source
%token T_image
%token T_author
%token T_structure 
%token T_col
%token T_show
%token <str> T_STRING
%token T_NUM


%type <str> title date structure itemList

%start newspaper

%error-verbose

%%

newspaper:  T_newspaper '{' title date structure itemList '}'
;

title: T_title '=' T_STRING
;

date: T_date '=' T_STRING
;

structure: T_structure '{' T_col '=' T_NUM T_show '=' ID '}'
		

itemList:	itemList item
	|	item

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
 
int yywrap(void) { return 1; }
 
int main(int argc, char** argv)
{
     yyparse();
     return 0;
}


