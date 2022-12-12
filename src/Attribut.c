/*
 *  Attribut.c
 *
 */

#include "hdr/Attribut.h"

/* HERE COMES YOUR CODE */



int makenum(int sign){
    static int counter = 0;
    if (sign >= 0){
        return counter++;
    } else {
        return --counter;
    }
}

int makenumfun(int sign){
    static int offun = 0;
    offun++;
    if (sign == DOWN){
        offun = 0;
    }
}

