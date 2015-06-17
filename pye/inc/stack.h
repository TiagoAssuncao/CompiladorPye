#ifndef _STACK_H_
#define _STACK_H_

//It's a struct for store every names of the scope in a stack
typedef struct stack_node {
	char scope_name[35];
	unsigned int tabulation_level;
	unsigned int space_level;
	struct stack_node *next;
	struct stack_node *previous;
} stack_node;

typedef struct {
	unsigned int length;
	stack_node *top;
} stack_header;

stack_header *new_stack();
stack_header *insert_scope_on_stack(stack_header *header, char scope_name[35], unsigned int tabulation_level, unsigned int space_level);
stack_header *pop_element(stack_header *header);
stack_node *get_top(stack_header *header);
void show_stack(stack_header *header);


#endif 