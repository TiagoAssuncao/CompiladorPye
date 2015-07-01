%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>

	#include "linked_list.h"
	#include "stack.h"
	#include "debugger.h"
	#include "mathematics.h"
	#include "log.h"

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

	FILE *log_file;
	stack_header *scope_stack;

	unsigned int current_step;
	unsigned int count_identifier = 0;
	unsigned int number_variable = 0;
	unsigned int number_class = 0;
	unsigned int number_method = 0;
	double number_expression_value = 0;
	char string_expression_value[35];

	// Change to stack.. 
	char CURRENT_SCOPE[35];

	void check_scope_stack();
	void apply_tabulation();
	void insert_on_symbol_table(const char name_identifier[35], const char structure_type[35], const char type_of_element[35]);
	void check_undeclaration(char *identifier);
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
	rule {;}
	| input rule {;}
	;

rule:
	command {check_scope_stack();}
	| declaration {;}
	| NEW_LINE {
		current_line++;
		clean_white_level();
		if(current_step == SECOND) {
			fprintf(yyout, "\n");
		}
		else {
			//Nothing to do
		}
	}
	| comment {check_scope_stack();}
	;

command:
	assignment command_finisher {;}
	;

command_finisher:
	NEW_LINE {
		current_line++;
		clean_white_level();
		if(current_step == SECOND) {
			fprintf(yyout, "\n");
		}
		else {
			//Nothing to do
		}
	}
	| SEMICOLON { 
		if(current_step == SECOND) {
			fprintf(yyout, ";");
		}
		else {
			//Nothing to do
		}
	}
	;

assignment:
	IDENTIFIER EQUAL expression {
		if(current_step == FIRST) {
			char name_identifier[35];
			strcpy(name_identifier, $1);

			int expression_type = $3;

			char element_type[35];
			strcpy(element_type, EXPRESSION_TYPES[expression_type]);

			node *node_found = search_element(symbol_table, name_identifier, get_top(scope_stack)->scope_name);
			if(!node_found) {
				insert_on_symbol_table(name_identifier, STRUCTURE_TYPES[VARIABLE_STRUCTURE], element_type);
				number_variable++;
			}
		}
		else {
			apply_tabulation();
			fprintf(yyout, "%s = ", $1);
			if($3 == NUMBER_EXPRESSION) {
				fprintf(yyout, "%.2lf", number_expression_value);
			}
			else {
				fprintf(yyout, "%s", string_expression_value);
			}

			//fprintf(log_file, "Line %u -> Assignment found! Variable identifier: %s\n", current_line, $1);
		}
	}
	;

expression:
	number_expression {
		if(current_step == FIRST) {
			$$ = NUMBER_EXPRESSION;
		}
		else{
			//Code Generate
		}
	}
	| string_expression {
		if(current_step == FIRST) {
			$$ = STRING_EXPRESSION;
		}
		else{
			//Code Generate
		}
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
	| string_expression PLUS string_term {
		$$ = STRING_EXPRESSION; 
	}
	;

number_term:
	NUMBER {
		$$ = $1;
		number_expression_value = $1;
	}
	| IDENTIFIER {
		check_undeclaration($1);
	}
	;

string_term:
	STRING {
		$$ = $1;
		strcpy(string_expression_value, $1);
	}
	| IDENTIFIER {
		check_undeclaration($1);
	}
	;

declaration:
	declaration_identifier IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {
		if(current_step == FIRST) {
			char name_identifier[35];
			strcpy(name_identifier, $2);
			
			char element_type[35];
			strcpy(element_type, "");

			int structure_type = $1;

			insert_on_symbol_table(name_identifier, STRUCTURE_TYPES[structure_type], element_type);
		}
		else {
			apply_tabulation();
			if($1 == FUNCTION_STRUCTURE) {
				fprintf(yyout, "# Function declaration: %s\n", $2);
				apply_tabulation();
				fprintf(yyout, "def %s():", $2);
			}
			else {
				fprintf(yyout, "# Class declaration: %s\n", $2);
				apply_tabulation();
				fprintf(yyout, "class %s():", $2);
			}
		}

		insert_scope_on_stack(scope_stack, $2, tabulation_level, space_level);
	}

declaration_identifier:
	DEF {
		number_method++;
		$$ = FUNCTION_STRUCTURE;}
	| CLASS {
		number_class++;
		$$ = CLASS_STRUCTURE;
	}
	| METHOD {
		number_method++;
		$$ = METHOD_STRUCTURE;
	}

comment:
	LINE_COMMENT { 
		if(current_step == SECOND) {
			fprintf(yyout, "%s", $1);
		}
		else {
			//Nothing to do
		}
	}
	| BLOCK_COMMENT { 
		if(current_step == SECOND) {
			fprintf(yyout, "%s", $1);
		}
		else {
			//Nothing to do
		}
	}
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

	log_file = fopen("log_file.txt", "w");
	if(log_file == NULL) {
		printf("Error on log_file.\n");
		exit(0);
	}

	symbol_table = new_linked_list();
	scope_stack = new_stack();

	insert_scope_on_stack(scope_stack, "Main", 0, 0);
	
	current_step = FIRST;
	yyparse();

	//Placing the file pointer at the beginning
	fseek(yyin, 0, SEEK_SET);

	print_number_terms(log_file, number_variable, number_method, number_class);

	//Doing SECOND STEP for Generate the output of code
	current_step = SECOND;
	current_line = 1;
	yyparse();

	print_log_unused(symbol_table, log_file);
	print_number_of_errors(log_file);
	print_number_of_warnings(log_file);
	
	fprintf(yyout, "\n");
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
	if(scope_stack->length > 1) {
		stack_node *top_node = scope_stack->top;
		while(top_node->tabulation_level >= tabulation_level || top_node->space_level >= space_level) {

			pop_element(scope_stack);
			
			if(scope_stack->length == 1){
				break;
			}
		
			top_node = scope_stack->top;
		}
	}
}

void insert_on_symbol_table(const char name_identifier[35], const char structure_type[35], const char element_type[35] ) {
	node *new_node = NULL;

	char scope[35];
	stack_node *top_stack = get_top(scope_stack);
	strcpy(scope, top_stack->scope_name);

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

void check_undeclaration(char *identifier) {
	char scope[35];
	stack_node *top_stack = get_top(scope_stack);
	strcpy(scope, top_stack->scope_name);

	node *node_found = search_element(symbol_table, identifier, scope);
	if(node_found) {
		if(current_line > node_found->declaration_line) {
			node_found->is_used = TRUE;
		}
		else {
			print_log_undeclared(identifier, current_line, log_file, scope);
		}
	}
	else if(current_step == SECOND) {
		print_log_undeclared(identifier, current_line, log_file, scope);
	}
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}

