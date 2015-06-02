%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>

	#include "linked_list.h"
	#include "variable_list.h"
	#include "debugger.h"

	enum {
		FIRST,
		SECOND
	};

	unsigned int CURRENT_STEP;
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
%token PLUS MINUS MULTIPLY DIVIDE EQUAL
%token NEW_LINE 

%token <num> NUMBER
%token <string> STRING 
%token <identifier> IDENTIFIER
%token <line_comment> LINE_COMMENT
%token <block_comment> BLOCK_COMMENT

%type <num> input number_expression term assignment
%type <string> string_expression


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
	| number_expression command_finisher {;}
	| string_expression command_finisher {;}
	;



command_finisher:
	NEW_LINE {fprintf(yyout, "\n");}
	| SEMICOLON {fprintf(yyout, ";");}
	;



assignment:
	IDENTIFIER EQUAL number_expression {
		apply_tabulation();
		fprintf(yyout, "# Variable identifier: %s. Value: %lf\n", $1, $3);
		apply_tabulation();
		fprintf(yyout, "%s = %lf", $1, $3);
		$$ = $3;
	}
	| IDENTIFIER EQUAL string_expression {
		apply_tabulation();
		fprintf(yyout, "# Variable identifier: %s. String value: %s\n", $1, $3);
		apply_tabulation();
		fprintf(yyout, "%s = %s\n", $1, $3);
		$$ = $3;
	}
	| IDENTIFIER EQUAL assignment {$$ = $3;}
	;


number_expression:
	term {$$ = $1;}
	| number_expression PLUS term {$$ = $1 + $3;}
	| number_expression MINUS term {$$ = $1 - $3;}
	;


term:
	NUMBER {$$ = $1;}
	| IDENTIFIER {;}
	;

string_expression:
	{;}
	| STRING {$$ = $1;}
	;

function_declaration:
	DEF IDENTIFIER LEFT_PARENTHESIS RIGHT_PARENTHESIS COLON {

		char name_identifier[35];
		strcpy(name_identifier, $2);

		char structure_type[35];
		strcpy(structure_type, "function");

		char scope[35];
		strcpy(scope, "Testando Escopo");

		build_new_node(
			count_identifier,
			current_line,
			tabulation_level,
			space_level,
			NULL,
			name_identifier,
			scope,	
			structure_type);

		count_identifier++;

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

	CURRENT_STEP = FIRST;
	yyparse();

	CURRENT_STEP = SECOND;
	yyparse();

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

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
}

