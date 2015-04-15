%{
#include "global.h"
#include "sintatico.h"
#include <stdlib.h>
%}
variable [a-z_][a-z0-9_]{2,30}
space [ ]+
tab [\t]+
%%

{space} return(SPACE)
{tab} return(TAB)
{variable} return(MESSAGE)
"\n" return(END)
%%

yywrap (){
return 0;
}
