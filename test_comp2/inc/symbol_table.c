#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "symbol_table.h"
#include "debugger.h"


int main(int argc, char **argv) {
	puts("Hello, world!");

	return 0;
}

linked_list *new_symbol_table(unsigned int element_size) {
	assert(element_size == 0);

	debug("FUNCTION new_symbol_table: Starting...");

	linked_list *symbol_table = NULL;
	symbol_table = (linked_list *) malloc(sizeof(linked_list));

	if(symbol_table != NULL) {
		symbol_table->element_size = element_size;
		symbol_table->length = 0;
		symbol_table->head = symbol_table->tail = NULL;
	}
	else {
		puts("There was an error while allocating memory with malloc. Do something. Now.\n");
		exit(0);
	}

	debug("FUNCTION new_symbol_table: Leaving...");
	
	return symbol_table;
}

void free_symbol_table(linked_list *symbol_table) {
	debug("FUNCTION free_symbol_table: Starting...");

	node *current_node = NULL;
	while(symbol_table->head != NULL) {
		current_node = symbol_table->head;
		symbol_table->head = current_node->next;
		
		free(current_node->data);
		free(current_node);
	}

	debug("FUNCTION free_symbol_table: Leaving...");

	return;
}

void insert_element(linked_list *symbol_table, void *element) {

}

unsigned int symbol_table_size(linked_list *symbol_table) {
	debug("FUNCTION symbol_table_size: Starting...");
	
	int table_size = 0;
	if(symbol_table != NULL) {
		table_size = symbol_table->length;
	}
	else {
		puts("A empty symbol table has been passed as argument. There is no size.\n");
		exit(0);
	}

	debug("FUNCTION symbol_table_size: Leaving...");

	return table_size;
}

