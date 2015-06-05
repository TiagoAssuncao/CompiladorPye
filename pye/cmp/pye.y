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

	enum {
		NUMBER_EXPRESSION,
		STRING_EXPRESSION
	};

	const char STRUCTURE_ARRAY [][35] = {"function", "variable", "class", "method"};
	const char ELEMENT_TYPE [][35] = {"number", "string"};

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
	void create_new_node(const char name_identifier[35], const char structure_type[35], const char type_of_element[35]);

	extern FILE *yyin;
	extern FILE *yyout;
	extern unsigned int current_line;
	extern unsigned int tabulation_level;
	extern unsigned int space_level;
	extern unsigned int amount_block_comments;
%}


%union {
	int expression_type;
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

%type <num> input number_term
%type <string> string_term
%type <expression_type> expression number_expression string_expression

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
	IDENTIFIER EQUAL expression {
		char name_identifier[35];
		strcpy(name_identifier, $1);

		int expression_type = $3;

		char element_type[35];
		strcpy(element_type, ELEMENT_TYPE[expression_type]);

		create_new_node(name_identifier, STRUCTURE_VARIABLE, element_type);
	}
	;



expression:
	number_expression {
		$$ = NUMBER_EXPRESSION;
	}
	| string_expression {
		$$ = STRING_EXPRESSION;
	}
	;



number_expression:
	number_term {$$ = NUMBER_EXPRESSION;}
	| number_expression PLUS number_term {$$ = NUMBER_EXPRESSION;}
	| number_expression MINUS number_term {$$ = NUMBER_EXPRESSION;}
	| number_expression MULTIPLY number_term {$$ = NUMBER_EXPRESSION;}
	| number_expression DIVIDE number_term {$$ = NUMBER_EXPRESSION;}
	| number_expression POW number_term {$$ = NUMBER_EXPRESSION;}
	;



string_expression:
	string_term {$$ = STRING_EXPRESSION;}
	| string_expression PLUS string_term {$$ = STRING_EXPRESSION;}
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

		char element_type[35];
		strcpy(element_type, "");

		char scope[35];
		strcpy(scope, "Testando Escopo"); // Will come from the stack...

		create_new_node(name_identifier, STRUCTURE_FUNCTION, element_type);

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

void create_new_node(const char name_identifier[35], const char structure_type[35], const char element_type[35]) {
	node *new_node = NULL;

	char scope[35] = "scope"; // change to stack...

	new_node = build_new_node(
				count_identifier,
				current_line,
				tabulation_level,
				space_level,
				element_type,
				name_identifier,
				scope, // implement stack logic right here
				structure_type);

	symbol_table = insert_element(symbol_table, new_node);
	count_identifier++;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}

