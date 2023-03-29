%{
/* C code */

#define YYSTYPE double
#include <stdio.h>
#include <string.h>

extern FILE* yyin;
extern int yylineno;
extern char *yytext;

void yyerror(char *s);
int yylex();
int yyparse();

int errors = 0;
int has_result = 0;
double result;

%}

%token NUMBER EOL
%token PLUS MINUS DIVIDE TIMES
%token P_LEFT P_RIGHT
%token INVALID_CHARACTER

%left PLUS MINUS
%left TIMES DIVIDE
%left P_LEFT P_RIGHT

%locations
%error-verbose

%%

STATEMENT:
    STATEMENT EXPRESSION EOL {
        if (errors == 0) {
            result = $2;
            has_result = 1;
            printf("Resultado: %f\n", result);
        }
    }
    |
    ;

EXPRESSION:
    NUMBER {$$ = $1;}
    |   EXPRESSION PLUS EXPRESSION {$$ = $1 + $3;}
    |   EXPRESSION MINUS EXPRESSION {$$ = $1 - $3;}
    |   EXPRESSION TIMES EXPRESSION {$$ = $1 * $3;}
    |   EXPRESSION DIVIDE EXPRESSION {
            if ($3 == 0) {
                yyerror("division by zero");
            }
            else {
                $$ = $1 / $3;
            }
        }
    |   P_LEFT EXPRESSION P_RIGHT {$$ = $2;}
    |   P_LEFT P_RIGHT {$$ = 0;}
    |   error INVALID_CHARACTER
    ;

%%

void yyerror(char *s)
{
    printf("Error: Line: %d  Msg:%s\n", yylineno, s);
    errors++;
}

int main(int argc, char *argv[])
{
    if (argc == 1)
    {
        yyparse();
    }

    if (argc == 2)
    {
        yyin = fopen(argv[1], "r");

        printf("\nCompiling ... %s\n\n", argv[1]);

        do{ yyparse();
            if (errors == 0) {
                printf("Success!\n");
            }
            else {
                printf("\n%d error(s) found\n", errors);
                errors = 0;
            }
        } while (!feof(yyin));

        fclose(yyin);

    return 0;
}
}
