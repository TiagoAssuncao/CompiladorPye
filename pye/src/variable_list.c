/*#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "linked_list.h"
#include "variable_list.h"
#include "bool.h"
#include "debugger.h"

variable_data build_variable_data(char identifier[], char function_scope[], bool is_declared, unsigned int declaration_line) {
	debug("FUNCTION build_variable_data: Starting...");

	variable_data variable;

	strcpy(variable.identifier, identifier);
	strcpy(variable.function_scope, function_scope);
	variable.is_declared = is_declared;
	variable.declaration_line = declaration_line;

	debug("FUNCTION build_variable_data: Leaving...");

	return variable;
}

node *search_variable_by_identifier(list_header *header, char identifier[]) {
	debug("FUNCTION search_variable_by_identifier: Starting...");

	assert(header != NULL);
	assert(identifier != NULL);

	node *return_node = NULL;

	return_node = search_element(header, identifier, variable_identifier_comparator);

	debug("FUNCTION search_variable_by_identifier: Leaving...");

	return return_node;
}

bool variable_identifier_comparator(void *variable, void *identifier) {
	debug("FUNCTION variable_identifier_comparator: Starting...");

	assert(variable != NULL);
	assert(identifier != NULL);

	char *variable_identifier = NULL;
	variable_identifier = ((variable_data *) variable)->identifier;

	bool equal = FALSE;
	equal = string_comparator(variable_identifier, identifier);

	debug("FUNCTION variable_identifier_comparator: Starting...");


	return equal;
}*/

