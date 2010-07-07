#include "types.h"
#include "ApplicationConductor.h"
#include "ApplicationHardware.h"
#include "ApplicationModel.h"

void ApplicationConductor_RegisterEvents() {
  ApplicationModel_WhenApplicationStarts(&ApplicationConductor_ApplicationStartCallback);
  ApplicationHardware_WhenCalculateClicked(&ApplicationConductor_CalculateClickedCallback);
  ApplicationHardware_WhenDivisorChanged(&ApplicationConductor_DivisorChangedCallback);
  ApplicationHardware_WhenDividendChanged(&ApplicationConductor_DividendChangedCallback);
}

void ApplicationConductor_ApplicationStartCallback() {
  ApplicationHardware_Build();
  ApplicationHardware_Start();
}

void ApplicationConductor_CalculateClickedCallback() {
  const char* divisor = ApplicationHardware_GetDivisor();
  const char* dividend = ApplicationHardware_GetDividend();
  if (ApplicationModel_CheckArgs(divisor, dividend) == FALSE) {
    ApplicationHardware_ShowError();
    return;
  }
  int result = ApplicationModel_Divide(divisor,dividend);
  ApplicationHardware_HideError();
  ApplicationHardware_SetQuotient(result);
}

void ApplicationConductor_DivisorChangedCallback(char* new_text) {
  if (ApplicationModel_CheckArgFormat(ApplicationHardware_GetDivisor(), new_text) == FALSE)
    ApplicationHardware_UndoDivisorTextChange();
}

void ApplicationConductor_DividendChangedCallback(char* new_text) {
  if (ApplicationModel_CheckArgFormat(ApplicationHardware_GetDividend(), new_text) == FALSE)
    ApplicationHardware_UndoDividendTextChange();
}
