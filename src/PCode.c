/*
 *  PCode.c
 * 
 *  Created by Janin on 12/11/21.
 *  Copyright 2021 ENSEIRB. All rights reserved.
 *
 */


#include "hdr/PCode.h"
#include <stdio.h>

int stack[SIZE];

int sp = 0; // première case libre
int fp = 0;   // indice de la valeur de retour de la fonction main


// test pile vide, pile pleine et pile valide (pour le debug ?)

int empty_stack () {
  return sp <= 0;  // sp == 0 when valid stack
}


int full_stack () {
  return sp >= SIZE;  // sp == SIZE when valid stack
}

int valid_stack (){
  return sp > 1 && sp <= SIZE;
}


// imprime la pile

void print_stack() {
  printf("\nBEGIN STACK : fp = %i, sp = %i\n",
	 fp, sp);
  int p = 0;
  while (p < sp) {
    printf ("(%i)  %i\n",p, stack[p]);
    p++;
  }
  printf("END STACK\n");  
}

