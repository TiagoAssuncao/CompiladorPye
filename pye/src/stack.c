#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "stack.h"
#include "debugger.h"


stack_header *new_stack() {
	debug("FUNCTION new_stack: Starting...");

	stack_header *header = NULL;
	header = (stack_header *) malloc(sizeof(stack_header));

	if(header != NULL) {
		header->length = 0;
		header->top = NULL;
	}
	else {
		debug("FUNCTION new_stack: Malloc failed.");
		exit(0);
	}

	debug("FUNCTION new_stack: Leaving...");

	return header;
}

stack_header *insert_scope_on_stack(stack_header *header, char scope_name[35]) {
	debug("FUNCTION insert_scope_on_stack: Starting...");
	
	assert(header != NULL);
	assert(scope_name != NULL);

	stack_node *new_element = (stack_node *) malloc(sizeof(stack_node));
	strcpy(new_element->scope_name, scope_name);
	new_element->next = NULL;
	new_element->previous = header->top;


	if(header->top != NULL) {
		header->top->next = new_element;
		header->top = new_element;
	}
	else {
		header->top = new_element;
	}

	header->length++;

	debug("FUNCTION insert_scope_on_stack: Leaving...");

	return header;
}

//Removes the last term which came in line
stack_header *pop_element(stack_header *header) {
	debug("FUNCTION pop_element: Starting...");
	
	if (header->length > 0) {
		stack_node *element_to_remove = header->top;
		header->top = element_to_remove->previous;
		
		if(header->top != NULL) {
			header->top->next = NULL;
		}

		free(element_to_remove);
		header->length--;
	}
	else {
		debug("FUNCTION pop_element: Can't remove a element. The Stack is blank");
	}

	debug("FUNCTION insert_scope_on_stack: Leaving...");

	return header;
}

stack_node *get_top(stack_header *header) {
	debug("FUNCTION get_top: Starting...");
	
	assert(header != NULL);

	stack_node *element_on_top = NULL;
	element_on_top = header->top;
	
	debug("FUNCTION get_top: Leaving...");

	return element_on_top;
}

void show_stack(stack_header *header) {
	debug("FUNCTION show_stack: Starting...");
	
	assert(header != NULL);

	stack_node *current_element = header->top;
	
	int i = 0;
	while(current_element != NULL) {
		
		printf("%d- Nome do elemento: %s\n", i, current_element->scope_name);

		i++;
		current_element = current_element->previous;
	}
	
	debug("FUNCTION show_stack: Leaving...");
}