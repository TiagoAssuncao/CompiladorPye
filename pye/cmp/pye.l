%{
	#include <string.h>

	#include "pye.tab.h"

	unsigned int current_line = 1;
	unsigned int tabulation_level = 1;
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
integer [1-9]{digit}*

identifier [a-zA-Z_][a-zA-Z0-9_]*

white [ ]

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
"\t"			{tabulation_level++; return TABULATION;}
"\n"			{current_line++; return NEW_LINE;}

{identifier}	{yylval.identifier = strdup(yytext); return IDENTIFIER;}
{integer} 		{yylval.num = atoi(yytext); return INTEGER;}
{white}			{;}

. 				{ECHO; yyerror ("unexpected character");}

%%

int yywrap(void) {
	return 1;
}
