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
EXPONENTE	[eE][+-]{NUMERO}
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
				
		}
{NUMERO}	{ fprintf(yyout, " INTEGER "); return INTEGER; }
{REAL}		{ fprintf(yyout, "cte-real= %s ", yytext); return FLOAT; }
"="		{ fprintf(yyout, " ASSIGN "); return ASSIGN; }
"+" 		{ fprintf(yyout, " ADD "); return ADD; }
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
";"		{ printf("!"); fprintf(yyout, " END\n "); return END; }
","		{ fprintf(yyout, "coma= , "); }
":"		{ fprintf(yyout, "punto-punto= : "); }
"\."		{ fprintf(yyout, "punto= ."); }
[ ]		;
"\n"		{ printf("KELLY\n"); fprintf(yyout, "\n"); ++_lineno; return NEXT_LINE; }
"\t"		{ fprintf(yyout, "\t"); }
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
