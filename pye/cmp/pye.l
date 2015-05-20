%{
	#include <string.h>

	#include "pye.tab.h"
	#include "bool.h"

	enum {
		NOT_BLOCKED,
		BLOCKED
	};

	unsigned int current_line = 1;
	unsigned int space_level = 0;
	unsigned int tabulation_level = 0;
	unsigned int tabulation_enhancer_status = 0;
	unsigned int amount_block_comments = 0;

	void clean_tabulation_level();
	void set_tabulation_status(bool status);
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
integer [1-9]{digit}*
identifier [a-zA-Z_][a-zA-Z0-9_]*

space [ ]
tabulation \t
new_line \n

line_comment [#]
many_lines_comment "\"\"\""

undefined [.]+

%x COMMENT_MODE


%%

"def "				{set_tabulation_status(BLOCKED); return DEF;}
"("					{set_tabulation_status(BLOCKED); return LEFT_PARENTHESIS;}
")"					{set_tabulation_status(BLOCKED); return RIGHT_PARENTHESIS;}
":"					{set_tabulation_status(BLOCKED); return COLON;}
";"					{set_tabulation_status(BLOCKED); return SEMICOLON;}
"+"					{set_tabulation_status(BLOCKED); return PLUS;}
"-"					{set_tabulation_status(BLOCKED); return MINUS;}
"*"					{set_tabulation_status(BLOCKED); return MULTIPLY;}
"/"					{set_tabulation_status(BLOCKED); return DIVIDE;}
"="					{set_tabulation_status(BLOCKED); return EQUAL;}


{line_comment}.* {
	set_tabulation_status(BLOCKED); 
	yylval.line_comment = strdup(yytext); 
	return LINE_COMMENT;
}


{many_lines_comment} {
	BEGIN(COMMENT_MODE);
}


<COMMENT_MODE>{many_lines_comment} {
	set_tabulation_status(BLOCKED); 
	BEGIN(INITIAL);
}


<COMMENT_MODE>{undefined} {
	yylval.block_comment = strdup(yytext); 
}


{new_line} {
	current_line++; 
	clean_tabulation_level(); 
	set_tabulation_status(NOT_BLOCKED); 
	return NEW_LINE;
}


{space} {
	if(tabulation_enhancer_status == NOT_BLOCKED){
		space_level++;
	}
	else {
		// Nothing to do
	}
}


{tabulation} {
	if(tabulation_enhancer_status == NOT_BLOCKED) {
		tabulation_level++;
	}
	else {
		// Nothing to do
	}
}


{identifier} {
	yylval.identifier = strdup(yytext); 
	set_tabulation_status(BLOCKED); 
	return IDENTIFIER;
}


{integer} {	
	yylval.num = atoi(yytext); 
	set_tabulation_status(BLOCKED); 
	return INTEGER;
}


{undefined} {	
	ECHO;
	set_tabulation_status(BLOCKED); 
	yyerror ("unexpected character");  
}

%%

void clean_tabulation_level() {
	space_level = 0;
	tabulation_level = 0;
}

void set_tabulation_status(bool status) {
	tabulation_enhancer_status = status;
}

int yywrap(void) {
	return 1;
}
