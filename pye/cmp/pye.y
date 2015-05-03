%{
	#include <stdio.h>
	#include <stdlib.h>
	
	#define TABLE_SIZE 52	

	void yyerror (char *s);
	extern FILE *yyin;

	extern unsigned int current_line;

	int symbol_table[52];
	int get_symbol_value(char symbol);
	void update_symbol_value(char symbol, int value);
%}


%union {int num; char id;}

%start input

%token DEF
%token LEFT_PARENTHESIS
%token RIGHT_PARENTHESIS
%token COLON

%token <num> NUMBER
%token <id> IDENTIFIER

%type <num> input expression term
%type <id> assignment


%%

input:						
	command {;}
	| input command {;}
	| function_declaration {;}
	| input function_declaration {;}
	| '\n' {;}
	| input '\n' {;}
	;



command:
	assignment command_finisher {;}
	| expression command_finisher {printf("Printing... %d\n", $1);}
	;



command_finisher:
	'\n' {;}
	| ';' {;}
	;



assignment: 
	IDENTIFIER '=' expression {$$ = $3; update_symbol_value($1, $3);}
	| IDENTIFIER '=' assignment {$$ = $3; update_symbol_value($1, $3);}



expression:
	term {$$ = $1;}
	| expression '+' term {$$ = $1 + $3;}
	| expression '-' term {$$ = $1 - $3;}
	;



term:
	NUMBER {$$ = $1;}
	| IDENTIFIER {$$ = get_symbol_value($1);}
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


int find_symbol_index(char symbol) {
	int index = -1;

	if(islower(symbol)) {
		index = symbol - 'a' + 26;
	} 
	else if(isupper(symbol)) {
		index = symbol - 'A';
	}

	return index;
}

int get_symbol_value(char symbol) {
	int index = find_symbol_index(symbol);

	return symbol_table[index];
}

void update_symbol_value(char symbol, int value) {
	int index = find_symbol_index(symbol);

	symbol_table[index] = value;
}


int main (int argc, char **argv) {
	yyin = fopen(argv[1], "r");

	if (yyin == NULL) {
		printf("An error occurred while reading the file!\n");
		exit(1);
	}
	
	int i;
	for(i = 0; i < TABLE_SIZE; i++) {
		symbol_table[i] = 0;
	}

	yyparse();	

	return 0;
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
} 
