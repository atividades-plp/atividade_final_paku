%{
#define YYSTYPE double
#include <stdio.h>
#include <string.h>

extern int yylineno;
extern char* yytext;

void yyerror(char* s);
int yylex();

int errors = 0;
int has_result = 0;
double result;

%}

%token NUMBER EOL
%token PLUS MINUS DIVIDE TIMES
%token P_LEFT P_RIGHT
%token VAR COLON REAL
%token NAME
%token INVALID_CHARACTER

%left PLUS MINUS
%left TIMES DIVIDE
%left P_LEFT P_RIGHT

%locations
%error-verbose

%%

statement:
    statement expression EOL {
        if (errors == 0) {
            result = $2;
            has_result = 1;
            printf("Resultado: %f\n", result);
        }
    }
    | variable_declaration EOL
    ;

expression:
    NUMBER {$$ = $1;}
    |   expression PLUS expression {$$ = $1 + $3;}
    |   expression MINUS expression {$$ = $1 - $3;}
    |   expression TIMES expression {$$ = $1 * $3;}
    |   expression DIVIDE expression {
            if ($3 == 0) {
                yyerror("division by zero");
            }
            else {
                $$ = $1 / $3;
            }
        }
    |   P_LEFT expression P_RIGHT {$$ = $2;}
    |   P_LEFT P_RIGHT {$$ = 0;}
    |   error INVALID_CHARACTER
    ;

variable_declaration:
    VAR NAME COLON REAL {
        printf("Variable declaration: %s\n", $2);
    }
    ;

%%

void yyerror(char* s)
{
    printf("Error: Line %d: %s\n", yylineno, s);
    errors++;
}

int main(int argc, char* argv[])
{
    if (argc == 1)
    {
        yyparse();
    }

    if (argc == 2)
    {
        FILE* f = fopen(argv[1], "r");

        printf("\nCompiling... %s\n", argv[1]);

        do {
            yyparse();
            if (errors == 0) {
                printf("Success!\n");
            }
            else {
                printf("\n%d error(s) found\n", errors);
                errors = 0;
            }
        } while (!feof(f));

        fclose(f);
    }

    return 0;
}
