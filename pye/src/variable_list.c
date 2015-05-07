#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "linked_list.h"
#include "variable_list.h"
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

