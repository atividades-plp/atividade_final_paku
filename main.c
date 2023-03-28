#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include <limits.h>
#include "hash_table.h"

int main(void) {
  int x, y, z;
  
  vetor = (elem_hash*) malloc(max * sizeof(elem_hash));
  Inicializar_vet();
  
  hash_insert("rock", "int", 10);
  hash_insert("samba", "int", 50);
  hash_insert("reggae", "int", 10);
  hash_insert("pop", "int", 38);
  hash_insert("lambada", "int", 1000);
  hash_print();
  hash_update("samba", 15);
  hash_print();
  x = hash_get("rock");
  y = hash_get("reggae");
  z = x + y;
  
  hash_update("reggae", z);
  printf("reggae é %d\n", hash_get("reggae"));
  hash_print();
 
  free(vetor);
  
}
