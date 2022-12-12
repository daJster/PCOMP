
%{

  // header included in y.tab.h
#include "../src/hdr/Attribut.h"  
#include "../src/hdr/Table_des_symboles.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE * file_in = NULL; // file with text to compile test.ml
FILE * file_out = NULL; // compiled file Pcode test.p
FILE * file_fn = NULL; // compiled file Pcode of functions test.fp
FILE* file_c = NULL; // c file to test our compiled Pcode
  
extern int yylex();
extern int yyparse();

void yyerror (char* s) {
   printf("\n%s\n",s);
 }

static int goto_n = 0; // cursor for the if then else jumps
%}

 
%union{
  int val_int; // integer value
  double val_fl; // float value
  char *val_str; // string value
  void *val_id; // sid value
  char *val_comp; // comparison value
} 

%token <val_fl> FLOAT

%token <val_id> ID

%token <val_int> NUM

%token <val_str> STRING

%token PV LPAR RPAR LET IN VIR

%token <val_int> IF THEN ELSE

%token <val_comp> ISLT 
%token <val_comp> ISGT  
%token <val_comp> ISLEQ 
%token <val_comp> ISGEQ 
%token <val_comp> ISEQ

/* TYPES */
%type <val_comp> comp
%type <val_int> if
%type <val_id> funcall_ID
%type <val_int> arg_list

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

prog : inst PV {}

| prog inst PV {}
;

/* a instruction is either a value or a definition (that indeed looks like an affectation) */

inst : let_def
| exp
;


let_def : def_id
| def_fun
;

/*Defining a variable*/
def_id : LET ID EQ exp {
    /*When finished reading the whole line we execute the following code*/
    int tmp = makenum(UP); // incrementing symbol table cursor
    push_symbol_value($2, tmp); // pushing the symbol read from ID ($ 2)
}
;

/*Defining a function*/
def_fun : LET fun_head EQ exp {
  /*When finished reading the whole line we execute the following code*/
  printf("return;\n}\n\n"); // closing the function code in test.fp
  makenumfun(DOWN); // resetting the function loading counter
  stdout = file_out; // redirecting the output to test.p
}
;

/*Head of a function (i.e f(x))*/
fun_head : ID LPAR id_list RPAR {
  /*When finished reading the whole line we execute the following code*/
  stdout = file_fn; // redirecting the output to test.fp
  printf("void call_%s(){\n", (char *)$1); // creating a void function containing the Pcode necessary to run it
  // $ 1 is here the name of the function given in test.p
}
;

/*id_list is the list of arguments when defining the function*/
id_list : ID { // case of one argument id
  int tmp = makenumfun(UP); // incrementing the function loading counter
  push_symbol_value($1, tmp); // pushing the symbol to locally store it in test.fp
}
| id_list VIR ID { // case of multiple argument id
  int tmp = makenumfun(UP); // same
  push_symbol_value($3, tmp); // same
}
// $ 3 and $ 1 are the sid of the id
;

/*exp is either an arithmetic expression or a let definition expression*/
exp : arith_exp
| let_exp
;

arith_exp : MOINS arith_exp %prec UNA 
  // Postfix arithmetic operations (i.e 1 2 +)
| arith_exp MOINS arith_exp {printf("SUBI;\n");} // Substraction of two expressions
| arith_exp PLUS arith_exp {printf("ADDI;\n"); } // Addition of two expressions 
| arith_exp DIV arith_exp  {printf("DIVI;\n"); } // Division of two expressions
| arith_exp MULT arith_exp {printf("MULTI;\n");} // Multiplication of two expressions
| arith_exp CONCAT arith_exp
| atom_exp {}
;

// Atomic expression
atom_exp : NUM {printf("LOADI (%i);\n", $1);} // Number
| FLOAT {printf("LOADI (%lf);\n", $1);} // Float
| STRING // String
| ID {
    printf("LOAD (fp + %d);\n", get_symbol_value($1)); //Loading id from symbol table
  }
| control_exp // if then else expression
| funcall_exp // function call expression
| LPAR exp RPAR // expression in parenthesis
;

control_exp : if_exp
;

/* IF CASES */
if_exp : if cond then atom_exp else atom_exp {printf("L%d:\n", $1 + 1);} // printing the exit labels when finishing the whole if then else expression
;

if : IF {$$ = goto_n; goto_n = goto_n + 2;} // for each if statement we anticipate how much lables we need, and that number is 2 labels for each if then else
cond : LPAR bool RPAR; // processing the boolean of if
then : THEN { 
  printf("IFN(L%d);\n", $<val_int>-1); // In case the boolean is false, following it with then instructions
  }
