%{
#include "global.h"
#include <stdio.h>
#include <stdlib.h>
%}

%token SPACE
%token TAB
%token MESSAGE WARNING NOT
%token END

%start Head

%%
Head:
	{ printf("\n\n\tBem vindo ao Interpretador de variaveis\n\tAutor: Tiago Assuncao\n\tInsira uma palavra e verifique se ela está de acordo com a declaração do python:\n\n\n"); }
	Input
	;
Input:
	//Empty
	| Input Line
	;
Line:
	END
	| MESSAGE { printf("Variável Encontrada: %s\n\n", $1); }
	| WARNING { printf("A Variável deve ter mais de três caracteres\n\n"); }
	| NOT { printf("A entrada digitada não é reconhecida como uma variável\n\n"); }
	;
	

%%
int yyerror(char *s) {
   printf("%s\n",s);
}

int main(void) {
   yyparse();
}
