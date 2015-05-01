#ifndef _SYMBOL_TABLE_H_
#define _SYMBOL_TABLE_H_

typedef struct node {
	char value_type;
	char *identifier;
	char *scope;
	char *value;
	struct node *next;
	struct node *previous;
}node;

node *build_node(char _value_type, char *_identifier, char *_scope, char *_value);
node *insert_node(char _value_type, char *_identifier, char *_scope, char *_value);
node *search_identifier(char *_identifier);
void free_symbol_table(node *_root_node);

#endif
