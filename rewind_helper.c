#include <stdlib.h>

// Compile with: gcc -Wall -o rewind_helper rewind_helper.c

int main(void) {
  // Make sure rewind_helper.sh and rewind_helper are in this directory:
  int status = system("/usr/local/bin/rewind_helper/rewind_helper.sh");
  int ret = WEXITSTATUS(status);
  return ret;
}