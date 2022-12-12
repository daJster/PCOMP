/*
 *  Table des chaines.c
 *
 *  Created by Janin on 12/10/10.
 *  Copyright 2010 LaBRI. All rights reserved.
 *
 */

#include "hdr/Table_des_chaines.h"
#include <stdlib.h>
#include <string.h>

/* good old string copy function with malloc */

char * string_copy(char *s) {
	if (!s) return NULL;
	char * sc = malloc(strlen(s)*sizeof(char));
	return strcpy(sc, s);
}

/* The storage structure is implemented as a linked chain.
   A more efficient structure would be (why so ?) a hash table  */

/* linked element def */

typedef struct elem {
	char * value;
	struct elem * next;
} elem;

/* linked chain initial element */
static elem * storage = NULL;

/* insert a string into the storage structure giving back its (unique) id */
sid string_to_sid(char * s) {

	elem * tracker;

	/* check s is a real string */
	if (!s) return NULL;
	
	
	/* look for the presence of s in storage  and returns its copy if there */
	
	tracker = storage;
	while (tracker) {
		if (!strcmp(tracker->value, s)) return tracker->value;
		tracker = tracker -> next;
	}
	
	/* otherwise insert it at head of storage */
	
	tracker = malloc(sizeof(elem));
	tracker -> value = string_copy(s);
	tracker -> next = storage;
	storage = tracker;
	return storage -> value;
}

/* get sid without inserting it in storage*/
sid get_sid(char *s){
	
	elem * tracker;

	/* check s is a real string */
	if (!s) return NULL;
	
	
	/* look for the presence of s in storage  and returns its copy if there */
	
	tracker = storage;
	while (tracker) {
		if (!strcmp(tracker->value, s)) return tracker->value;
		tracker = tracker -> next;
	}

	return NULL;
}

/* check the validity of an sid as being present in the strorage structure */
int sid_valid(sid i) {
	elem * tracker = storage;
	while (tracker) {
		if (tracker->value == i) return 0;
		tracker=tracker->next;
	}
	return -1;
}

/* retreiving (already inserted) string value associated to a given sid */
char * sid_to_string(sid i) {
	/* for debug purpose */
	if (sid_valid(i) == -1) return NULL;
	
	return (char *) i;
}

/* retrieve sid value from offset*/
// sid offset_to_sid(int offset){
// 	elem * tracker=storage;
// 	while (tracker) {
// 		if (tracker->offset == offset) return tracker -> value;
// 		tracker=tracker->next;
// 	}

// 	return NULL;
// }

void print_storage(){
	printf("\nChaîne storage :\n");
	elem * tracker = storage;
	int i = 0;
	while (tracker) {
		printf("[%d] : %s\n", i, tracker->value);
		tracker=tracker->next;
		i++;
	}
}
