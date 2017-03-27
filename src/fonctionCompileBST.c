#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <errno.h>
#include <assert.h>
#include <string.h>

void calculProba(int n, float tab_proba[], int dico[]){
  int s = 0 ;
  for(int i = 0; i < n; i++){
    s = s + dico[i];
  }
  for(int i = 0; i < n; i++){
    tab_proba[i] = dico[i] / (float)s ;
  }
  return;
}


// void main(){
//   float tab_proba[3];
//   int dico[3] = { 1, 2, 3};
//   calculProba(3,tab_proba,dico);
//   for(int i = 0; i<3; i++){
//     printf("proba = %f , dico = %d ", tab_proba[i], dico[i] );
//   }
// }
