%{
#include "global"
#include <stdio.h>
#include <stdlib.h>
%}

%token SPACE
%token TAB
%token MESSAGE

%start Input

%%
Input:
	/*Empty*/
	| {printf("Resultado %s\n", $$);}
	;

%%
int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
