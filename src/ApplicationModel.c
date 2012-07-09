#include "types.h"
#include "bstrlib.h"
#include "ApplicationModel.h"

static simpleEvent applicationStartsEvent = 0;
void ApplicationModel_WhenApplicationStarts(void(*callback)(void)) {
  applicationStartsEvent = callback;
}

int ApplicationModel_Run() {
  applicationStartsEvent();
  return 0;
}

int ApplicationModel_Divide(const char* dividend, const char* divisor) {
  return atoi(dividend) / atoi(divisor);
}

int ApplicationModel_ValidateArguments(const char* divisor, const char* dividend) {
  return (atoi(dividend) == 0) ? FALSE : TRUE;
}

int ApplicationModel_CheckArgumentFormat(const char* previouslyEnteredText, const char* newText) {
  bstring combined = bfromcstr(previouslyEnteredText);
  bstring new = bfromcstr(newText);
  bconcat(combined, new);
  bdestroy(new);

  int textIsValid = NumberValidator_IsNumber(combined->data);
  bdestroy(combined);
  return textIsValid;
}
