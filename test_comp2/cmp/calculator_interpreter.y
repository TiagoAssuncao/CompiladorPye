%{
	#include <stdio.h>
	#include <stdlib.h>
	
	#define TABLE_SIZE 52	

	void yyerror (char *s);
	extern FILE *yyin;

	int symbol_table[52];
	int get_symbol_value(char symbol);
	void update_symbol_value(char symbol, int value);
%}


%union {int num; char id;}
%start input
%token print
%token exit_command
%token <num> number
%token <id> identifier
%type <num> input expression term
%type <id> assignment


%%

input: 			assignment ';' {;}
				| input assignment ';' {;}
				| expression ';' {printf("Printing... %d\n", $1);}
				| input expression ';' {printf("Printing... %d\n", $2);}
				| exit_command ';' {exit(EXIT_SUCCESS);}
				| input exit_command ';' {exit(EXIT_SUCCESS);}
				;


assignment: 	identifier '=' expression {$$ = $3; update_symbol_value($1, $3);}
				| identifier '=' assignment {$$ = $3; update_symbol_value($1, $3);}


expression:		term {$$ = $1;}
				| expression '+' term {$$ = $1 + $3;}
				| expression '-' term {$$ = $1 - $3;}
				;


term:	 		number {$$ = $1;}
				| identifier {$$ = get_symbol_value($1);}
				;

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

	if(yyin == NULL) {
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
