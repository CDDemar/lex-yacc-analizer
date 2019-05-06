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

//UTIL TOKENS
%token JUMP
%token END
%token E_O_F

//ERROR TOKENS
%token L_ERROR

//INITIAL PROD:
%start INIT

%%

INIT	: ID_E ASSIGN INIT_P END_ANALIZER 
	| error ASSIGN INIT_P END_ANALIZER
	| ID_E error ASSIGN INIT_P END_ANALIZER
	| ID_E error INIT_P END_ANALIZER
	| ID_E ASSIGN error INIT_P END_ANALIZER 
	;

ID_E 	: ID
	| L_ERROR { fprintf(stdout, "Error in line %d\n", (lines_c)); }
	;

ASSIGN_E : ASSIGN
	 | error { fprintf(stdout, "Error in line %d\n", (lines_c)); }
	 ;

END_ANALIZER: E_O_F { exit(1); }

INIT_P: VAL OPT_OPS END LN_JUMPS OPT_LNS;

LN_JUMPS	: /* EMPTY CHAR */
		| JUMP LN_JUMPS { lines_c++; }
		;

VAL 	: ID
	| INTEGER
	| FLOAT
	;


OPT_OPS : OP VAL OPT_OPS
	| /* EMPTY CHAR */
	;

OP	: ADD
	| SUBTRACTION
	| MULTIPLICATION
	| DIVISION
	| POWER
	| MOD 
	;

OPT_LNS : ID_E ASSIGN_E INIT_P OPT_LNS
	| /* EMPTY CHAR */
	;

%% 

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern FILE *yyout;
extern int yylineno;

void yyerror(char *s) {
	fprintf(stdout, "Error in line %d: %s\n", (yylineno), s);
}

int main(int argc, char *argv[]) {
	printf("Input: %s\n", argv[1]);
	FILE *fp = fopen(argv[1], "r");
	FILE *lex_out_file = fopen("salida_lex.txt", "w"); // write only
	//FILE *yacc_out_file = open("salida_yacc.txt", "w"); // write only 
	if (!fp) {
		fprintf(lex_out_file,"\nNo se encuentra el archivo...\n");
		//fprintf(yacc_out_file,"\nNo se encuentra el archivo...\n");
		return(-1);
	}
	yyin = fp;
	yyout = lex_out_file;
	yyparse();
	fclose(lex_out_file);
	fclose(fp);
	//fclose(yacc_out_file);
	return(0);
}
