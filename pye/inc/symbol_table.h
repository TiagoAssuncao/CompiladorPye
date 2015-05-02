#ifndef _SYMBOL_TABLE_H_
#define _SYMBOL_TABLE_H_

// A function pointer that will be used as a generic free function.
// typedef void (*free_function)(void *);


// C (< C99) has no bool type. This will simulate it.
typedef enum {
	FALSE,
	TRUE
} bool;


// As the type on the symbol table will be generic, we need a way to compare elements while iterating through the symbol table.
// Thus, this is defining a function (of comparison) pointer that can be passed as argument in many functions.
typedef bool (*generic_comparator)(void *, void *);


// A generic node that can handle any data type due to its void pointer (void *) element (data).
// By building this guy down here, only one implementation of a linked list will be necessary.
typedef struct node {
	void *element;
	struct node *next;
	struct node *previous;
} node;


// A helper structure that will control a symbol table (linked list) as a whole.
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
} linked_list;


// Allocates memory to a symbol table and fill its element_size with the first parameter. 
// Returns a linked_list pointing to an allocated memory space.
linked_list *new_symbol_table(unsigned int element_size);

// Frees every node of a symbol table. In other words, free the WHOLE symbol table.
void free_symbol_table(linked_list *symbol_table);

// Inserts an element in the last position of the symbol table.
// Returns a linked_list pointer with its head/tail updated(s).
linked_list *insert_element(linked_list *symbol_table, void *element);

// Search for a element in the symbol table. The third is a pointer function that points to a comparison function.
// If it is found, returns a pointer to the correlated node.
// Otherwise, returns NULL.
node *search_element(linked_list *symbol_table, void *element, generic_comparator comparison_function);


node *remove_element(linked_list *symbol_table, void *element, generic_comparator comparison_function);

// Displays a message of a memory allocation error.
void malloc_error_msg();

#endif