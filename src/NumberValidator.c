#include <pcre.h>
#include <string.h>
#include "types.h"
#include "NumberValidator.h"

int NumberValidator_IsNumber(const char* possibleNumber) {
  const char* error;
  int errorOffset;
  pcre *re = pcre_compile("^\\s*-{0,1}\\d+\\s*$", 0, &error, &errorOffset, NULL);
  int rc = pcre_exec(re, NULL, possibleNumber, strlen(possibleNumber), 0, 0, NULL, 0);
  pcre_free(re);

  return !(rc == PCRE_ERROR_NOMATCH);
}
