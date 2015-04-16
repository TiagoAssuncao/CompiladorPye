/*
UNB-FGA - Fundamentals of compilers 2014-1
This program stores in a table data on the symbols of the compiler Pye
We used a simple linked list for this

Compiler utilized: gcc -g -o nameOfTheExecutable -W -Wall -pedantic -ansi -I. nameOfTheProgram.c -lm
*/
#include <stdlib.h>
#include <stdio.h>

//Data struct declaretion
typedef struct nodeList
{
	unsigned int idSymbol;
	unsigned char nameSymbol[30];
	struct nodeList *nextNode;

}nodeList;

int main(void)
{
	/* code */
	return 0;
}