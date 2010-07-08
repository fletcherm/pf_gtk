#include "types.h"
#include "ApplicationModel.h"
#include "constants.h"
#include <stdio.h>

static void(*applicationStartsEvent)(void) = 0;
void ApplicationModel_WhenApplicationStarts(void(*callback)(void)) {
  applicationStartsEvent = callback;
}

int ApplicationModel_Run() {
  Presenters_RegisterForEvents();
  applicationStartsEvent();
}

int ApplicationModel_Divide(const char* dividend, const char* divisor) {
  return atoi(dividend) / atoi(divisor);
}

int ApplicationModel_ValidateArguments(const char* divisor, const char* dividend) {
  return (atoi(dividend) == 0) ? FALSE : TRUE;
}

int ApplicationModel_CheckArgumentFormat(const char* previouslyEnteredText, const char* newText) {
  char entireText[DIVISION_FIELD_SIZE];
  sprintf(entireText, "%s%s", previouslyEnteredText, newText);
  return NumberValidator_IsNumber(entireText);
}
