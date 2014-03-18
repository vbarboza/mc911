%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#define MAX_NEWS 10

FILE *F;

int yylex(void);
int yyerror(const char* errmsg);
char *concat(int count, ...);
char **get_items(char *str);
char* makenews(char *elem, int col, char *list);

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


%type <str> newspaper_stmt string word_list word item_list news_list news elements element

%start newspaper_stmt

%error-verbose
 
%%

newspaper_stmt:
		T_NEWSPAPER '{'
			T_TITLE '=' string
			T_DATE '=' string
			T_STRUCTURE '{'
				T_COL '=' T_INT
				T_SHOW '=' item_list
			'}'
			news_list
		'}'
							{
								printf("%s\n%s\n%d\n", $5, $8, $13);
								char **itemlist = get_items($16);
								
								char *str = itemlist[0];
								int pos = 1;
								while(str) {
									printf("%s\n",str);
									str = itemlist[pos];
									pos++;
								}
								
                                $$ = $5;
							}
;

news_list: news_list news	{	char str[] = ";";
								$$ = concat(3, $1, str, $2); }
		| news				{	$$ = $1; }
;

news:	T_WORD '{'
			elements
			T_STRUCTURE '{' 
				T_COL '=' T_INT
				T_SHOW '='item_list
			'}'
		'}'					{ $$ = makenews($3, $8, $11); }
;

elements: elements element	{	char str[] = ";";
								$$ = concat(3, $1, str, $2); }
		| element			{$$ = $1; }
;

element: T_TITLE '=' string 	{ $$ = concat(2, "TITLE:", $3); }
		| T_ABSTRACT '=' string { $$ = concat(2, "ABSTRACT:", $3); }
		| T_AUTHOR '=' string	{ $$ = concat(2, "AUTHOR:", $3); }
		| T_DATE '=' string		{ $$ = concat(2, "DATE:", $3); }
		| T_IMAGE '=' string	{ $$ = concat(2, "IMAGE:", $3); }
		| T_SOURCE '=' string	{ $$ = concat(2, "SOURCE:", $3); }
		| T_TEXT '='string		{ $$ = concat(2, "TEXT:", $3); }
;


item_list: item_list ',' T_WORD	{	char str[] = ";";
									$$ = concat(3, $1,str, $3); }
		| T_WORD				{$$ = $1; }
;

string: '"' word_list '"' { $$ = $2; }
;

word_list: word_list word { char str[] = " ";
								 $$ = concat(3,$1,str,$2); }
	| word				  { $$ = $1; }
;

word: T_WORD				{   $$ = $1; }
	| T_INT					{   char str[5];
								str[0] = '\0';
								sprintf(str,"%d", $1);
								$$ = str;
								}
;


%%

char* makenews(char *elem, int col, char *list) {
	return "teste: noticia!";
	}

char **get_items(char *str) {
	char **list = (char **)malloc(MAX_NEWS*sizeof(char *));
	
	char *pch = strtok(str,";");
	list[0] = pch;
	
	int pos = 1;

	while(pch) {
		pch = strtok(NULL,";");
		list[pos]=pch;
		pos++;
	}
	return list;	
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
	return 0;
}
 
int main(int argc, char** argv)
{
	yyparse();
    return 0;
}