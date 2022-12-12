/*
 *  Attribut.h
 *
 *  Module defining teh type of attributes in 
 *  symbol table.
 *
 */

#ifndef ATTRIBUT_H
#define ATTRIBUT_H

#include <stdio.h>

// signs
#define UP 1
#define DOWN -1

/**
 * Creates a counter for symbol values and increments it or decrements it depending on the sign
 */
int makenum(int sign);

/**
 * Creates a counter for function loading indexes and increments it or decrements it depending on the sign
 */
int makenumfun(int sign);



typedef int symb_value_type;
 /* Dummy definition of symbol_value_type.
    Could be instead a structure with as many fields
    as needed for the compiler such as:
    - name in source code
    - name (or position in the stack) in the target code
    - type (if ever)
    - other info....
 */

#ifndef BUFFER_SIZE
#define BUFFER_SIZE 100
#endif

#endif
