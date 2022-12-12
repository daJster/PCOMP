/*
 *  PCode.h
 * 
 *  Created by Janin on 12/11/21.
 *  Copyright 2021 ENSEIRB. All rights reserved.
 *
 *  La pile de PCode est codée comme un tableau C.
 *  Les "adresses" de PCode sont alors codées comme des indices
 *  dans ce tableau. Autrement dit, on évite, pour la beauté du geste,
 *  d'utiliser explicitement les pointeurs C.
 *  Bien sur stack[k] c'est la même chose que *(stack+k)...
 */


#ifndef PCODE_H
#define PCODE_H

#define SIZE 100


extern int stack[SIZE];

extern int sp;
     // Stack pointeur (ou index) qui pointe toujours sur la première
     // case LIBRE.
     // On empile en incrémentant sp
     // On dépile en le décrémentant

extern int fp;
     // Frame pointeur : un pointeur (ou index) qui marque une position fixe,
     // sur la pile, à partir de laquelle on peut retrouver les données
     // (paramètres, variables locales) propres au bloc courant.


/*************************************************/
// Instructions P-CODE, définit comme des macros C

/********** Empiler / depiler un entier ***************/

// empiler
#define LOADI(X)  stack[sp++] = X;

#define LOAD(P)   stack[sp++] = stack[P];
  // post-incrémentation !! sp pointe sur la première case vide.

// depiler
#define DROP --sp; 

// depiler en copiant ur l'avant dernier dans la pile
#define DRCP stack[sp-2] = stack[sp-1]; sp--;

// stocker (utile ?)
#define STORE(P)  stack[P] = stack[sp-1];
  // pre-décrémentation !! sp pointe sur la première case vide

/*********** Opérations arithmetiques entières binaires *********/

/* On dépile, on effectue le calcul
   on rempile le résultat.

   On peut ajouter des fonctions binaires de PCode si besoin.
   Ex : ==
*/

#define ADDI stack[sp - 2] = stack[sp - 2] + stack[sp - 1]; sp--;

#define MULTI stack[sp - 2] = stack[sp - 2] * stack[sp - 1]; sp--;

#define SUBI stack[sp - 2] = stack[sp - 2] - stack[sp - 1]; sp--;

#define DIVI stack[sp - 2] = stack[sp - 2] / stack[sp - 1]; sp--;

/*********** Opérations arithmetiques entières binaires *********/

#define LT stack[sp - 2] = (stack[sp - 2] < stack[sp - 1]); sp--;
#define GT stack[sp - 2] = (stack[sp - 2] > stack[sp - 1]); sp--;
#define LEQ stack[sp - 2] = (stack[sp - 2] <= stack[sp - 1]); sp--;
#define GEQ stack[sp - 2] = (stack[sp - 2] >= stack[sp - 1]); sp--;
#define EQ stack[sp - 2] = (stack[sp - 2] == stack[sp - 1]); sp--;

/*********** Opérations booléennes *********/

#define OR stack[sp - 2] = stack[sp - 2] || stack[sp - 1]; sp--;
#define AND stack[sp - 2] = stack[sp - 2] && stack[sp - 1]; sp--;
#define NOT stack[sp - 1] = ! stack[sp - 1];


/*************************** Branchements ******************/
// La condition est en sommet de pile.
// Elle est toujours dépilée.

      // branchement conditionel
#define IFT(L) if (stack[--sp]) goto L;

      // branchement conditionel avec negation
#define IFN(L) if (!(stack[--sp])) goto L;

      // branchement inconditionel
#define GOTO(L) goto L;

/*****************  NOP ************************************/

#define NOP 

/*********** Gestion de la pile pour appel de fonctions *********/

// sauvegarde de fp en sommet de pile
#define SAVEFP stack[sp] = fp; fp = sp++;

// retore fp (stocké à l'index fp + 0)
// dépile n+2 éléments puis recharge le sommet de pile
#define RESTORE(n) fp = stack[fp]; stack[sp-(n+2)] = stack[sp-1]; sp=sp-(n+1);

// sauvegarde fp et appel de la fonction (sans arguement)
#define CALL(L) L();

/***************************************************/
/* Autres fonctions pour le debug */

int empty_stack ();

int full_stack ();

int valid_stack ();

void print_stack();


#endif

