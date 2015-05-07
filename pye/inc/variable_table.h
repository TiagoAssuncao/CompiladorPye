#ifndef _VARIABLE_TABLE_H_
#define _VARIABLE_TABLE_H_

typedef struct {
	char identifier[35];
	char function_scope[35];
	bool is_declared;
	unsigned int declaration_line;
} variable_data;

#endif
