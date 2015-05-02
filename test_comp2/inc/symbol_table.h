#ifndef _SYMBOL_TABLE_H_
#define _SYMBOL_TABLE_H_

// A function's pointer that will be used as a generic free function.
typedef void (*free_function)(void *);


// A generic node that can handle any data type due to its void pointer (void *) element (data).
// By building this guy down here, only one implementation of a linked list will be needed.
typedef struct generic_node {
	void *data;
	struct node *next;
	struct node *previous;
} generic_node;


// A helper structure that will control a symbol table (linked list) as a whole.
// Its first element (length) represents how many nodes are present.
// The second one (element_size) represents the size of the type to replace the generic type.
// Third and fourth ones are, respectively, a pointer to the first node and a pointer to the last node of the list.
// The last one is a pointer to a function that will implement a specific way of freeing the specific type of the list.
typedef struct {
	int length;
	int element_size;
	generic_node *head;
	generic_node *tail;
	free_function free_f;
} symbol_table;

node *build_node(char _value_type, char *_identifier, char *_scope, char *_value);
node *insert_node(char _value_type, char *_identifier, char *_scope, char *_value);
node *search_identifier(char *_identifier);
void free_symbol_table(node *_root_node);

#endif
