#include <stdio.h>
#include <stdlib.h>
#include "test.h"

int example(alpm_list_t **list) {
	if (list==NULL)
		printf("lista vuota");
	else {
		
		*list=(alpm_list_t *)malloc(sizeof(alpm_list_t));
		(*list)->a=5;
	}
	return (*list)->a;
}

int main() {
	alpm_list_t *prova;
	example(&prova);
	printf("%d",prova->a);
}
