%{
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

#define MAX_NEWS 1024

#define NEWS_TITLE	0
#define NEWS_ABS 	1
#define NEWS_AUTHOR 2
#define NEWS_DATE 	3
#define NEWS_IMAGE 	4
#define NEWS_SOURCE 5
#define NEWS_TEXT 	6

static int col = 0;
static int cc  = 0;

static int news_or  = 1;

static int enum_cnt0= 1;
static int enum_cnt1= 1;
static int enum_cnt2= 1;
static int enum_cnt3= 1;

static struct {
	char 	*html[MAX_NEWS];
	char    *tag[MAX_NEWS];
    int      col[MAX_NEWS];
} newspaper;

static struct {
	char 	*element[7];
	int	    show[7];
} news;

static int news_c = 0;

FILE *F;

int yylex(void);
int yyerror(const char* errmsg);
char* concat(int count, ...);
char** get_items(char *str, int *nitems);
char* tolowerstr(char* string);
char* html_begin();
char* meta(char *title);
char* header(char *title, char *date);
char* news_begin(int cols);
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
							  int i, j, nitems;
							  char **items;

                              col = $13;
							  F = fopen("newspaper.html","w");

							  fprintf(F, "%s", html_begin());
							  fprintf(F, "%s", meta($5));
							  fprintf(F, "%s", header($5, $8));

							  items = get_items($16, &nitems);

							  for (i = 0; i < nitems; i++) {
							    for (j = 0; j < news_c; j++) {
							      printf("%s %s\n", items[i], newspaper.tag[j]);
							      if (!strncmp(tolowerstr(items[i]), tolowerstr(newspaper.tag[j]), 16)) {
								fprintf(F, "%s", news_begin(newspaper.col[j]));			  
								fprintf(F, "%s", newspaper.html[j]);
							      }
							    }							    
							  }
							  fprintf(F, "%s", html_end());
							  
							  fclose(F);
							  
							}
;

news_list:news_list news	{	$$ = concat(3, $1, "\n", $2);}
         | news			{	$$ = $1;}
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

								$$ = concat(3,
									    news_title(news.element[NEWS_TITLE]),
									    news_paragraph(news.element[NEWS_ABS]),
									    news_end());								
								newspaper.tag[news_c] = $1;
								newspaper.col[news_c] = $8;
								newspaper.html[news_c++] = concat(2, "", $$);

								news.show[NEWS_ABS]		= 0;
								news.show[NEWS_AUTHOR]		= 0;
								news.show[NEWS_DATE]		= 0;
								news.show[NEWS_IMAGE]		= 0;
								news.show[NEWS_SOURCE]		= 0;
								news.show[NEWS_TEXT]		= 0;
								news.show[NEWS_TITLE]		= 0;
								news_or = 1;
							}
;

elements: elements element
		| element
;

element:  T_ABSTRACT '=' string { news.element[NEWS_ABS] 	= $3; }
		| T_AUTHOR '=' string	{ news.element[NEWS_AUTHOR] = $3; }
		| T_DATE '=' string		{ news.element[NEWS_DATE] 	= $3; }
		| T_IMAGE '=' string	{ news.element[NEWS_IMAGE] 	= $3; }
		| T_SOURCE '=' string	{ enum_cnt0=1;enum_cnt1=1;enum_cnt2=1;enum_cnt3=1;
									news.element[NEWS_SOURCE] = $3; }
		| T_TEXT '='string		{ 	enum_cnt0=1;enum_cnt1=1;enum_cnt2=1;enum_cnt3=1;
									news.element[NEWS_TEXT] 	= $3;
									news.show[NEWS_TEXT] = 10;    }
		| T_TITLE '=' string 	{ news.element[NEWS_TITLE] 	= $3; }
;

elem_list:elem_list ',' elem
		| elem				
;
		
