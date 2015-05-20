#ifndef _LINKED_LIST_H_
#define _LINKED_LIST_H_

#include "bool.h"

// A function pointer that will be used as a generic free function.
// typedef void (*free_function)(void *);

// As the type on the linked list will be generic, we need a way to compare elements while iterating through the linked list.
// Thus, this is defining a function (of comparison) pointer that can be passed as argument in many functions.
typedef bool (*generic_comparator)(void *, void *);


// A generic node that can handle any data type due to its void pointer (void *) element.
// By building this guy down here, only one implementation of a linked list will be necessary.
typedef struct node {
	void *element;
	struct node *next;
	struct node *previous;
} node;


// A helper structure that will control a linked list as a whole.
// Its first element (length) represents how many nodes are present.
// The second one (element_size) represents the size of the type to replace the generic type.
// Third and fourth ones are, respectively, a pointer to the first node and a pointer to the last node of the list.
// The last one is a pointer to a function that will implement a specific way of freeing the specific type of the list.
typedef struct {
	unsigned int length;
	unsigned int element_size;
	node *head;
	node *tail;
	// free_function free_f;
} list_header;


// Allocates memory to a linked list and fill its element_size with the first parameter.
// Returns a linked_list pointing to an allocated memory space.
list_header *new_linked_list(unsigned int element_size);

// Frees every node of a linked list. In other words, free the WHOLE linked list.
void free_linked_list(list_header *header);

// Inserts an element in the last position of the linked list.
// Returns a linked_list pointer with its head/tail updated(s).
list_header *insert_element(list_header *header, void *element);

// Search for a element in the linked list. The third is a pointer function that points to a comparison function.
// If it is found, returns a pointer to the correlated node.
// Otherwise, returns NULL.
node *search_element(list_header *header, void *element, generic_comparator comparison_function);

node *remove_element(list_header *header, void *element, generic_comparator comparison_function);

// Displays a message of a memory allocation error.
void malloc_error_msg();

// Comparison functions. Each one of them define a specific way of comparing two variables of man types.
bool uint_comparator(void *first_unsigned, void *second_unsigned);
bool char_comparator(void *first_char, void *second_char);
bool string_comparator(void *first_string, void *second_string);
bool double_comparator(void *first_double, void *second_double);

#endif
