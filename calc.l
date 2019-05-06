%option noyywrap
%option yylineno
%{
#include<stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

int _lineno = 1;
int token_count = 0;
char tokens[10000];
int err_count = 0;
char errs[100000];
%}

DIGITO		[0-9]
LETRA		[a-zA-Z]
ALFA		{LETRA}|{DIGITO}
NUMERO		-?{DIGITO}+
EXPONENTE	[eE][-+]{NUMERO}
REAL		{NUMERO}(.{NUMERO}{EXPONENTE}?)?
ID		{LETRA}{ALFA}*
NoID		({DIGITO}|{NUMERO}|{REAL}|{EXPONENTE}){ID}
%%
{NoID}		{
			
			char str[12];
			sprintf(str, "%d", _lineno);
			char* result = malloc(strlen("\tERROR EN LINEA ") +strlen(str) +strlen(", EN ") +strlen(yytext) +strlen("\n") +1);
			strcpy(result, "\tERROR EN LINEA ");
			strcat(result, str);
			strcat(result, ", EN ");
			strcat(result, yytext);
			strcat(result, "\n");
			strcat(errs, result);
			err_count++;		
			++_lineno; 
			fprintf(yyout, " L_ERROR ");
			return L_ERROR;
				
		}
{NUMERO}	{ fprintf(yyout, " %s ", yytext); return INTEGER; }
{REAL}		{ fprintf(yyout, " %s ", yytext); return FLOAT; }
"="		{ fprintf(yyout, " = "); return ASSIGN; }
"+" 		{ fprintf(yyout, " + "); return ADD; }
"-" 		{ fprintf(yyout, "op-sust= - "); return SUBTRACTION; }
"*" 		{ fprintf(yyout, "op-mult= * "); return MULTIPLICATION; }
"/" 		{ fprintf(yyout, "op-div= / "); return DIVISION; }
"\%"		{ fprintf(yyout, "op-mod= %% "); return MOD; }
"^" 		{ fprintf(yyout, "op-exp= ^ "); return POWER; }
{ID}		{ 
			fprintf(yyout, " ID ");			
			char *result = malloc(strlen("ID: ") +strlen(yytext) +strlen(";  ") +1);
			strcpy(result, "ID: ");
			strcat(result, yytext);
			strcat(result, ";  ");
			if(!strstr(tokens, result)){
				strcat(tokens, result);	
				token_count++;	
			}
			return ID;
		}
";"		{ printf("!"); fprintf(yyout, " ; "); return END; }
","		{ fprintf(yyout, "coma= , "); }
":"		{ fprintf(yyout, "punto-punto= : "); }
"\."		{ fprintf(yyout, "punto= ."); }
[ ]		;
"\n"		{ printf("?\n"); fprintf(yyout, " JUMP\n"); ++_lineno; return JUMP; }
"\t"		{ fprintf(yyout, "\t"); }
<<EOF>>		{ fprintf(yyout, " E_O_F "); return E_O_F; }
.		{ 
			char str[12];
			sprintf(str, "%d", _lineno);
			char* result = malloc(strlen("\tERROR EN LINEA ") +strlen(str) +strlen(", EN ") +strlen(yytext) +strlen("\n") +1);
			strcpy(result, "\tERROR EN LINEA ");
			strcat(result, str);
			strcat(result, ", EN ");
			strcat(result, yytext);
			strcat(result, "\n");
			strcat(errs, result);
			err_count++;		
			++_lineno; 
		}
%%
