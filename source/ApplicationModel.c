#include "ApplicationModel.h"

static void(*applicationStartsCallback)(void) = 0;
void ApplicationModel_WhenApplicationStarts(void(*callback)(void)) {
  applicationStartsCallback = callback;
}

int ApplicationModel_Run() {
  Conductors_RegisterForEvents();
  applicationStartsCallback();
}

int ApplicationModel_Divide(int dividend, int divisor) {
  return dividend / divisor;
}
