#ifndef _VARIABLE_LIST_H_
#define _VARIABLE_LIST_H_

typedef struct {
	char identifier[35];
	char function_scope[35];
	bool is_declared;
	unsigned int declaration_line;
} variable_data;

variable_data build_variable_data(char identifier[], char function_scope[], bool is_declared, unsigned int declaration_line);


#endif
