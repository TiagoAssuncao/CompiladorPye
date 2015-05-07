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
	linked_list *variable_table = new_linked_list(sizeof(variable_data));

	variable_data variable = build_variable_data("foo", "main", TRUE, 12);
	variable_table = insert_element(variable_table, (void *) &variable);

	printf("identifier: %s\n", variable.identifier);
	printf("scope: %s\n", variable.function_scope);
	printf("declared: %d\n", variable.is_declared);
	printf("line: %u\n", variable.declaration_line);

	//linked_list error_table = new_symbol_table(sizeof(error_data)); <--- Only ideas...
	//linked_list scope_table = new_symbol_table(sizeof(scope_data)); <--- Only ideas...


	yyin = fopen(argv[1], "r");
	yyparse();	

	return 0;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
} 
