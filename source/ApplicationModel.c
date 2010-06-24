#include <stdlib.h>
#include "types.h"
#include "ApplicationModel.h"

static void(*applicationStartsEvent)(void) = 0;
void ApplicationModel_WhenApplicationStarts(void(*callback)(void)) {
  applicationStartsEvent = callback;
}

int ApplicationModel_Run() {
  Conductors_RegisterForEvents();
  applicationStartsEvent();
}

int ApplicationModel_Divide(char* dividend, char* divisor) {
  return atoi(dividend) / atoi(divisor);
}

int ApplicationModel_CheckArgs(char* divisor, char* dividend) {
  return (atoi(dividend) == 0) ? FALSE : TRUE;
}
