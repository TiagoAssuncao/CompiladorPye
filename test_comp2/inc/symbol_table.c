#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "symbol_table.h"
#include "debugger.h"


int main(int argc, char **argv) {
	puts("Hello, world!");

	return 0;
}

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
		
		free(current_node->data);
		free(current_node);
	}

	debug("FUNCTION free_symbol_table: Leaving...");
}

void insert_element(linked_list *symbol_table, void *element) {
	assert(symbol_table != NULL);

	debug("FUNCTION insert_element: Starting...");

	node *new_node = NULL;
	new_node = (node *) malloc(sizeof(node));
	
	new_node->data = NULL;
	new_node->data = malloc(symbol_table->element_size);
	
	if(new_node != NULL && new_node->data != NULL) {
		new_node->next = NULL;

		memcpy(new_node->data, element, symbol_table->element_size);

		if(symbol_table->length == 0) {
			symbol_table->head = symbol_table->tail = new_node;
		} 
		else {
			symbol_table->tail->next = new_node;
			symbol_table->tail = new_node;
		}
	}
	else {
		malloc_error_msg();
		exit(0);
	}	

	debug("FUNCTION insert_element: Leaving...");
}

void malloc_error_msg() {
	puts("There was an error while allocating memory with malloc. Do something. Now.\n");
}
