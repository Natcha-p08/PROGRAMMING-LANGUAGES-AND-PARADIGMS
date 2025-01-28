%{
#include <stdio.h>
#include <stdlib.h>
int yylex();

void yyerror(char const *s){
    fprintf(stderr, "%s\n", s);
}
%}
%token NUMBER
%token END
%start line
%%
line: NUMBER END {printf("Parsed number: %d\n", $1);}
    ;
%%