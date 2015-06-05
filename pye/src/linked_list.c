#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "linked_list.h"
#include "bool.h"
#include "debugger.h"


list_header *new_linked_list(void) {
	debug("FUNCTION new_linked_list: Starting...");

	list_header *header = NULL;
	header = (list_header *) malloc(sizeof(list_header));

	if(header != NULL) {
		header->length = 0;
		header->head = header->tail = NULL;
	}
	else {
		malloc_error_msg();
		exit(0);
	}

	debug("FUNCTION new_linked_list: Leaving...");

	return header;
}

void free_linked_list(list_header *header) {
	debug("FUNCTION free_linked_list: Starting...");

	assert(header != NULL);

	node *current_node = NULL;
	while(header->head != NULL) {
		current_node = header->head;
		header->head = current_node->next;

		free(current_node);
	}

	debug("FUNCTION free_linked_list: Leaving...");
}

list_header *insert_element(list_header *header, node *new_node) {
	debug("FUNCTION insert_element: Starting...");

	assert(header != NULL);
	assert(new_node != NULL);

	debug("FUNCTION insert_element: New_node malloc'd.");

	if(new_node != NULL) {
		new_node->next = NULL;

		if(header->length == 0) {
			new_node->previous = NULL;
			header->head = header->tail = new_node;
		}
		else {
			new_node->previous = header->tail;
			header->tail->next = new_node;
			header->tail = new_node;
		}

		header->length++;
	}
	else {
		malloc_error_msg();
		exit(0);
	}

	debug("FUNCTION insert_element: Leaving...");

	return header;
}

node *search_element(list_header *header, char node_identifier[]) {
	debug("FUNCTION search_element: Starting...");

	assert(header != NULL);
	assert(node_identifier != NULL);

	node *return_node = NULL;

	if(header->length != 0) {
		node *current_node = NULL;
		current_node = header->head;

		int element_found = 0;

		while(current_node != NULL) {
			element_found = !strcmp(current_node->identifier, node_identifier);

			if(element_found) {
				return_node = current_node;
				break;
			}

			current_node = current_node->next;
		}
	}
	else {
		puts("The linked list is empty.\n");
	}


	debug("FUNCTION search_element: Leaving...");
	return return_node;
}

// Delete remove_element
node *remove_element(list_header *header, void *element, generic_comparator comparison_function) {
	// Not implemented yet (if only it has to be)...

	return NULL;
}

node *build_new_node(unsigned int id, unsigned int declaration_line, unsigned int tabulation_level, unsigned int space_level,
					 char type[35], char identifier[35], char scope[35], char structure_type[35]) 
{
	debug("FUNCTION build_new_node: Starting...");

	node *new_node = (node *) malloc(sizeof(node));

	new_node->is_used = FALSE;
	new_node->id = id;
	new_node->declaration_line = declaration_line;
	new_node->tabulation_level = tabulation_level;
	new_node->space_level = space_level;

	debug("FUNCTION build_new_node: Starting strcpy's.");

	strcpy(new_node->type, type);
	strcpy(new_node->identifier, identifier);
	strcpy(new_node->scope, scope);
	strcpy(new_node->structure_type, structure_type);

	new_node->next = NULL;
	new_node->previous = NULL;

	debug("FUNCTION build_new_node: Leaving...");

	return new_node;
}

void print_linked_list(list_header *header) {
	debug("FUNCTION print_linked_list: Starting...");

	assert(header != NULL);
	assert(header->length != 0);

	node *current_node = header->head;
	while(current_node != NULL) {
		print_node(current_node);

		current_node = current_node->next;
	}

	debug("FUNCTION print_linked_list: Leaving...");

	return;
}

void print_node(node *input_node) {
	debug("FUNCTION print_node: Starting...");

	assert(input_node != NULL);

	printf("ID: %u\n", input_node->id);
	printf("Identifier: %s\n", input_node->identifier);
	printf("Type: %s\n", input_node->type);
	printf("Scope: %s\n", input_node->scope);
	printf("Structure Type: %s\n", input_node->structure_type);
	printf("Declaration Line: %u\n", input_node->declaration_line);
	printf("Tabulation Level: %u\n", input_node->tabulation_level);
	printf("Space Level: %u\n", input_node->space_level);

	debug("FUNCTION print_node: Leaving...");
}

void malloc_error_msg() {
	puts("There was an error while allocating memory with malloc. Do something. Now.\n");
}
