#include "types.h"
#include "ApplicationPresenter.h"
#include "ApplicationView.h"
#include "ApplicationModel.h"

void ApplicationPresenter_RegisterEvents() {
  ApplicationModel_WhenApplicationStarts(&ApplicationPresenter_ApplicationStartCallback);
  ApplicationView_WhenCalculateClicked(&ApplicationPresenter_CalculateClickedCallback);
  ApplicationView_WhenDivisorChanged(&ApplicationPresenter_DivisorChangedCallback);
  ApplicationView_WhenDividendChanged(&ApplicationPresenter_DividendChangedCallback);
}

void ApplicationPresenter_ApplicationStartCallback() {
  ApplicationView_Build();
  ApplicationView_Start();
}

void ApplicationPresenter_CalculateClickedCallback() {
  const char* divisor = ApplicationView_GetDivisor();
  const char* dividend = ApplicationView_GetDividend();
  if (ApplicationModel_CheckArgs(divisor, dividend) == FALSE) {
    ApplicationView_ShowError();
    return;
  }
  int result = ApplicationModel_Divide(divisor,dividend);
  ApplicationView_HideError();
  ApplicationView_SetQuotient(result);
}

void ApplicationPresenter_DivisorChangedCallback(char* new_text) {
  if (ApplicationModel_CheckArgFormat(ApplicationView_GetDivisor(), new_text) == FALSE)
    ApplicationView_UndoDivisorTextChange();
}

void ApplicationPresenter_DividendChangedCallback(char* new_text) {
  if (ApplicationModel_CheckArgFormat(ApplicationView_GetDividend(), new_text) == FALSE)
    ApplicationView_UndoDividendTextChange();
}
