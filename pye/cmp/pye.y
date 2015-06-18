%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>

	#include "linked_list.h"
	#include "stack.h"
	#include "debugger.h"
	#include "mathematics.h"

	enum steps {
		FIRST,
		SECOND
	};

	enum expression_types {
		NUMBER_EXPRESSION,
		STRING_EXPRESSION
	};

	enum structure_types {
		FUNCTION_STRUCTURE,
		VARIABLE_STRUCTURE,
		CLASS_STRUCTURE,
		METHOD_STRUCTURE
	};

	const char STRUCTURE_TYPES[][35] = {"function", "variable", "class", "method"};
	const char EXPRESSION_TYPES[][35] = {"number", "string"};

	list_header *symbol_table;
	stack_header *scope_stack;

	unsigned int current_step;
	unsigned int count_identifier = 0;

	// Change to stack.. 
	char CURRENT_SCOPE[35];

	void check_scope_stack();
	void apply_tabulation();
	void insert_on_symbol_table(const char name_identifier[35], const char structure_type[35], const char type_of_element[35]);
	void yyerror (char *s);

	extern FILE *yyin;
	extern FILE *yyout;
	extern unsigned int current_line;
	extern unsigned int tabulation_level;
	extern unsigned int space_level;
	extern unsigned int amount_block_comments;
	extern clean_white_level();
%}


%union {
	int logic_handler;
	double num;
	char *string;
	char *identifier; 
	char *line_comment; 
	char *block_comment;
}

%start input

%token IF ELSE FOR WHILE TRY CATCH
%token DEF CLASS METHOD
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
%type <logic_handler> expression number_expression string_expression declaration_identifier

%%

input:
	rule {check_scope_stack();}
	| input rule {check_scope_stack();}
	;

rule:
	command {;}
	| declaration {;}
	| NEW_LINE {
		clean_white_level();
		fprintf(yyout, "\n");
	}
	| comment {;}
	;

command:
	assignment command_finisher {;}
	;

command_finisher:
	NEW_LINE {
		clean_white_level();
		fprintf(yyout, "\n");
	}
	| SEMICOLON {fprintf(yyout, ";");}
	;

assignment:
	IDENTIFIER EQUAL expression {
		char name_identifier[35];
		strcpy(name_identifier, $1);

		int expression_type = $3;

		char element_type[35];
		strcpy(element_type, EXPRESSION_TYPES[expression_type]);

		insert_on_symbol_table(name_identifier, STRUCTURE_TYPES[VARIABLE_STRUCTURE], element_type);

		fprintf(yyout, "%s =", $1);
	}
	;

expression:
	number_expression {$$ = NUMBER_EXPRESSION;}
	| string_expression {$$ = STRING_EXPRESSION;}
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

declaration:
	declaration_identifier IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {
		char name_identifier[35];
		strcpy(name_identifier, $2);

		char element_type[35];
		strcpy(element_type, "");

		char scope[35];
		strcpy(scope, "Testando Escopo"); // Will come from the stack...

		int structure_type = $1;

		insert_on_symbol_table(name_identifier, STRUCTURE_TYPES[structure_type], element_type);

		apply_tabulation();
		fprintf(yyout, "# Function declaration: %s\n", $2);
		apply_tabulation();
		fprintf(yyout, "def %s():", $2);

		insert_scope_on_stack(scope_stack, $2, tabulation_level, space_level);
	}

declaration_identifier:
	DEF {$$ = FUNCTION_STRUCTURE;}
	| CLASS {$$ = CLASS_STRUCTURE;}
	| METHOD {$$ = METHOD_STRUCTURE;}

comment:
	LINE_COMMENT { fprintf(yyout, "%s", $1);}
	| BLOCK_COMMENT { fprintf(yyout, "%s", $1);}
	;

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
	scope_stack = new_stack();

	current_step = FIRST;
	yyparse();

	current_step = SECOND;
	yyparse();

	print_linked_list(symbol_table);
	
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

void check_scope_stack() {
	if(scope_stack->length > 0) {
		stack_node *top_node = scope_stack->top;
		while(top_node->tabulation_level >= tabulation_level || top_node->space_level >= space_level) {
			pop_element(scope_stack);
			
			if(scope_stack->length == 0)
				break;
		
			top_node = scope_stack->top;
		}
	}
}

void insert_on_symbol_table(const char name_identifier[35], const char structure_type[35], const char element_type[35]) {
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

