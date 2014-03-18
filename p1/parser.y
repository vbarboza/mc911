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
char* makenews(char *elem, char *list);

%}
 
%union{
	char *str;
	int  integer;
}

%token <str> T_WORD
%token <integer> T_INT
%token <str>T_NEWSPAPER
%token <str>T_TITLE
%token <str>T_DATE
%token <str>T_STRUCTURE
%token <str>T_COL
%token <str>T_SHOW
%token <str>T_IMAGE
%token <str>T_ABSTRACT
%token <str>T_TEXT
%token <str>T_AUTHOR
%token <str>T_SOURCE
%token T_INDENT
%token T_BULLET
%token T_ENUM

%token <str> T_PUNCTUATION

%type <str> newspaper_stmt string word_list word item_list news_list news elements element elem_list elem

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
								printf("%s\n%s\n", $5, $8);
								char **itemlist = get_items($16);
								//imprime cabecalho
								char *str = itemlist[0];
								int pos = 1;
								while(str) {
									printf("%s\n",str);
									str = itemlist[pos];
									pos++;
								}
								
								//imprime noticias
								
							}
;

news_list:news_list news	{	$$ = concat(3, $1, ";", $2); }
		| news				{	$$ = $1; }
;

news:	T_WORD '{'
			elements
			T_STRUCTURE '{' 
				T_COL '=' T_INT
				T_SHOW '=' elem_list
			'}'
		'}'					{	$$ = makenews($3, $11); }
;

elements: elements element	{	char str[] = ";";
								$$ = concat(3, $1, str, $2); }
		| element			{	$$ = $1; }
;

element:  T_ABSTRACT '=' string { $$ = concat(2, "ABSTRACT:", $3); }
		| T_AUTHOR '=' string	{ $$ = concat(2, "AUTHOR:", $3); }
		| T_DATE '=' string		{ $$ = concat(2, "DATE:", $3); }
		| T_IMAGE '=' string	{ $$ = concat(2, "IMAGE:", $3); }
		| T_SOURCE '=' string	{ $$ = concat(2, "SOURCE:", $3); }
		| T_TEXT '='string		{ $$ = concat(2, "TEXT:", $3); }
		| T_TITLE '=' string 	{ $$ = concat(2, "TITLE:", $3); }
;

elem_list:elem_list ',' elem	{ $$ = concat(3,$1,";",$3); }
		| elem					{ $$ = $1; }
;
		
elem: 	  T_ABSTRACT 			{ $$ = "ABSTRACT"; }
		| T_AUTHOR 				{ $$ = "AUTHOR"; }
		| T_DATE 				{ $$ = "DATE"; }
		| T_IMAGE 				{ $$ = "IMAGE"; }
		| T_SOURCE 				{ $$ = "SOURCE"; }
		| T_TEXT 				{ $$ = "TEXT"; }
		| T_TITLE 				{ $$ = "TITLE"; }
;

item_list: item_list ',' T_WORD	{ char str[] = ";";
								  $$ = concat(3, $1,str, $3); }
		| T_WORD				{ $$ = $1; }
;

string: '"' word_list '"' { $$ = $2; }
;

word_list: word_list word { char str[] = " ";
							$$ = concat(3,$1,str,$2); }
	| word				  { $$ = $1; }
;

word: T_WORD				{ 	$$ = $1; }
	| T_INT					{ 	char str[5];
								str[0] = '\0';
								sprintf(str,"%d", $1);
								$$ = str;
							}
	| T_PUNCTUATION			{	$$ = $1; }
	| '='					{ 	$$ = "="; }
	| '"'					{ 	$$ = "\""; }
	| '{'					{ 	$$ = "{"; }
	| '}'					{ 	$$ = "}"; }
	| '['					{ 	$$ = "["; }
	| ']'					{ 	$$ = "]"; }
	| '|'					{ 	$$ = "|"; }
	| ','					{ 	$$ = ","; }
	| T_NEWSPAPER			{ 	$$ = $1;  }
	| T_TITLE				{ 	$$ = $1;  }
	| T_DATE				{ 	$$ = $1;  }
	| T_STRUCTURE			{ 	$$ = $1;  }
	| T_COL					{ 	$$ = $1;  }
	| T_SHOW				{ 	$$ = $1;  }
	| T_IMAGE				{ 	$$ = $1;  }
	| T_ABSTRACT			{ 	$$ = $1;  }
	| T_TEXT				{ 	$$ = $1;  }
	| T_AUTHOR				{ 	$$ = $1;  }
	| T_SOURCE				{ 	$$ = $1;  }
;


%%

char* makenews(char *elem, char *list) {
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