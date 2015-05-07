%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>

	void yyerror (char *s);
	extern FILE *yyin;

	extern unsigned int current_line;
%}


%union {int num; char *identifier;}

%start input

%token DEF
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token COLON SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE EQUAL
%token NEW_LINE

%token <num> INTEGER
%token <identifier> IDENTIFIER

%type <num> input expression term assignment


%%

input:						
	command {;}
	| input command {;}
	| function_declaration {;}
	| input function_declaration {;}
	| NEW_LINE {;}
	| input NEW_LINE {;}
	;



command:
	assignment command_finisher {;}
	| expression command_finisher {printf("Printing... %d\n", $1);}
	;



command_finisher:
	NEW_LINE {;}
	| SEMICOLON {;}
	;



assignment: 
	IDENTIFIER EQUAL expression {$$ = $3;}
	| IDENTIFIER EQUAL assignment {$$ = $3;}



expression:
	term {$$ = $1;}
	| expression PLUS term {$$ = $1 + $3;}
	| expression MINUS term {$$ = $1 - $3;}
	;



term:
	INTEGER {$$ = $1;}
	| IDENTIFIER {;}
	;
							


/* INCOMPLETE !!! */
function_declaration:
	DEF IDENTIFIER LEFT_PARENTHESIS function_declaration_args RIGHT_PARENTHESIS COLON {printf("asssooo!!! sou eu a funsao!!!\n");}
	;
/* INCOMPLETE !!! */

/* INCOMPLETE !!! */
function_declaration_args:
	;
/* INCOMPLETE !!! */

%% 

int main (int argc, char **argv) {
	yyin = fopen(argv[1], "r");

	yyparse();	

	return 0;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
} 
