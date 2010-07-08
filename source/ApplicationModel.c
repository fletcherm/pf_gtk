#include "types.h"
#include "bstrlib.h"
#include "ApplicationModel.h"

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
  bstring combined, new;
  bconcat(combined = bfromcstr(previouslyEnteredText), new = bfromcstr(newText));
  bdestroy(new);

  int textIsValid = NumberValidator_IsNumber(combined->data);
  bdestroy(combined);
  return textIsValid;
}
