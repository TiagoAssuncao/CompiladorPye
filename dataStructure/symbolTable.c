/*
UNB-FGA - Fundamentals of compilers 2014-1
This program stores in a table data on the symbols of the compiler Pye
We used a simple linked list for this

Compiler utilized: gcc -g -o nameOfTheExecutable -W -Wall -pedantic -ansi -I. nameOfTheProgram.c -lm
*/
#include <stdlib.h>
#include <stdio.h>

/*Data struct declaretion*/
typedef struct nodeList
{
	unsigned int idSymbol;
	struct nodeList *nextNode;

}nodeList;

nodeList *includeNodeList(nodeList *header, int idValueSimble){

	nodeList *newNode = NULL;
	newNode->idSymbol = idValueSimble;

	if (header != NULL)
	{
		newNode->nextNode = header;
	}
	else{
		newNode->nextNode = NULL;
	}

	header = newNode;
	return header;
}

int main(void)
{
	/* code */
	return 0;
}