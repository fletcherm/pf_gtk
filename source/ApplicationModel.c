#include "ApplicationModel.h"

static void(*applicationStartsCallback)(void) = 0;
void ApplicationModel_WhenApplicationStarts(void(*callback)(void)) {
  applicationStartsCallback = callback;
}

int ApplicationModel_Run() {
  Conductors_RegisterForEvents();
  applicationStartsCallback();
}

int ApplicationModel_ComputeSquare() {
  return 9*9;
}
