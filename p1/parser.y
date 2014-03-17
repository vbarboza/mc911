%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

FILE *F;

char *concat(int count, ...);

%}
 
%union{
	char *str;
	int  *intval;
}

%token <str> T_STRING
%token T_INT
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

%type <str> create_stmt insert_stmt col_list  values_list  select_stmt col_list_insert

%start stmt_list

%error-verbose
 
%%

stmt_list:
		stmt_list stmt
	|	stmt 
;

stmt:
		create_stmt ';'	{printf("%s",$1);}
	|	insert_stmt ';'	{printf("%s",$1);}
	|	select_stmt ';' {printf("%s",$1);}
;

newspaper_stmt:
		T_NEWSPAPER '{'
			T_TITLE '=' T_STRING
			T_DATE '=' T_STRING
			T_STRUCTURE '{'
				T_COL '=' T_INT
			'}'
		'}'
		{
		
		}
;

col_list:
		T_STRING 		{ $$ = $1; }
	| 	col_list ',' T_STRING 	{ $$ = concat(3, $1, ";", $3); }
;


insert_stmt:
	   T_INSERT T_INTO T_STRING T_VALUES '(' values_list ')' { F = fopen($3, "a"); 
								  fprintf(F, "%s\n", $6);
								  fclose(F);
								  $$ = concat(5, "\nINSERT INTO TABLE: ", $3, "\nVALUES: ", $6, "\n\n");
							 	}
;

values_list:
		T_STRING 				{ $$ = $1; }
	| 	col_list ',' T_STRING 	{ $$ = concat(3, $1, ";", $3); }
;


col_list_insert: 
		T_STRING  			{ save_col_name($1); $$ = $1; }
	| 	col_list_insert ',' T_STRING	{ save_col_name($3); $$ = concat(3, $1, ",", $3); }
;

char* getfield(char *line, int num)
{
    char* tok;
    for (tok = strtok(line, ";");
            tok && *tok;
            tok = strtok(NULL, ";\n"))
    {
        if (!--num)
            return tok;
    }
   return NULL;
}

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
	head_list = NULL;   
	tail_list = NULL;
	yyparse();
     	return 0;
}


