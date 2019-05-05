//CRISTHYAN DE MARCHENA.
%locations
%{
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
%}

//TOKENS THAT REPRESENT VALUES
%token ID
%token FLOAT
%token INTEGER

//TOKENS THAT REPRESENTS OPERATIONS
%token ASSIGN;
%token ADD
%token SUBTRACTION
%token MULTIPLICATION
%token DIVISION
%token MOD
%token POWER

//LINE TOKENS
%token NEXT_LINE
%token END

//INITIAL PROD:
%start INIT

%%

INIT:
	ID ASSIGN INTEGER OPTIONAL_OPS END OPTIONAL_LINES|
	ID ASSIGN FLOAT OPTIONAL_OPS END OPTIONAL_LINES|
	ID ASSIGN ID OPTIONAL_OPS END OPTIONAL_LINES
;

OPTIONAL_LINES: 
	ID ASSIGN INTEGER OPTIONAL_OPS END OPTIONAL_LINES|
	ID ASSIGN FLOAT OPTIONAL_OPS END OPTIONAL_LINES|
	ID ASSIGN ID OPTIONAL_OPS END OPTIONAL_LINES |
	/*EMPTY CHAR */
;

OPTIONAL_OPS:
	ACTION INTEGER OPTIONAL_OPS | 
	ACTION FLOAT OPTIONAL_OPS | 
	ACTION ID OPTIONAL_OPS |
	/* EMPTY CHAR */
;

ACTION:
	ADD |
	SUBTRACTION |
	MULTIPLICATION |
	DIVISION |
	MOD |
	POWER
;

%% 

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

void yyerror(char *s) {
  fprintf(stdout, "Error in line %d: %s\n", (yylineno-1), s);
}

int main(int argc, char *argv[]) {
	printf("Input: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *out_file = fopen("salida_lex.txt", "w"); // write only
	if (!fp) {
		fprintf(out_file,"\nNo se encuentra el archivo...\n");
		return(-1);
	}
	yyin = fp;
	yyout = out_file;
	yyparse();
	fclose(out_file);
	fclose(fp);
	return(0);
}
