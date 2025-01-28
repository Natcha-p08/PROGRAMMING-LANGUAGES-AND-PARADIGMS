%{
#include "template_assignment1.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void showError(const char *str);
%}

%option yylineno

%%


"+"            { return PLUS; }
"-"            { return MINUS; }
"*"            { return MULTIPLY; }
"/"            { return DIVIDE; }
"("            { return OP; }
")"            { return CP; }


0|[1-9][0-9]{0,3} {
    yylval.number = atoi(yytext); // Valid number between 0 and 9999
    printf("yytext = %s, yylval.number= %d\n", yytext, yylval.number);
    return NUMBER;
}

[0-9]{5,} {
    printf("Error: Number must be between 0 and 9999 and not exceed 4 digits. Your input = %s\n", yytext);
}


0[0-9]+ {
    showError("Error: Numbers starting with 0 are not allowed unless it is '0'.");
}

[a-zA-Z_$][a-zA-Z0-9_$]* {
    yylval.name = strdup(yytext); // Valid identifier
    printf("yytext = %s\n", yytext);
    return IDENT;
}

[0-9][a-zA-Z_$][a-zA-Z0-9_$]* {
    showError("Error: Identifiers must not start with a digit.");
}

. {
    printf("Error: Unknown character: %s\n", yytext);
}

%%

int yywrap() { return 1; }

void showError(const char *str) {
    fprintf(stderr, "%s\n", str);
}
