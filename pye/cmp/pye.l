%{
	#include <string.h>

	#include "pye.tab.h"

	unsigned int current_line = 1;
	unsigned int space_level = 0;
	unsigned int tabulation_level = 0;
	unsigned int blocked_tabulation = 0;
	unsigned int amount_comment_blocks = 0;

	typedef enum{
		FALSE,
		TRUE
	}bool;
%}


letter [a-zA-z]
word {letter}+
space [ ]
tabulation \t

digit [0-9]
integer [1-9]{digit}*
identifier [a-zA-Z_][a-zA-Z0-9_]*

comment_line [#]
comment_many_lines "\"\"\""

undefined [.]+
%x COMMENT

%%

"def "				{set_tabulation(TRUE); return DEF;}
"("					{set_tabulation(TRUE); return LEFT_PARENTHESIS;}
")"					{set_tabulation(TRUE); return RIGHT_PARENTHESIS;}
":"					{set_tabulation(TRUE); return COLON;}
";"					{set_tabulation(TRUE); return SEMICOLON;}
"+"					{set_tabulation(TRUE); return PLUS;}
"-"					{set_tabulation(TRUE); return MINUS;}
"*"					{set_tabulation(TRUE); return MULTIPLY;}
"/"					{set_tabulation(TRUE); return DIVIDE;}
"="					{set_tabulation(TRUE); return EQUAL;}

{comment_line}.* {
	set_tabulation(TRUE); 
	yylval.comment_line = strdup(yytext); 
	return COMMENT_LINE;
}

{comment_many_lines} {
	BEGIN(COMMENT);
}

<COMMENT>{comment_many_lines} {
	set_tabulation(TRUE); 
	BEGIN(INITIAL);
}

<COMMENT>{undefined} {
	yylval.comment_block = strdup(yytext); 
}

"\n" {
	current_line++; 
	clean_tabulation(); 
	set_tabulation(FALSE); 
	return NEW_LINE;
}

{space} {
	if(!blocked_tabulation){
		space_level++;
	}
	else{
		//Nothing to do
	}
}

{tabulation} {
	if(!blocked_tabulation){
		tabulation_level++;
	}
	else{
		//Nothing to do
	}
}

{identifier} {
	yylval.identifier = strdup(yytext); 
	set_tabulation(TRUE); 
	return IDENTIFIER;
}

{integer} {	
	yylval.num = atoi(yytext); 
	set_tabulation(TRUE); 
	return INTEGER;
}

{undefined} {	
	ECHO;
	set_tabulation(TRUE); 
	yyerror ("unexpected character");  
}

%%

void clean_tabulation() {
	space_level = 0;
	tabulation_level = 0;

	return 0;
}

void set_tabulation(bool isBlocked) {
	
	if(isBlocked){
		blocked_tabulation = 1;
	}
	else{
		blocked_tabulation = 0;
	}
}

int yywrap(void) {
	return 1;
}
