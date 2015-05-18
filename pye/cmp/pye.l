%{
	#include <string.h>

	#include "pye.tab.h"

	unsigned int current_line = 1;
	unsigned int space_level = 0;
	unsigned int tabulation_level = 0;
	unsigned int blocked_tabulation = 0;

	typedef enum{
		FALSE,
		TRUE
	}bool;
%}


letter [a-zA-z]
word {letter}+

digit [0-9]
integer [1-9]{digit}*

identifier [a-zA-Z_][a-zA-Z0-9_]*

%%

"def "			{block_tabulation(TRUE); return DEF;}
"("				{block_tabulation(TRUE); return LEFT_PARENTHESIS;}
")"				{block_tabulation(TRUE); return RIGHT_PARENTHESIS;}
":"				{block_tabulation(TRUE); return COLON;}
";"				{block_tabulation(TRUE); return SEMICOLON;}
"+"				{block_tabulation(TRUE); return PLUS;}
"-"				{block_tabulation(TRUE); return MINUS;}
"*"				{block_tabulation(TRUE); return MULTIPLY;}
"/"				{block_tabulation(TRUE); return DIVIDE;}
"="				{block_tabulation(TRUE);  return EQUAL;}
"\n"			{printf("%d- Space: %d tabulation_level: %d\n", current_line, space_level, tabulation_level); 
					current_line++; clean_tabulation(); 
					block_tabulation(FALSE); 
					return NEW_LINE;
				}

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

{identifier}	{yylval.identifier = strdup(yytext); block_tabulation(TRUE); return IDENTIFIER;}
{integer} 		{yylval.num = atoi(yytext); block_tabulation(TRUE);  return INTEGER;}

. 				{ECHO; block_tabulation(TRUE); yyerror ("unexpected character");}

%%

void clean_tabulation(){
	space_level = 0;
	tabulation_level = 0;
}

void block_tabulation(bool isBlocked){
	
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