else : ELSE { 
  printf("GOTO(L%d);\n", $<val_int>-3 + 1); // closing the then statement with a goto to the exit label
  printf("L%d:\n", $<val_int>-3); // writing the label of else and following it with else code (case where boolean is true)
}

/* Local definitions */
let_exp : let_def IN arith_exp {printf("DRCP;\n"); pop_symbol();} // Copying the result and deleting the local variable
| let_def IN let_exp {printf("DRCP;\n"); pop_symbol();} // same
;

/*When calling a function*/
funcall_exp : funcall_ID LPAR arg_list RPAR {
  printf("CALL(call_%s);\n", (char *)$1); // calling the defined function
  printf("RESTORE(%d);\n", $3); // restoring the fp cursor position and deleting the loaded arguments
}

/* This jump is added in the grammar to save fp in the right moment*/
funcall_ID: ID {
  printf("SAVEFP;\n"); // saving fp on top of the stack in order to load the arguments in the stack
  $$ = $1; // saving the ID name in $ $ 
}

/*Arguments of a function when called upon*/
arg_list : arith_exp {$$ = 1;} // if there is only one argument when calling the function, we should be loading from fp + 1, and so $ $ should be 1
| arg_list VIR arith_exp {$$++;} // if there is more than one argument we increment in each loading of an argument
; 

/* true or false , the comparison is done in post fix (i.e 1 2 <)*/
bool : BOOL
| bool OR bool {printf("OR;\n");} // OR operator
| bool AND bool {printf("AND:\n");} // AND operator
| NOT bool %prec UNA {printf("NOT;\n");} // inverse of the boolean
| exp comp exp {printf("%s;\n", $2);} // $ 2 is the comparison value printed after loading the two expressions
| LPAR bool RPAR // boolean in parenthesis
;

/*Tokens of compraison*/
comp :  ISLT {$$ = $1;} // is less than
| ISGT {$$ = $1;} // is great than
| ISLEQ {$$ = $1;} // is less or equal
| ISGEQ {$$ = $1;} // is great or equal
| ISEQ {$$ = $1;} // is equal
/* $ $ is the value of comp, and $ 1 is the value of the comparison symbol*/
;

%% 
int main (int argc, char **argv) {
  /* The code below is just a standard usage example.
     Of cours, it can be changed at will.

     for instance, one could grab input and ouput file names 
     in command line arguements instead of having them hard coded */

  char name[BUFFER_SIZE];
  char tst_path[BUFFER_SIZE];
  strcpy(tst_path, "./tst/");

  if ( argc <= 1){
    printf("Invalid argument : You need a test file (.ml mandatory) in order to compile it\n example : ./myml test1.ml");
    return EXIT_FAILURE;
  } else {
    strcpy(name, strtok(argv[1], ".ml"));
  }

  /* opening target code file and redirecting stdout on it */
  strcat(name, ".p");
  file_out = fopen(name,"w");
  strcpy(name, strtok(name, ".p"));

  /* opening source code file and redirecting stdin from it */
  strcat(tst_path, argv[1]);
  strcat(tst_path,".ml");
  file_in = fopen(tst_path,"r");
  if (file_in == NULL){
    printf("Test doesn't exist or not found in the ./tst repository, please add you .ml file to tst repository in order to compile it\n");
    return EXIT_FAILURE;
  }

  /* opening source code file for functions and waiting for redirection during the compilation*/
  strcat(name, ".fp");
  file_fn = fopen(name, "w");
  strcpy(name, strtok(name, ".p"));
  /* As a starter, on may comment the above line for usual stdin as input */

  stderr = stdin;
  stdout = file_out; 
  stdin = file_in; 
  
  yyparse ();

  /* any open file shall be closed */
  fclose(file_out);
  fclose(file_in);
  fclose(file_fn);

  /*Free symbol table*/
  free_symbol_storage();

  /*Creating the test.c code*/
  strcat(name, ".c");
  file_c = fopen(name, "w");
  strcpy(name, strtok(name, ".c"));
  stdout = file_c;

  printf("#include <stdio.h>\n#include \"./src/hdr/PCode.h\"\n#include \"%s.fp\"\n\n", name);
  printf("int main(){\n\tprintf(\"Running %s .\\n\");\n\t#include \"%s.p\"\n\treturn 0;\n}", name, name);

  fclose(file_c);
  return EXIT_SUCCESS;
} 

