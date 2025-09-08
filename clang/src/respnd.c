#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int respond(char message[]) {
  srand(time(NULL));
  int N = 13;
  int random = rand() % N;
  return random;
}

int main(int argc, char **argv) {
  return respond(argv[1]);
}
