#.RECIPEPREFIX = A   <--- This is a comment used to remember... Ignore it...

CC = gcc
FLAGS = 

C_FILES = $(wildcard src/*.c)
O_FILES = $(patsubst src/%.c, obj/%.o, $(C_FILES))


all: bin/pye

bin/pye: cmp/pye.l cmp/pye.y $(O_FILES)
	$(CC) $(FLAGS) $(O_FILES) -o bin/pye -I./inc

cmp/pye.l: src/lex.yy.c
	flex cmp/pye.l
	@mv lex.yy.c src/

cmp/pye.y: src/pye.tab.c inc/pye.tab.h
	bison -d cmp/pye.y
	@mv pye.tab.c src/
	@mv pye.tab.h inc/

src/lex.yy.c:

src/pye.tab.c:

inc/pye.tab.h:

obj/%.o: src/%.c
	$(CC) $(FLAGS) -c $< -o $@ -I./inc	 

.PHONY: clean
clean: 
	rm -rf obj/*
	rm -rf bin/*