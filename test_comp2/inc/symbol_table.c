#include <stdio.h>
#include <stdlib.h>

#include "symbol_table.h"

int main(int argc, char **argv) {
	puts("Hello, world!");
	
	node *root_node = build_node('F', "main_node", "main_function", "brasil");

	printf("root_node value_type: %c\n", root_node->value_type);
	printf("root_node identifier: %s\n", root_node->identifier);
	printf("root_node scope: %s\n", root_node->scope);
	printf("root_node value: %s\n", root_node->value);

	return 0;
}

node *build_node(char _value_type, char *_identifier, char *_scope, char *_value) {
	node *new_node = (node *) malloc(sizeof(node));

	if(new_node != NULL) {
		new_node->value_type = _value_type;
		new_node->identifier = _identifier;
		new_node->scope = _scope;
		new_node->value = _value;
		new_node->next = new_node->previous = NULL;
	}
	else {
		puts("An error occurred while building a node!");
		exit(0);
	}

	return new_node;
}

void free_symbol_table(node *_root_node) {
	node *helper_node;
	
	while(_root_node != NULL) {
		helper_node = _root_node;
		_root_node = _root_node->next;

		free(helper_node);
	}

	return;
}


