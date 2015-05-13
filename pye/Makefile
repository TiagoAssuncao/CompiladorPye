#.RECIPEPREFIX = A   <--- This is a comment used to remember... Ignore it...

CC = g++
FLAGS = 

C_FILES = $(wildcard src/*.c)
O_FILES = $(patsubst src/%.c, obj/%.o, $(C_FILES))


.PHONY: all
all: bin/pye

bin/pye: lexical parser $(O_FILES)
	$(CC) $(FLAGS) $(O_FILES) -o bin/pye -I./inc

.PHONY: lexical
lexical:
	flex cmp/pye.l
	@mv lex.yy.c src/

.PHONY: parser
parser:
	bison -d cmp/pye.y
	@mv cmp/pye.tab.c src/
	@mv cmp/pye.tab.h inc/

obj/%.o: src/%.c
	$(CC) $(FLAGS) -c $< -o $@ -I./inc

.PHONY: run
run:
	@cat in.py | bin/./pye

.PHONY: show
show:
	@cat out.py 

.PHONY: clean
clean: 
	rm -rf obj/*
	rm -rf bin/*

.PHONY: everything
everything:
	make clean
	make
	make run
	clear
	@make show