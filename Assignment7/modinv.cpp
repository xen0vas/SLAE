/*
* Affine Cipher - Assignment 7
*
* Author: Xenofon Vassilakopoulos
*
* Student ID: SLAE-1314
*/

#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

// A method to find multiplicative inverse of
// 'a' under modulo 'm' 

int modInverse(int a, int m)
{
a = a % m;
for (int x=1; x<m; x++)
if ((a*x) % m == 1)
return x;
}

int main(int argc, char **argv)
{
int a = atoi(argv[1]);
int m = atoi(argv[2]);
cout << "\nDecryption Key is: "<< modInverse(a, m) << "\n\n";
return 0;
}
