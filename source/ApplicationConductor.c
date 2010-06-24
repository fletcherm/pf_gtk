#include "types.h"
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
  int divisor = ApplicationHardware_GetDivisor();
  int dividend = ApplicationHardware_GetDividend();
  if (ApplicationModel_CheckArgs(divisor, dividend) == FALSE) {
    ApplicationHardware_ShowError();
    return;
  }
  int result = ApplicationModel_Divide(divisor,dividend);
  ApplicationHardware_HideError();
  ApplicationHardware_SetQuotient(result);
}
