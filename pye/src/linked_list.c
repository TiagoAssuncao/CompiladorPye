#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "linked_list.h"
#include "debugger.h"


header_list *new_linked_list(const unsigned int element_size) {
	assert(element_size != 0);

	debug("FUNCTION new_linked_list: Starting...");

	header_list *l_list = NULL;
	l_list = (header_list *) malloc(sizeof(header_list));

	if(l_list != NULL) {
		l_list->element_size = element_size;
		l_list->length = 0;
		l_list->head = l_list->tail = NULL;
	}
	else {
		malloc_error_msg();
		exit(0);
	}

	debug("FUNCTION new_linked_list: Leaving...");

	return l_list;
}

void free_linked_list(header_list *l_list) {
	debug("FUNCTION free_linked_list: Starting...");

	assert(l_list != NULL);

	node *current_node = NULL;
	while(l_list->head != NULL) {
		current_node = l_list->head;
		l_list->head = current_node->next;

		free(current_node->element);
		free(current_node);
	}

	debug("FUNCTION free_linked_list: Leaving...");
}

header_list *insert_element(header_list *l_list, void *element) {
	debug("FUNCTION insert_element: Starting...");

	assert(l_list != NULL);

	node *new_node = NULL;
	new_node = (node *) malloc(sizeof(node));

	debug("FUNCTION insert_element: New_node malloc'd. Going for its element now.");

	new_node->element = NULL;
	new_node->element = (void *) malloc(l_list->element_size);

	debug("FUNCTION insert_element: New node and its element malloc'd");

	if(new_node != NULL && new_node->element != NULL) {
		new_node->next = NULL;

		debug("FUNCTION insert_element: Before memcpy");
		memcpy(new_node->element, element, l_list->element_size);
		debug("FUNCTION insert_element: After memcpy");

		if(l_list->length == 0) {
			new_node->previous = NULL;
			l_list->head = l_list->tail = new_node;
		}
		else {
			new_node->previous = l_list->tail;
			l_list->tail->next = new_node;
			l_list->tail = new_node;
		}

		l_list->length++;
	}
	else {
		malloc_error_msg();
		exit(0);
	}

	debug("FUNCTION insert_element: Leaving...");

	return l_list;
}

node *search_element(header_list *l_list, void *element, generic_comparator comparison_function) {
	debug("FUNCTION search_element: Starting...");

	assert(l_list != NULL);

	node *return_node = NULL;

	if(l_list->length != 0) {
		node *current_node = NULL;
		current_node = l_list->head;

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
		puts("The linked list is empty.\n");
	}

	debug("FUNCTION search_element: Leaving...");

	return return_node;
}

node *remove_element(header_list *l_list, void *element, generic_comparator comparison_function) {
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
