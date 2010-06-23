#include "ApplicationConductor.h"
#include "ApplicationModel.h"

void ApplicationConductor_RegisterEvents() {
  ApplicationModel_WhenApplicationStarts(&ApplicationConductor_ApplicationStartCallback);
}

void ApplicationConductor_ApplicationStartCallback() {
  ApplicationHardware_Build();
  ApplicationHardware_Start();
}
