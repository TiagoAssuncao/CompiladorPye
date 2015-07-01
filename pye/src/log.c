#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "linked_list.h"
#include "bool.h"
#include "debugger.h"

unsigned int warnings_found = 0;
unsigned int errors_found = 0;

void print_log_unused(list_header *header, FILE *log_file) {
	assert(header);

	node *current_node = header->head;

	while(current_node != NULL) {
		if(current_node->is_used == FALSE) {
			fprintf(log_file, "WARNING: Variable at line %u declared but not used: %s. Scope: %s.\n", 
				current_node->declaration_line,
				current_node->identifier, 
				current_node->scope);
		}

		warnings_found++;
		current_node = current_node->next;
	}
}

void print_log_undeclared(char *identifier, unsigned int current_line, FILE *log_file, char *scope) {
	assert(identifier);
	assert(scope);
	assert(log_file);

	errors_found++;
	fprintf(log_file, "ERROR: Variable at line %u not declared: %s. Scope: %s.\n", current_line, identifier, scope);
}

void print_number_terms(FILE *log_file, unsigned int number_of_variables, unsigned int number_of_methods, unsigned int number_of_classes) {	
	fprintf(log_file, "Number of variables found: %u\n", number_of_variables);
	fprintf(log_file, "Number of methods found: %u\n", number_of_methods);
	fprintf(log_file, "Number of classes found: %u\n\n", number_of_classes);
}

void print_number_of_errors(FILE *log_file) {
	fprintf(log_file, "\nERRORS Found: %u\n", errors_found);
}

void print_number_of_warnings(FILE *log_file) {
	fprintf(log_file, "WARNINGS Found: %u\n", warnings_found);
}
