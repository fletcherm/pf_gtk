#include "ApplicationConductor.h"
#include "ApplicationModel.h"

void ApplicationConductor_RegisterEvents() {
  ApplicationModel_WhenApplicationStarts(&ApplicationConductor_ApplicationStartCallback);
  ApplicationHardware_WhenCalculateClicked(&ApplicationConductor_CalculateClickedCallback);
}

void ApplicationConductor_ApplicationStartCallback() {
  ApplicationHardware_Build();
  ApplicationHardware_Start();
}

void ApplicationConductor_CalculateClickedCallback() {
  int result = ApplicationModel_Divide(ApplicationHardware_GetDivisor(), ApplicationHardware_GetDividend());
  ApplicationHardware_SetQuotient(result);
}
