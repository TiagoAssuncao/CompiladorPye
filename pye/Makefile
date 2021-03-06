#.RECIPEPREFIX = A   <--- This is a comment used to remember... Ignore it...

CC = gcc
FLAGS = 

CUNIT_INC_PATH = $$HOME/local/include
CUNIT_LIB_PATH = $$HOME/local/lib

C_FILES = $(wildcard src/*.c)
O_FILES = $(patsubst src/%.c, obj/%.o, $(C_FILES))
TEST_FILES = ./src/linked_list.c ./src/debugger.c ./src/mathematics.c ./src/stack.c 


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

.PHONY: test
test: 
	$(CC) $(FLAGS) ./test/linked_list_test.c $(TEST_FILES) -I$(CUNIT_INC_PATH) -I./inc -L$(CUNIT_LIB_PATH) -lcunit -o run_test
	LD_LIBRARY_PATH=$(CUNIT_LIB_PATH) ./run_test
	rm run_test

	$(CC) $(FLAGS) ./test/pye_out_test.c $(TEST_FILES) -I$(CUNIT_INC_PATH) -I./inc -L$(CUNIT_LIB_PATH) -lcunit -o run_pye_out_test
	LD_LIBRARY_PATH=$(CUNIT_LIB_PATH) ./run_pye_out_test
	rm run_pye_out_test	

	$(CC) $(FLAGS) ./test/stack_test.c $(TEST_FILES) -I$(CUNIT_INC_PATH) -I./inc -L$(CUNIT_LIB_PATH) -lcunit -o run_stack_test
	LD_LIBRARY_PATH=$(CUNIT_LIB_PATH) ./run_stack_test
	rm run_stack_test

	$(CC) $(FLAGS) ./test/mathematics_test.c $(TEST_FILES) -I$(CUNIT_INC_PATH) -I./inc -L$(CUNIT_LIB_PATH) -lcunit -o run_mathematics_test
	LD_LIBRARY_PATH=$(CUNIT_LIB_PATH) ./run_mathematics_test
	rm run_mathematics_test