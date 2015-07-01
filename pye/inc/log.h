#ifndef _LOG_H_
#define _LOG_H_

void print_log_unused(list_header *header, FILE *log_file);
void print_log_undeclared(char *identifier, unsigned int current_line, FILE *log_file, char *scope);
void print_number_terms(FILE *log_file, int number_variable, unsigned int number_method, unsigned int number_class);

#endif 