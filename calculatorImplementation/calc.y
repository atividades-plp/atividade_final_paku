/*
	Calculadora v.4 - Lê de arquivos ou linha de comando
	Jucimar Jr
*/

%{
#define YYSTYPE double
#include <stdio.h>
#include "hash_table.h"
extern FILE* yyin;
extern char* yytext;
extern int yyleng;

void yyerror(char *s);
int yylex(void);
int yyparse();
char name[100];

%}

%token NUMBER EOL
%token PLUS MINUS DIVIDE TIMES
%token P_LEFT P_RIGHT

%left PLUS MINUS
%left TIMES DIVIDE
%left P_LEFT P_RIGHT ATRIBUTION
%left VAR

%%

STATEMENT:
	STATEMENT EXPRESSION EOL {$$ = $2; printf("Resultado: %f\n", $2);}
	|
	;

EXPRESSION:
	NUMBER {$$ = $1;}
	|	EXPRESSION PLUS EXPRESSION {$$ = $1 + $3;}
	|	EXPRESSION MINUS EXPRESSION {$$ = $1 - $3;}
	|	EXPRESSION TIMES EXPRESSION {$$ = $1 * $3;}
	|	EXPRESSION DIVIDE EXPRESSION {$$ = $1 / $3;}
	|	P_LEFT EXPRESSION P_RIGHT {$$ = $2;}
    |   EXPRESSION PLUS EXPRESSION {$$ = $1 + $3;}
	|	EXPRESSION MINUS EXPRESSION {$$ = $1 - $3;}
	|	EXPRESSION TIMES EXPRESSION {$$ = $1 * $3;}
	|	EXPRESSION DIVIDE EXPRESSION {$$ = $1 / $3;}
    |   ATRIBUTION EXPRESSION {$$ = $2; store_value();}
	|   VAR { define_variable();}
	|
	;
%%

void yyerror(char *s)
{
	printf("Error: %s\n", s);
}

void define_variable()
{
    int i, start, end = 0;
	int e = 0;
	char nome[100], tipo[10];
	printf("Declaração: ");
	for (i = 0; i < yyleng; i++) {
		if (yytext[i] == ' ') start = i + 1;
			if (yytext[i] == ':') 
			{   
				end = i;
				continue;
			}
			if (end != 0)
			{
              tipo[e] = yytext[i];
			  e++;
			}
	}
	e = 0;
	printf("%s", tipo);
	for (i = start; i < end; i++) {
		nome[e] = yytext[i];
		e++;
		printf("%c", yytext[i]);
	}
	strcpy(name, nome);
	hash_insert(nome, tipo, 14);
	hash_print();
}

void store_value()
{
	int i, start, end;
	char valor[10];
	int e = 0;
	printf("Declaração: ");
	for (i = 0; i < yyleng; i++) {
		if (yytext[i] == '=') 
		{
		  start = i + 1;
		  break;
		}
	}
	for (i = start; i < yyleng; i++) {
		valor[e] = yytext[i];
		e++;
		printf("%c", yytext[i]);
	}
	
	printf("Valor atribuído é %s", valor);
	int val = hash_get(name);
	hash_update(name, 20);
	printf("O valor é %d\n", val);
	hash_print();
	printf("\n");
	
}

int main(int argc, char *argv[])
{
	vetor = (elem_hash*) malloc(max * sizeof(elem_hash));
    hash_initialize();
	
	if (argc == 1)
    {
		yyparse();
    }

	if (argc == 2)
	{
    	yyin = fopen(argv[1], "r");
		yyparse();
    }

	return 0;
}