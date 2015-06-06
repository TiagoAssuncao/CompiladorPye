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
	unsigned int white_enhancer_status = 0;
	unsigned int amount_block_comments = 0;

	void clean_white_level();
	void set_white_status(bool status);
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
number {digit}+"."?{digit}*

identifier [a-zA-Z_][a-zA-Z0-9_]*

double_quotes \"
single_quotes \'

string ({double_quotes}.*{double_quotes})|({single_quotes}.*{single_quotes})

space [ ]
tabulation \t
new_line \n

line_comment [#]
many_lines_comment "\"\"\""

undefined [.]+

%x COMMENT_MODE


%%

"def "			{set_white_status(BLOCKED); return DEF;}
"class "		{set_white_status(BLOCKED); return CLASS;}
"if"			{set_white_status(BLOCKED); return IF;}
"else"			{set_white_status(BLOCKED); return ELSE;}
"for"			{set_white_status(BLOCKED); return FOR;}
"while"			{set_white_status(BLOCKED); return WHILE;}
"try"			{set_white_status(BLOCKED); return TRY;}
"catch"			{set_white_status(BLOCKED); return CATCH;}
"("				{set_white_status(BLOCKED); return LEFT_PARENTHESIS;}
")"				{set_white_status(BLOCKED); return RIGHT_PARENTHESIS;}
":"				{set_white_status(BLOCKED); return COLON;}
";"				{set_white_status(BLOCKED); return SEMICOLON;}
"+"				{set_white_status(BLOCKED); return PLUS;}
"-"				{set_white_status(BLOCKED); return MINUS;}
"**"			{set_white_status(BLOCKED); return POW;}
"*"				{set_white_status(BLOCKED); return MULTIPLY;}
"/"				{set_white_status(BLOCKED); return DIVIDE;}
"="				{set_white_status(BLOCKED); return EQUAL;}



{line_comment}.* {
	set_white_status(BLOCKED); 
	yylval.line_comment = strdup(yytext); 
	return LINE_COMMENT;
}


{many_lines_comment} {
	BEGIN(COMMENT_MODE);
}


<COMMENT_MODE>{many_lines_comment} {
	set_white_status(BLOCKED); 
	BEGIN(INITIAL);
}


<COMMENT_MODE>{undefined} {
	yylval.block_comment = strdup(yytext); 
}


{new_line} {
	current_line++; 
	clean_white_level(); 
	set_white_status(NOT_BLOCKED); 
	return NEW_LINE;
}


{space} {
	if(white_enhancer_status == NOT_BLOCKED){
		space_level++;
	}
	else {
		// Nothing to do
	}
}


{tabulation} {
	if(white_enhancer_status == NOT_BLOCKED) {
		tabulation_level++;
	}
	else {
		// Nothing to do
	}
}


{identifier} {
	yylval.identifier = strdup(yytext); 
	set_white_status(BLOCKED); 
	return IDENTIFIER;
}


{number} {	
	yylval.num = atof(yytext);
	set_white_status(BLOCKED); 
	return NUMBER;
}

{string} {
	yylval.string = yytext;
	set_white_status(BLOCKED);
	return STRING;
}


{undefined} {	
	ECHO;
	set_white_status(BLOCKED); 
	yyerror ("unexpected character");  
}

%%

void clean_white_level() {
	space_level = 0;
	tabulation_level = 0;
}

void set_white_status(bool status) {
	white_enhancer_status = status;
}

int yywrap(void) {
	return 1;
}
