INCFOLDER := inc/
SRCFOLDER := src/
BINFOLDER := bin/
OBJFOLDER := obj/

CC := gcc

C_SOURCES := $(wildcard src/*.c)


all: flex_scanner calculator_interpreter.tab.c
	 	gcc -g lex.yy.c calculator_interpreter.tab.c -o calculator_interpreter

flex_scanner: bison_parser calculator_interpreter.l
			  	flex calculator_interpreter.l

bison_parser: calculator_interpreter.y
				bison -d calculator_interpreter.y

do_the_magic: $(C_SOURCES:src/%.c=obj/%.o)
	#to be continued...

clean:
		rm -f lex.yy.c calculator_interpreter.tab.c calculator_interpreter.tab.h calculator_interpreter calculator_interpreter.y~ calculator_interpreter.l~ Makefile~
