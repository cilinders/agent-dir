#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int respond(char message[]) {
  int length = strlen(message);
  return length;
}

int main(int argc, char **argv) {
  return respond(argv[1]);
}
