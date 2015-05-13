#include <iostream>
#include <vector>
#include <stdio.h>
#include <string>

using namespace std;

class CodeGenContext;
class NStatement;
class NExpression;
class NVariableDeclaration;

typedef vector<NStatement*> StatementList;
typedef vector<NExpression*> ExpressionList;
typedef vector<NVariableDeclaration*> VariableList;


//Primeiro nivel
class Node {
public:
	virtual ~Node(){}
};

//Segundo nivel
class NExpression : public Node {
};

class NStatement : public Node {
};

//Terceiro nivel
class NInterger : public NExpression{
public:
	long int value;

	NInterger (long int value) : value(value)
};

class NIdentifier : public NExpression{
public:
	string name;

	NIdentifier (string name) : name(name) {}
};

class NOperator : public NExpression
{
public:
	int op;
	NExpression *leftExpression;
	NExpression *rightExpression;

	NOperator (NExpression *leftExpression, int op, NExpression* rightExpression) :
        leftExpression(leftExpression), rightExpression(rightExpression), op(op) {}
};



class NVariableDeclaration : public NStatement
{
public:
	NIdentifier *type;
	const NIdentifier *id;
	NExpression *value;

	NVariableDeclaration (NIdentifier *type, const NIdentifier *id, NExpression *value) : type(type), id(id), value(value) {}
};



