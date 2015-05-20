%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>

	#include "linked_list.h"
	#include "variable_list.h"
	#include "debugger.h"

	void yyerror (char *s);
	extern FILE *yyin;
	extern FILE *yyout;

	char current_scope[35];

	extern unsigned int current_line;
	extern unsigned int tabulation_level;
	extern unsigned int space_level;
	extern unsigned int amount_comment_blocks;
%}


%union {
	int num; 
	char *identifier; 
	char *comment_line; 
	char *comment_block;
}

%start input

%token DEF
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token COLON SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE EQUAL
%token NEW_LINE 

%token <num> INTEGER
%token <identifier> IDENTIFIER
%token <comment_line> COMMENT_LINE
%token <comment_block> COMMENT_BLOCK

%type <num> input expression term assignment


%%

input:
	command {;}
	| input command {;}
	| function_declaration {;}
	| input function_declaration {;}
	| NEW_LINE { fprintf(yyout, "\n");}
	| input NEW_LINE {fprintf(yyout, "\n");}
	| COMMENT_LINE {fprintf(yyout, "Comentatio em linha");}
	| input COMMENT_LINE {fprintf(yyout, "%s", $2);}

	;



command:
	assignment command_finisher {;}
	| expression command_finisher {;}
	;



command_finisher:
	NEW_LINE {fprintf(yyout, "\n");}
	| SEMICOLON {fprintf(yyout, ";");}
	;



assignment:
	IDENTIFIER EQUAL expression {
		apply_tabulation();
		fprintf(yyout, "# Variable identifier: %s. Value: %d\n", $1, $3);
		apply_tabulation();
		fprintf(yyout, "%s = %d", $1, $3);
		$$ = $3;
	}
	| IDENTIFIER EQUAL assignment {$$ = $3;}
	;


expression:
	term {$$ = $1;}
	| expression PLUS term {$$ = $1 + $3;}
	| expression MINUS term {$$ = $1 - $3;}
	;



term:
	INTEGER {$$ = $1;}
	| IDENTIFIER {;}
	;



function_declaration:
	DEF IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {
		apply_tabulation();
		fprintf(yyout, "# Function declaration: %s\n", $2);
		apply_tabulation();
		fprintf(yyout, "def %s():", $2);
	}
	;

/* INCOMPLETE !!!
function_declaration_args:
	;
   INCOMPLETE !!! */

%%

void apply_tabulation() {
	
	int i = 0;
	while(space_level > i) {

		fprintf(yyout, " ");
		i++;
	}

	i = 0;
	while(tabulation_level > i) {

		fprintf(yyout, "\t");
		i++;
	}
}

int main (int argc, char **argv) {


	yyout = fopen("out.py", "w");

	if(yyout == NULL) {
		printf("Error on yyout.\n");
		exit(0);
	}

	yyin = fopen(argv[1], "r");
	yyparse();

	if((amount_comment_blocks%2) != 0) {
		printf("ERRO DE BLOCO DE COMENTARIO\n");
	}
	else{
		//Nothing to do
	}

	return 0;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}

