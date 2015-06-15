#.RECIPEPREFIX = A   <--- This is a comment used to remember... Ignore it...

CC = gcc
FLAGS = -Wall
CUNIT_INC_PATH = $$HOME/local/include
CUNIT_LIB_PATH = $$HOME/local/lib

TEST_FILES = $(wildcard test/*_test.c)

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
	@mv pye.tab.c src/
	@mv pye.tab.h inc/

obj/%.o: src/%.c
	$(CC) $(FLAGS) -c $< -o $@ -I./inc 

.PHONY: run
run:
	bin/./pye in.py out.py

.PHONY: show
show: 
	@cat out.py 

.PHONY: test
test:
	$(CC) $(FLAGS) $(TEST_FILES) $(C_FILES) -I$(CUNIT_INC_PATH) -I./inc -L$(CUNIT_LIB_PATH) -lcunit -o run_test
	LD_LIBRARY_PATH=$(CUNIT_LIB_PATH) ./run_test

.PHONY: clean
clean: 
	rm -rf obj/*
	rm -rf bin/*
	rm inc/pye.tab.h
	rm src/pye.tab.c
	rm src/lex.yy.c
	rm out.py

.PHONY: everything
everything:
	make clean
	make
	make run
	clear
	@make show