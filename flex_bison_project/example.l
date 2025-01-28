%{
#include "example.tab.h"
%}

%option noyywrap

%%
[0-9]+ {yylval = atoi(yytext); return NUMBER;}
\n {return END;}
. {return yytext[0];}
%%