#include "ApplicationModel.h"

void(*applicationStartsCallback)(void);

void ApplicationModel_WhenApplicationStarts(void(*callback)(void)) {
  applicationStartsCallback = callback;
}

void ApplicationModel_Run() {
  Conductors_RegisterForEvents();
  applicationStartsCallback();
}
