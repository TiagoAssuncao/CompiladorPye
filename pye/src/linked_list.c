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

list_header *insert_element(list_header *header, node *element) {
	debug("FUNCTION insert_element: Starting...");

	assert(header != NULL);
	assert(element != NULL);

	node *new_node = NULL;
	new_node = (node *) malloc(sizeof(node));

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

node *remove_element(list_header *header, void *element, generic_comparator comparison_function) {
	// Not implemented yet (if only it has to be)...

	return NULL;
}

void malloc_error_msg() {
	puts("There was an error while allocating memory with malloc. Do something. Now.\n");
}

// Compararison functions down here.

bool uint_comparator(void *first_unsigned, void *second_unsigned) {
	bool equal = FALSE;
	equal = *((unsigned int *) first_unsigned) == *((unsigned int *) second_unsigned);

	return equal;
}

bool char_comparator(void *first_char, void *second_char) {
	bool equal = FALSE;
	equal = *((char *) first_char) == *((char *) second_char);

	return equal;
}

bool string_comparator(void *first_string, void *second_string) {
	bool equal = FALSE;
	equal = !(strcmp(first_string, second_string));

	return equal;
}

bool double_comparator(void *first_double, void *second_double) {
	bool equal = FALSE;
	equal = *((double *) first_double) == *((double *) second_double);

	return equal;
}
