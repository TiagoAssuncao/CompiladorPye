/*
UNB-FGA - Fundamentals of compilers 2014-1
This program stores in a table data on the symbols of the compiler Pye
We used a simple linked list for this

Compiler utilized: gcc -g -o nameOfTheExecutable -W -Wall -pedantic -ansi -I. nameOfTheProgram.c -lm
*/
#include <stdlib.h>
#include <stdio.h>

int numberIdSymbol = 0;

/*Data struct declaretion*/
typedef struct nodeList
{
	unsigned int idSymbol;
	char nameSymbol[50];
	char contextSymbol[50];
	struct nodeList *nextNode;

}nodeList;

nodeList *header = NULL;

nodeList *includeNodeList(nodeList *header, int idSymbol, char *nameSymbol, char *contextSymbol){

	nodeList *newNode = malloc(sizeof(nodeList));
	newNode->idSymbol = idSymbol;
	strcpy(newNode->nameSymbol, nameSymbol);	
	strcpy(newNode->contextSymbol, contextSymbol);	

	if (header != NULL)
	{
		newNode->nextNode = header;
	}
	else{
		newNode->nextNode = NULL;
	}
	
	numberIdSymbol++;
	header = newNode;
	return header;
}

void ler(){
	
	if(header){
		nodeList *currentNode = header;

		while(currentNode != NULL){
		
			printf("Nome: %s, \tId: %d\n", currentNode->nameSymbol, currentNode->idSymbol);
			currentNode = currentNode->nextNode;
		}
	}else{
		printf("Nao existem nos\n");
	}
}

void insert(char *nameSymbol, char *contextSymbol){
	header = includeNodeList(header, numberIdSymbol, nameSymbol, contextSymbol);
}
