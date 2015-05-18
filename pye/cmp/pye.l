%{
	#include <string.h>

	#include "pye.tab.h"

	unsigned int current_line = 1;
	unsigned int space_level = 0;
	unsigned int tabulation_level = 0;
	unsigned int blocked_tabulation = 0;
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
integer [1-9]{digit}*

white [ \t]+

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
"\n"			{current_line++; blocked_tabulation = 0; return NEW_LINE;}

" "				{
					if(!blocked_tabulation){
						space_level++;
					}
					else{
						//Nothing to do
					}
				}

"\t"			{
					if(!blocked_tabulation){
						tabulation_level++;
					}
					else{
						//Nothing to do
					}
				}

{identifier}	{yylval.identifier = strdup(yytext); blocked_tabulation = 0; return IDENTIFIER;}
{integer} 		{yylval.num = atoi(yytext); return INTEGER;}

. 				{ECHO; yyerror ("unexpected character");}

%%

int yywrap(void) {
	return 1;
}
