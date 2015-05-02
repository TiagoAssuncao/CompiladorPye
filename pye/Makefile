INCFOLDER := inc/
SRCFOLDER := src/
BINFOLDER := bin/
OBJFOLDER := obj/
CMPFOLDER := cmp/

CC := gcc

CSOURCES := $(wildcard $(SRCFOLDER)*.c)


all: flex_scanner pye.tab.c
	 $(CSOURCES:src/%.c=obj/%.o)
	 $(CC) obj/*.o -o $(BINFOLDER)$@ -I./inc

flex_scanner: bison_parser $(CMPFOLDER)pye.l
			  flex $(CMPFOLDER)pye.l

bison_parser: $(CMPFOLDER)pye.y
			  bison -d $(CMPFOLDER)pye.y

obj/%.o: src/%.c
		 $(CC) -c $< -o $@ -I./inc

clean: 
	   rm -rf $(OBJFOLDER)*
	   rm -rf $(BINFOLDER)*
