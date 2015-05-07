#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "symbol_table.h"
#include "debugger.h"


linked_list *new_symbol_table(unsigned int element_size) {
	assert(element_size != 0);

	debug("FUNCTION new_symbol_table: Starting...");

	linked_list *symbol_table = NULL;
	symbol_table = (linked_list *) malloc(sizeof(linked_list));

	if(symbol_table != NULL) {
		symbol_table->element_size = element_size;
		symbol_table->length = 0;
		symbol_table->head = symbol_table->tail = NULL;
	}
	else {
		malloc_error_msg();
		exit(0);
	}

	debug("FUNCTION new_symbol_table: Leaving...");
	
	return symbol_table;
}

void free_symbol_table(linked_list *symbol_table) {
	assert(symbol_table != NULL);

	debug("FUNCTION free_symbol_table: Starting...");

	node *current_node = NULL;
	while(symbol_table->head != NULL) {
		current_node = symbol_table->head;
		symbol_table->head = current_node->next;
		
		free(current_node->element);
		free(current_node);
	}

	debug("FUNCTION free_symbol_table: Leaving...");
}

linked_list *insert_element(linked_list *symbol_table, void *element) {
	assert(symbol_table != NULL);

	debug("FUNCTION insert_element: Starting...");

	node *new_node = NULL;
	new_node = (node *) malloc(sizeof(node));
	
	new_node->element = NULL;
	new_node->element = (void *) malloc(symbol_table->element_size);

	debug("FUNCTION insert_element: new node and its element malloc'd");
	
	if(new_node != NULL && new_node->element != NULL) {
		new_node->next = NULL;

		debug("FUNCTION insert_element: before memcpy");
		memcpy(new_node->element, element, symbol_table->element_size);
		debug("FUNCTION insert_element: aftermemcpy");

		if(symbol_table->length == 0) {
			new_node->previous = NULL;
			symbol_table->head = symbol_table->tail = new_node;
		} 
		else {
			new_node->previous = symbol_table->tail;
			symbol_table->tail->next = new_node;
			symbol_table->tail = new_node;
		}

		symbol_table->length++;
	}
	else {
		malloc_error_msg();
		exit(0);
	}	

	debug("FUNCTION insert_element: Leaving...");

	return symbol_table;
}

node *search_element(linked_list *symbol_table, void *element, generic_comparator comparison_function) {
	assert(symbol_table != NULL);

	debug("FUNCTION search_element: Starting...");

	node *return_node = NULL;

	if(symbol_table->length != 0) {
		node *current_node = NULL;
		current_node = symbol_table->head;

		bool element_found = FALSE;

		while(current_node != NULL) {
			element_found = comparison_function(current_node->element, element);

			if(element_found == TRUE) {
				return_node = current_node;
				break;
			}

			current_node = current_node->next;
		}
	}
	else {
		puts("The symbol table is empty.\n");
	}

	debug("FUNCTION search_element: Leaving...");

	return return_node;
}

node *remove_element(linked_list *symbol_table, void *element, generic_comparator comparison_function) {
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
