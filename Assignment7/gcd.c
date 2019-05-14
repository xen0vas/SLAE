/*
* Affine Cipher - Assignment 7
*
* Author: Xenofon Vassilakopoulos
*
* Student ID: SLAE-1314
*/

#include <stdio.h>  

// Recursive function to return gcd of a and b 
int gcd(int a, int b)
{
  // check for 0 values
  if (a == 0)
     return b;
  if (b == 0)
     return 0;
  if (a == b)
     return a;
  if (a > b)
     return gcd(a-b, b);
  return gcd(a, b-a);
}

int main()
{  
int res = 0;
int i;        
for ( i = 1; i<129; i++)
{
    res = gcd(i, 128);
    if (res == 1)
      printf("%d, ", i);
}
return 0;
}
