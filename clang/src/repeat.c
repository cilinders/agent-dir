#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

char* repeat(char message[]) {
  return message;
}

int main(int argc, char **argv) {
  printf("%s", repeat(argv[1]));
  return(0);
}