elem: 	  T_ABSTRACT 			{ news.show[NEWS_ABS] 		= news_or++; }
		| T_AUTHOR 				{ news.show[NEWS_AUTHOR]	= news_or++; }
		| T_DATE 				{ news.show[NEWS_DATE] 		= news_or++; }
		| T_IMAGE 				{ news.show[NEWS_IMAGE] 	= news_or++; }
		| T_SOURCE 				{ news.show[NEWS_SOURCE]	= news_or++; }
		| T_TEXT 				{ news.show[NEWS_TEXT] 		= news_or++; }
		| T_TITLE 				{ news.show[NEWS_TITLE] 	= news_or++; }
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
											"<br><img  style=\"float:left; padding: 8px;\" src=\"", $3,
											"\" alt=\"", $5, "\"><br>");
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
								//conta numero de '*'
								int clvl = 0;
								char *str = "<br>";
								char *recuo = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								while($1[clvl++] == '*' ) str=concat(2,str,recuo);
								str = concat(3,str,"&bull;&nbsp;",&$1[clvl-1]);
								$$ = str;  
							}
	| T_ENUM				{
								//conta numero de '#'
								int clvl = 0;
								char *str = "<br>";
								char num[4];
								char *recuo = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
								while($1[clvl] == '#' ) {
									str=concat(2,str,recuo);
									clvl++;
								}
								switch(clvl) {
									case 0: sprintf(num,"%d",enum_cnt0++); break;
									case 1: sprintf(num,"%d",enum_cnt1++); break;
									case 2: sprintf(num,"%d",enum_cnt2++); break;
									case 3: sprintf(num,"%d",enum_cnt3++); break;
								}
								str = concat(4,str,num,". &nbsp;",&$1[clvl-1]);
								$$ = str;
							}
;



%%

char** get_items(char *str, int *nitems) {
  int pos = 0;
  char *pch = strtok(str,";");
  char **list = (char **)malloc(MAX_NEWS*sizeof(char *));

  while(pch) {
    list[pos++] = pch;
    pch = strtok(NULL,";");
  }

  *nitems = pos;

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

char* news_begin(int cols) {
	int 	i, size;
	char  	sizbuf[8];
	char   *buffer;

	size = ((cols*12)/col);
	//size = 4;

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
 
 char* winbody(char *txt) {
 	
   char *buffer = "<div class=\"row\"> <div class=\"span12\">\n<p style=\"text-align:justify;\">";
 	buffer = concat(3, buffer, txt, "</p></div>\n");
 	return buffer;
 }

char* news_title(char *title) {	
	char *buff, *link;
	FILE *newFILE;
	char *filebuff;
	
	char *title2 = strdup(title);
	
	char *link1 = "<h3><a href onclick=\"window.open(&#39;";
	char *link2 = "&#39;,&#39;headline1&#39;,&#39;width=960,height=500,scrollbars=yes,screenX=400,screenY=200&#39;)\">";
	
	if(news.show[NEWS_TEXT]) {
		char *name = concat(2,strtok(title," "),".html");
		newFILE = fopen(name,"w");
		filebuff = concat(6, html_begin(),meta(title2),header(title2, ""),
                                winbody(news.element[NEWS_TEXT]),news_end(),html_end());
        fprintf(newFILE,"%s",filebuff);
        fclose(newFILE);
        link = concat(3,link1,name,link2);
		buff = concat(3,link,title2,"</a></h3>\n");
	}
	else { buff = concat(3, "<h3>",title2,"</h3>\n");} 
	
	return buff;
}

int count_elem() {
	int i, cnt=0;
	for(i=0; i<NEWS_TEXT;i++) {
		if(news.show[i]) cnt++;
	}
	return cnt;
}

char* add_abstract(char *buff) {
	return concat(4, buff,	"<p style=\"text-align:justify;\">",
						news.element[NEWS_ABS],
						"</p>\n");
}

char* add_author(char *buff) {
	return concat(4, buff,	"<br><p><b>Autor: </b>",
						news.element[NEWS_AUTHOR],
						"</p><br>\n");
}

char* add_date(char *buff) {
	return concat(4, buff,	"<br><p><b>Data: </b>",
						news.element[NEWS_DATE],
						"</p><br>\n");
}

char* add_image(char *buff) {
  return concat(4, buff, "<img style=\"float:left; padding: 8px; \" height=\"150\" src=\"",
							news.element[NEWS_IMAGE],
							"\">");
}

char* news_paragraph(char *paragraph) {
	int cur = 1;
	char *buff = "";
	int num = count_elem();
	int i;
	
	while(cur <= num) {
		i=0;
		while(news.show[i] != cur) i++;
		switch(i) {
			case NEWS_TITLE: 	break;
			case NEWS_ABS:		buff = add_abstract(buff); break;
			case NEWS_AUTHOR: 	buff = add_author(buff); break;
			case NEWS_DATE:		buff = add_date(buff); break;
			case NEWS_IMAGE: 	buff = add_image(buff); break;
			case NEWS_SOURCE:	break;
			case NEWS_TEXT:		break;		
		}
		cur++;
	}
	
	return buff;
}

char* news_image(char *image) {	
	return concat(3,	"<img  style=\"float:left; padding: 8px;\" src=\"",
						image,
						"\" />\n");
}

char* news_end() {
	return "</div>";
}

char* tolowerstr(char* str) {
  int i;
  char *buff = (char *)strdup(str);
  for(i = 0; buff[i]; i++){
    buff[i] = tolower(buff[i]);
  }
  return buff;
 }
