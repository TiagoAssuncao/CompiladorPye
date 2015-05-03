%{
	#include "pye.tab.h"
	unsigned int current_line = 1;
%}

%option yylineno

letter [a-zA-z]
word {letter}+

digit [0-9]
integer [1-9]{digit}*

variable ({letter} | _) ({word} | {integer} | _)*

function .

block . 
white [ \t]

%%

"def"			{return DEF;}
"("				{return LEFT_PARENTHESIS;}
")"				{return RIGHT_PARENTHESIS;}
":"				{return COLON;}
[a-zA-Z]		{yylval.id = yytext[0]; return IDENTIFIER;}
{integer} 		{yylval.num = atoi(yytext); return NUMBER;}
{white}			{;}
"\n"			{current_line++; return yytext[0];}
[-+=;] 			{return yytext[0];}
. 				{ECHO; yyerror ("unexpected character");}

%%


int yywrap (void) {
	return 1;
}