all: flex_scanner calculator_interpreter.tab.c
	 	gcc -g lex.yy.c calculator_interpreter.tab.c -o calculator_interpreter

flex_scanner: bison_parser calculator_interpreter.l
			  	flex calculator_interpreter.l

bison_parser: calculator_interpreter.y
				bison -d calculator_interpreter.y

clean:
		rm -f lex.yy.c calculator_interpreter.tab.c calculator_interpreter.tab.h calculator_interpreter
