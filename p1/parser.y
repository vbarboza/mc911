%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

#define MAX_NEWS 10

#define NEWS_TITLE	0
#define NEWS_ABS 	1
#define NEWS_AUTHOR 2
#define NEWS_DATE 	3
#define NEWS_IMAGE 	4
#define NEWS_SOURCE 5
#define NEWS_TEXT 	6

static int col = 3;
static int cc  = 0;

static struct {
	char 	*element[7];
	int		show[7];
	int 	col;
} news;

FILE *F;

int yylex(void);
int yyerror(const char* errmsg);
char *concat(int count, ...);
char **get_items(char *str);
char* html_begin();
char* meta(char *title);
char* header(char *title, char *date);
char* news_begin();
char* news_title(char *title);
char* news_paragraph(char *paragraph);
char* news_image(char *image);
char* news_end();
char* html_end();
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
%token <str>T_INDENT
%token <str>T_BULLET
%token <str>T_ENUM

%token <str> T_PUNCTUATION

%type <str> newspaper_stmt string word_list word item_list news_list news elem_list elem

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
								col = $13;

								F = fopen("newspaper.html","w");

								printf("%s\n%s\n%d\n", $5, $8, $13);

								char **itemlist = get_items($16);
								//imprime cabecalho
								char *str = itemlist[0];
								int pos = 1;
								while(str) {
									printf("%s\n",str);
									str = itemlist[pos];
									pos++;
								}
								
                                fprintf(F, "%s", concat(5,
                                						html_begin(),
                                						meta($5),
                                						header($5, $8),
                                						$18,
                                						html_end())
                                		);

                                fclose(F);

							}
;

news_list:news_list news	{	$$ = concat(3, $1, "\n", $2);}
		| news				{	$$ = $1; }
;

news:	T_WORD '{'
			elements
			T_STRUCTURE '{' 
				T_COL '=' T_INT
				T_SHOW '=' elem_list
			'}'
		'}'					
							{
								int i;

								news.col = 2;

								$$ = concat(4, 	news_begin(),
												news_title(news.element[NEWS_TITLE]),
												news_paragraph(news.element[NEWS_ABS]),
												news_end());
							}
;

elements: elements element
		| element
;

element:  T_ABSTRACT '=' string { news.element[NEWS_ABS] 	= $3; }
		| T_AUTHOR '=' string	{ news.element[NEWS_AUTHOR] = $3; }
		| T_DATE '=' string		{ news.element[NEWS_DATE] 	= $3; }
		| T_IMAGE '=' string	{ news.element[NEWS_IMAGE] 	= $3; }
		| T_SOURCE '=' string	{ news.element[NEWS_SOURCE] = $3; }
		| T_TEXT '='string		{ news.element[NEWS_TEXT] 	= $3; }
		| T_TITLE '=' string 	{ news.element[NEWS_TITLE] 	= $3; }
;

elem_list:elem_list ',' elem
		| elem				
;
		
elem: 	  T_ABSTRACT 			{ news.show[NEWS_ABS] 		= 1; }
		| T_AUTHOR 				{ news.show[NEWS_AUTHOR]	= 1; }
		| T_DATE 				{ news.show[NEWS_DATE] 		= 1; }
		| T_IMAGE 				{ news.show[NEWS_IMAGE] 	= 1; }
		| T_SOURCE 				{ news.show[NEWS_SOURCE]	= 1; }
		| T_TEXT 				{ news.show[NEWS_TEXT] 		= 1; }
		| T_TITLE 				{ news.show[NEWS_TITLE] 	= 1; }
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
	| '[' T_WORD '|' word_list ']'	{ 	
								$$ = concat(5,
											"<a href=\"", $2,
											"\">",$4,"</a>"); 
								}
	| '[' T_WORD ']'	{ 	
								$$ = concat(5,
											"<a href=\"", $2,
											"\">",$2,"</a>"); 
								}
	| '[' '[' T_WORD '|' word_list ']' ']' {
								$$ = concat(5,
											"<img src=\"", $3,
											"\" alt=\"", $5, "\">");
								}
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
	| T_BULLET				{	
								static int lvl=0;
								//conta numero de '*'
								int i=1; int clvl = 0;
								char *str;
								while($1[i] == '*' ) {clvl++;i++;}
								if(clvl > lvl) {
									str = concat(2,"<ul> <li>",&$1[i]);
									lvl++;
								}
								else if(clvl < lvl) {
									str = concat(2, "</ul><li>", &$1[i]);
									lvl--;
								}
								else str = concat(2,"<li>",&$1[i]);
								
								if(yychar != T_BULLET) {
									str = concat(2, str, "</ul>");
									lvl--;
								}
								$$ = str;  
							}
	| T_ENUM				{	
								static int lvl=0;
								//conta numero de '*'
								int i=1; int clvl = 0;
								char *str;
								while($1[i] == '*' ) {clvl++;i++;}
								if(clvl > lvl) {
									str = concat(2,"<ol> <li>",&$1[i]);
									lvl++;
								}
								else if(clvl < lvl) {
									str = concat(2, "</ol><li>", &$1[i]);
									lvl--;
								}
								else str = concat(2,"<li>",&$1[i]);
								
								if(yychar != T_BULLET) {
									str = concat(2, str, "</ol>");
									lvl--;
								}
								$$ = str;  
							}
;



%%

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

char* html_head(char *title) {
	char *before =	"<!DOCTYPE html>"
					"<html lang=\"en\">"
  					"<head>"
    				"<meta charset=\"utf-8\">"
    				"<title>";
	char *after = 	"</title>"
    				"<link href=\"bootstrap.css\" rel=\"stylesheet\">"
  					"</head>";
  	return concat(3, before, title, after);
}

char* html_begin() {
	return			"<!DOCTYPE html>\n"
					"<html lang=\"pt-br\">\n";
}

char* meta(char *title) {
  	char *before =	"<head>\n"
    				"<meta charset=\"utf-8\">\n"
    				"<title>\n";
	char *after = 	"</title>\n"
    				"<link href=\"bootstrap.css\" rel=\"stylesheet\">\n"
  					"</head>\n";
  	return concat(3, before, title, after);
}

char* header(char *title, char *date) {
  	char *bef_title =	"<body>\n"
    					"<div class=\"container\">\n"
      					"<h1 class=\"text-center\">";

    char *bef_date =	"</h1>\n"
    					"<h4 class=\"text-center\">";

    char *after_date = 	"</h4>\n";

    return concat(5, bef_title, title, bef_date, date, after_date);
}

char* html_end() {
	return			"</div>\n"
					"</body>\n"
					"</html>\n";
}

char* news_begin(char *title) {
	int 	i, size;
	char  	sizbuf[8];
	char   *buffer;

	//size = news.col/col*12;
	size = 4;

	if (cc == 0) {
		buffer = "<div class=\"row\">";
	}
	else if (cc + size > 12) {
		buffer = 	"</div>\n"
					"<div class=\"row\">";
		cc = 0;
	}
	else {
		buffer = "";
	}
	cc += size;

	sprintf(sizbuf, "%d", size);

	buffer = concat(4, 	buffer,
						"<div class=\"span",
						sizbuf,
						"\">\n");

	return buffer;
 }

char* news_title(char *title) {	
	return concat(3,	"<h3>",
						title,
						"</h3>\n");
}

char* news_paragraph(char *paragraph) {	
	return concat(3,	"<p>",
						paragraph,
						"</p>\n");
}

char* news_image(char *image) {	
	return concat(3,	"<img src=\"",
						image,
						"\" />\n");
}

char* news_end() {
	return "</div>";
}