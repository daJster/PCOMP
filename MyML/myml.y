
%{

  // header included in y.tab.h
#include "Attribut.h"  
#include "Table_des_symboles.h"
#include <stdio.h>

FILE * file_in = NULL;
FILE * file_out = NULL;
  
extern int yylex();
extern int yyparse();

void yyerror (char* s) {
   printf("\n%s\n",s);
 }

%}


%token NUM FLOAT ID STRING

%token PV LPAR RPAR LET IN VIR

%token IF THEN ELSE

%token ISLT ISGT ISLEQ ISGEQ ISEQ
%left ISEQ
%left ISLT ISGT ISLEQ ISGEQ


%token AND OR NOT BOOL
%left OR
%left AND



%token PLUS MOINS MULT DIV EQ
%left PLUS MOINS
%left MULT DIV
%left CONCAT
%nonassoc UNA    /* pseudo token pour assurer une priorite locale */


%start prog 
 


%%

 /* a program is a list of instruction */

prog : inst PV {printf("Une instruction\n");}

| prog inst PV {printf("Une autre instruction\n");}
;

/* a instruction is either a value or a definition (that indeed looks like an affectation) */

inst : let_def
| exp
;



let_def : def_id
| def_fun
;

def_id : LET ID EQ exp  {printf("Une définition d'ID\n");}
;

def_fun : LET fun_head EQ exp {printf("Une définition de fonction\n");}
;

fun_head : ID LPAR id_list RPAR 
;

id_list : ID
| id_list VIR ID
;


exp : arith_exp
| let_exp
;

arith_exp : MOINS arith_exp %prec UNA
| arith_exp MOINS arith_exp
| arith_exp PLUS arith_exp
| arith_exp DIV arith_exp
| arith_exp MULT arith_exp
| arith_exp CONCAT arith_exp
| atom_exp
;

atom_exp : NUM
| FLOAT
| STRING
| ID
| control_exp
| funcall_exp
| LPAR exp RPAR
;

control_exp : if_exp
;


if_exp : if cond then atom_exp else atom_exp 
;

if : IF;
cond : LPAR bool RPAR;
then : THEN;
else : ELSE;


let_exp : let_def IN atom_exp 
| let_def IN let_exp
;

funcall_exp : ID LPAR arg_list RPAR
;

arg_list : arith_exp
| arg_list VIR  arith_exp
;

bool : BOOL
| bool OR bool
| bool AND bool
| NOT bool %prec UNA 
| exp comp exp
| LPAR bool RPAR
;


comp :  ISLT | ISGT | ISLEQ | ISGEQ | ISEQ
;

%% 
int main () {
  /* The code below is just a standard usage example.
     Of cours, it can be changed at will.

     for instance, one could grab input and ouput file names 
     in command line arguements instead of having them hard coded */

  stderr = stdin;
  
  /* opening target code file and redirecting stdout on it */
 file_out = fopen("test.p","w");
 stdout = file_out; 

 /* openng source code file and redirecting stdin from it */
 file_in = fopen("test.ml","r");
 stdin = file_in; 

 /* As a starter, on may comment the above line for usual stdin as input */
 
 yyparse ();

 /* any open file shall be closed */
 fclose(file_out);
 fclose(file_in);
 
 return 1;
} 

