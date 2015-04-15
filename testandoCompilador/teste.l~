%{
#include "global.h"
#include "sintatico.h"
#include <stdlib.h>
%}
shortDeclaration [a-z_][a-z0-9_]{0,3}
variable [a-z_][a-z0-9_]{2,30}
space [ \t]+
tab [\t]+
not .*
%%

{space} {/*Empty*/};
{tab} return(TAB);
{variable} {
yylval=atof(yytext);
return(MESSAGE);
}
{shortDeclaration} return (WARNING);
"\n" return(END);
{not} return(NOT);
%%

yywrap (){
return 0;
}
