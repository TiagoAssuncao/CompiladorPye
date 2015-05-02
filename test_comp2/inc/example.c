#include <stdio.h>

#include "symbol_table.h"
#include "debugger.h"

// Use gcc -o <prog_name> example.c symbol_table.c debugger.c, for now...

bool int_comparison(void *n1, void *n2) {
	bool EQUAL = FALSE;

	EQUAL = *((int *) n1) == *((int *) n2);

	return EQUAL;
}

int main(int argc, char **argv) {
	puts("Hello, world!");

	// Example of an int list using the generic list...
	linked_list *int_list;
	int_list = new_symbol_table(sizeof(int));

	// Insert three elements in the list...
	int a = 8;
	insert_element(int_list, &a);

	int b = 9;
	insert_element(int_list, &b);

	int c = 10;
	insert_element(int_list, &c);

	// Prints its length
	printf("length: %u\n", int_list->length);

	// Iterate through and print every node according to its type (int, in this case).
	node *aux = NULL;
	for(aux = int_list->head; aux != NULL; aux = aux->next) {
		printf("%d, ", *((int *)aux->element));
	}
	printf("\n");

	// Search a value (11, in this case) in the created list (8, 9 and 10).
	int n = 11;
	node *found_node = NULL;
	found_node = search_element(int_list, &n, int_comparison);

	if(found_node == NULL) {
		printf("NOT ");
	}
	printf("found\n");

	return 0;
}