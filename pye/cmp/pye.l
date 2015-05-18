%{
	#include <string.h>

	#include "pye.tab.h"

	unsigned int current_line = 1;
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
integer [1-9]{digit}*

white [ ]+

identifier [a-zA-Z_][a-zA-Z0-9_]*

%%

"def "			{return DEF;}
"("				{return LEFT_PARENTHESIS;}
")"				{return RIGHT_PARENTHESIS;}
":"				{return COLON;}
";"				{return SEMICOLON;}
"+"				{return PLUS;}
"-"				{return MINUS;}
"*"				{return MULTIPLY;}
"/"				{return DIVIDE;}
"="				{return EQUAL;}
"\n"			{current_line++; return NEW_LINE;}

{white}			{yylval.white = strdup(yytext); return WHITE;}
{identifier}	{yylval.identifier = strdup(yytext); return IDENTIFIER;}
{integer} 		{yylval.num = atoi(yytext); return INTEGER;}

. 				{ECHO; yyerror ("unexpected character");}

%%

int yywrap(void) {
	return 1;
}
