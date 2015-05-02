# CompiladorPye

For now, things are little messy. Just be patient.

If you want to check what pye can do for now, go to folder pye/cmp and do:

flex pye.l
bison -d pye.y
gcc -o pye lex.yy.c pye.tab.c
./pye input_file

You can input any file you want, as long you follow the following syntax:

a = b = c = 10; <--- a, b and are valuated with 10
a <--- prints a
a; b; c; <--- prints a, b and c
10 + a <--- prints 10 + a

So, if you want to put more than one command per line, use semicolons (;). 

I know it's pretty basic stuff, but the rush is coming soon.

Peace.