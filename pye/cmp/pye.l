%{
	#include "pye.tab.h"
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
number [1-9]{digit}*

variable ({letter} | _) ({word} | {number} | _)*

function .

block . 
white [ \t\n]*

%%

"print" 		{return print;}
[a-zA-Z]		{yylval.id = yytext[0]; return identifier;}
[0-9]+ 			{yylval.num = atoi(yytext); return number;}
[ \t] 			;
"\n"			{return new_line;}
[-+=;] 			{return yytext[0];}
white			{return white_characters;}
. 				{ECHO; yyerror ("unexpected character");}

%%


int yywrap (void) {
	return 1;
}
