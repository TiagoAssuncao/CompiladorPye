%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>

	#include "node.hpp"

	using namespace std;

	void yyerror (char *s);
	extern FILE *yyin;
	extern FILE *yyout;

	char current_scope[35];

	extern unsigned int current_line;
%}


%union {
	int num; 
	NIdentifier *identifier;
	NStatement *stmt;
	NExpression *expr;
}

%start input

%token DEF IF ELSE FOR WHILE TRY
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token COLON SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE EQUAL
%token NEW_LINE

%token <num> INTEGER
%token <identifier> IDENTIFIER

%type <stmt> assignment function_declaration
%type <expr> input expression term


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
	| expression command_finisher {;}
	;



command_finisher:
	NEW_LINE {;}
	| SEMICOLON {;}
	;



assignment:
	IDENTIFIER EQUAL expression {
		fprintf(yyout, "# Variable identifier: %s. Value: %d\n", $1->name, $3);
		fprintf(yyout, "%s = %d\n", $<ident>1, $3);

		/* Here we need to create a function to check whether the identifier exists or not in the table
		if(check_whether_identifier_exists($1) == TRUE) { // If it exists we just update the value in the table
			
		}
		else {*/
			//create a new identifier in the table
			NIdentifier newIdentifier = new NIdentifier($1);
		//}

		$$ = $3;
	}
	| IDENTIFIER EQUAL assignment {$$ = new NVariableDeclaration(NULL, &$<ident>1, &$3);}



expression:
	term {$$ = $1;}
	| expression PLUS term {$$ = $1 + $3;}
	| expression MINUS term {$$ = $1 - $3;}
	;



term:
	INTEGER {$$ = new NInteger (atol($1 -> c_str()));}
	| IDENTIFIER {
		;//Need to get the value of the identifier in the table here	
	  }
	;



function_declaration:
	DEF IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {
		fprintf(yyout, "# Function declaration: %s\n", $2->name);
		fprintf(yyout, "def %s():\n", $2->name);
		$$ = new NFunctionDeclaration ($2, NULL, NULL)
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
