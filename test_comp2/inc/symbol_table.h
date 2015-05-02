#ifndef _SYMBOL_TABLE_H_
#define _SYMBOL_TABLE_H_

// A function's pointer that will be used as a generic free function.
// typedef void (*free_function)(void *);


// A generic node that can handle any data type due to its void pointer (void *) element (data).
// By building this guy down here, only one implementation of a linked list will be necessary.
typedef struct node {
	void *data;
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


// Allocates memory to a linked list and fill its element_size with the first parameter.
linked_list *new_symbol_table(unsigned int element_size);

// Frees every node of a symbol table. In other words, free the WHOLE symbol table.
void free_symbol_table(linked_list *symbol_table);

// Inserts a element in the last position of the symbol table.
void insert_element(linked_list *symbol_table, void *element);

// Returns the symbol table size.
unsigned int symbol_table_size(linked_list *symbol_table);

#endif
