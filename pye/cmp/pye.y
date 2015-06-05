%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>

	#include "linked_list.h"
	#include "variable_list.h"
	#include "debugger.h"
	#include "mathematics.h"

	enum {
		FIRST,
		SECOND
	};

	const char STRUCTURE_FUNCTION[] = "function";
	const char STRUCTURE_VARIABLE[] = "variable";
	const char STRUCTURE_CLASS[] = "class";
	const char STRUCTURE_METHOD[] = "method";

	list_header *symbol_table;

	unsigned int current_step;
	unsigned int count_identifier = 0;

	// Change to stack.. 
	char CURRENT_SCOPE[35];

	void yyerror (char *s);
	void apply_tabulation();

	extern FILE *yyin;
	extern FILE *yyout;
	extern unsigned int current_line;
	extern unsigned int tabulation_level;
	extern unsigned int space_level;
	extern unsigned int amount_block_comments;
%}


%union {
	double num; 
	char *string;
	char *identifier; 
	char *line_comment; 
	char *block_comment;
}

%start input

%token DEF IF ELSE FOR WHILE TRY CATCH
%token LEFT_PARENTHESIS RIGHT_PARENTHESIS
%token COLON SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE EQUAL POW
%token NEW_LINE 

%token <num> NUMBER
%token <string> STRING 
%token <identifier> IDENTIFIER
%token <line_comment> LINE_COMMENT
%token <block_comment> BLOCK_COMMENT

%type <num> input number_expression number_term number_assignment
%type <string> string_expression string_term string_assignment


%%

input:
	command {;}
	| input command {;}
	| function_declaration {;}
	| input function_declaration {;}
	| NEW_LINE {fprintf(yyout, "\n");}
	| input NEW_LINE {fprintf(yyout, "\n");}
	| LINE_COMMENT {fprintf(yyout, "Comentatio em linha");}
	| input LINE_COMMENT {fprintf(yyout, "%s", $2);}
	;



command:
	assignment command_finisher {;}
	;



command_finisher:
	NEW_LINE {fprintf(yyout, "\n");}
	| SEMICOLON {fprintf(yyout, ";");}
	;



assignment:
	number_assignment {;}
	| string_assignment {;}
	;



number_assignment:
	IDENTIFIER EQUAL number_expression {

		char name_identifier[35];
		strcpy(name_identifier, $1);

		char scope[35];
		strcpy(scope, "Testando Escopo"); // Will come from the stack...

		char type_of_element[35];
		strcpy(type_of_element, "");

		create_new_node(name_identifier, STRUCTURE_VARIABLE, scope, type_of_element);

		apply_tabulation();
		fprintf(yyout, "# Variable identifier: %s. Value: %lf\n", $1, $3);
		apply_tabulation();
		fprintf(yyout, "%s = %lf", $1, $3);
		$$ = $3;
	}
	| IDENTIFIER EQUAL number_assignment {$$ = $3;}
	;



string_assignment:
	IDENTIFIER EQUAL string_expression {
		apply_tabulation();
		fprintf(yyout, "# Variable identifier: %s. String value: %s\n", $1, $3);
		apply_tabulation();
		fprintf(yyout, "%s = %s\n", $1, $3);
		$$ = $3;
	}
	| IDENTIFIER EQUAL string_assignment {$$ = $3;}
	;



number_expression:
	number_term {$$ = $1;}
	| number_expression PLUS number_term {$$ = $1 + $3;}
	| number_expression MINUS number_term {$$ = $1 - $3;}
	| number_expression MULTIPLY number_term {$$ = $1 * $3;}
	| number_expression DIVIDE number_term {$$ = $1 / $3;}
	| number_expression POW number_term {$$ = fast_exponentiation($1, $3);}
	;



string_expression:
	string_term {$$ = $1;}
	| string_expression PLUS string_term {$$ = strcat($1, $3);}
	;



number_term:
	NUMBER {$$ = $1;}
	| IDENTIFIER {;} // here we need to put a logic to get the identifier value
	;



string_term:
	STRING {$$ = $1;}
	| IDENTIFIER {;} // here we need to put a logic to get the identifier value
	;



function_declaration:
	DEF IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {
		char name_identifier[35];
		strcpy(name_identifier, $2);

		char type_of_element[35];
		strcpy(type_of_element, "");

		char scope[35];
		strcpy(scope, "Testando Escopo"); // Will come from the stack...

		create_new_node(name_identifier, STRUCTURE_FUNCTION, scope, type_of_element);

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

int main (int argc, char **argv) {
	yyin = fopen(argv[1], "r");
	if(yyin == NULL) {
		printf("Error on yyin.\n");
		exit(0);
	}

	yyout = fopen(argv[2], "w");
	if(yyout == NULL) {
		printf("Error on yyout.\n");
		exit(0);
	}

	symbol_table = new_linked_list();

	current_step = FIRST;
	yyparse();

	current_step = SECOND;
	yyparse();

	print_linked_list(symbol_table);

	if((amount_block_comments % 2) != 0) {
		printf("ERRO DE BLOCO DE COMENTARIO\n");
	}
	else {
		//Nothing to do
	}

	return 0;
}


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

void create_new_node(char name_identifier[35], char structure_type[35], char scope[35], char type_of_element[35]) {
	node *new_node = NULL;
	new_node = build_new_node(
				count_identifier,
				current_line,
				tabulation_level,
				space_level,
				type_of_element,
				name_identifier,
				scope,	
				structure_type);

	symbol_table = insert_element(symbol_table, new_node);
	count_identifier++;
}
void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}

