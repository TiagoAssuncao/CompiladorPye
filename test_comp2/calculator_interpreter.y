%{
	#include <stdio.h>
	#include <stdlib.h>
	
	#define TABLE_SIZE 52	

	void yyerror (char *s);

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
				| print expression ';' {printf("Printing... %d\n", $2);}
				| exit_command ';' {exit(EXIT_SUCCESS);}
				| input assignment ';' {;}
				| input print expression ';' {printf("Printing... %d\n", $3);}
				| input exit_command ';' {exit(EXIT_SUCCESS);}
				;


assignment: 	identifier '=' expression {update_symbol_value($1, $3);}
				;


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


int main (void) {
	int i;
	for(i = 0; i < TABLE_SIZE; i++) {
		symbol_table[i] = 0;
	}
	
	return yyparse();
}

void yyerror (char *s) {
	fprintf (stderr, "%s\n", s);
} 
