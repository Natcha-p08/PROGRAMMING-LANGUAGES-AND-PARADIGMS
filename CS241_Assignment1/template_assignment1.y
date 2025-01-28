%{
#include "template_assignment1.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node {
    char *name;
    struct node *next;
} NODE;

NODE *idents_list = NULL;
NODE *numbers_list = NULL;
NODE *operators_list = NULL;

void add_to_list(NODE **list, char *value);
void print_list(NODE *list, char *list_name);

int yylex();
int yyerror(char *s);
%}

%union {
    char *name;
    int number;
}

%token <name> IDENT
%token <number> NUMBER
%token PLUS MINUS MULTIPLY DIVIDE OP CP

%start exp

%% 

exp:
    term exp_prime
    ;

exp_prime:
      PLUS term { 
          add_to_list(&operators_list, "+"); 
      } exp_prime
    | MINUS term { 
          add_to_list(&operators_list, "-"); 
      } exp_prime
    | /* epsilon */
    ;

term:
    factor term_prime
    ;

term_prime:
      MULTIPLY factor { 
          if (operators_list == NULL || strcmp(operators_list->name, "*") != 0) {  
              add_to_list(&operators_list, "*");  
          }
      } term_prime
    | DIVIDE factor { 
          if (operators_list == NULL || strcmp(operators_list->name, "/") != 0) {  
              add_to_list(&operators_list, "/");  
          }
      } term_prime
    | /* epsilon */
    ;

factor:
    IDENT { 
        add_to_list(&idents_list, $1); 
    }
    | NUMBER { 
        char num_str[12]; 
        sprintf(num_str, "%d", $1); 
        add_to_list(&numbers_list, num_str); 5
    }
    | OP exp CP
    | MINUS NUMBER { 
        char num_str[12]; 
        sprintf(num_str, "-%d", $2);  
        add_to_list(&numbers_list, num_str); 
    }
    | MINUS IDENT { // เพิ่มเพื่อจัดการกรณี -IDENT
        char name_str[12]; 
        sprintf(name_str, "-%s", $2); 
        add_to_list(&idents_list, name_str); 
    }
    ;

%% 

int yyerror(char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
    return 0;
}

void add_to_list(NODE **list, char *value) {
    NODE *new_node = (NODE *)malloc(sizeof(NODE));
    if (new_node == NULL) {
        fprintf(stderr, "Memory allocation error\n");
        exit(1);
    }
    new_node->name = strdup(value);
    new_node->next = NULL;

    if (*list == NULL) {
        *list = new_node;
    } else {
        NODE *temp = *list;
        while (temp->next != NULL) {
            temp = temp->next;
        }
        temp->next = new_node;
    }
}

void print_list(NODE *list, char *list_name) {
    printf("%s: ", list_name);
    NODE *ptr = list;
    while (ptr) {
        printf("%s -> ", ptr->name);
        ptr = ptr->next;
    }
    printf("NULL\n");
}

int main() {
    if (yyparse() == 0) {
    print_list(idents_list, "Identifiers List");
    print_list(numbers_list, "Numbers List");
    print_list(operators_list, "Operators List");
    }
}
