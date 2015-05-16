%{
	//Lib Declaration
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
%}


%union {int num; char *identifier;}

%start input

%token DEF
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token COLON SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE EQUAL
%token TABULATION
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
	| NEW_LINE {fprintf(yyout, "\n");}
	| input NEW_LINE {fprintf(yyout, "\n");}
	| TABULATION {fprintf(yyout, "\t");}
	| input TABULATION {fprintf(yyout, "\t");}
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
		fprintf(yyout, "# Variable identifier: %s. Value: %d\n", $1, $3);
		fprintf(yyout, "%s = %d", $1, $3);
		$$ = $3;
	}
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



function_declaration:
	DEF IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {
		fprintf(yyout, "# Function declaration: %s\n", $2);
		fprintf(yyout, "def %s():", $2);
	}
	;

/* INCOMPLETE !!!
function_declaration_args:
	;
   INCOMPLETE !!! */

%%

int main (int argc, char **argv) {
	/* Testing
	list_header *variable_table = NULL;

	unsigned int size_of_element = sizeof(variable_data);
	variable_table = (list_header *) new_linked_list(size_of_element);

	variable_data variable = build_variable_data("foo", "main", TRUE, 12);
	variable_table = insert_element(variable_table, (void *) &variable);

	node *v_node = search_variable_by_identifier(variable_table, "foo");

	if(v_node != NULL) {
		variable_data *found_variable = ((variable_data *) v_node->element);

		printf("Variable identifier: %s\n", found_variable->identifier);
		printf("In what function is it present? Well, it's on %s.\n", found_variable->function_scope);
		printf("Is it declared? %d.\n", found_variable->is_declared);
		printf("In what line was this variable declared? Right there: %u.\n", found_variable->declaration_line);
	}
	else {
		printf("Variable not found!\n");
	}

	//linked_list error_table = new_symbol_table(sizeof(error_data)); <--- Only ideas...
	//linked_list scope_table = new_symbol_table(sizeof(scope_data)); <--- Only ideas...
	Testing */

	yyout = fopen("out.py", "w");

	if(yyout == NULL) {
		printf("Error on yyout.\n");
		exit(0);
	}

	yyin = fopen(argv[1], "r");
	yyparse();

	return 0;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}
