# CompiladorPye

For now, things are little messy. Just be patient.

If you want to check what pye can do for now, go to folder pye/ and do:

```
make
```

With that, the binary executable named pye will be available in the folder bin/.
Entering the folder, you just need to pass a file containing some syntax (that will be described below) as parameter to ./pye, like this:

```
./pye input_file
```

You can input any file you want, as long as you follow the following syntax:

```
a = b = c = 10; <--- a, b and c are valuated with 10.
a <--- prints a.
a; b; c; <--- prints a, b and c.
10 + a <--- prints 10 + a.
```

So, if you want to put more than one command per line, use semicolons (;). 

I know it's pretty basic stuff, but the rush is coming soon.

Peace.
