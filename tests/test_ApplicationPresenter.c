#include "types.h"
#include "unity.h"
#include "ApplicationPresenter.h"
#include "mock_ApplicationModel.h"
#include "mock_ApplicationView.h"

void setUp(void) {}
void tearDown(void) {}

void test_ApplicationPresenter_RegistersForEvents(void) {
  ApplicationModel_WhenApplicationStarts_Expect(&ApplicationPresenter_ApplicationStartCallback);
  ApplicationView_WhenCalculateClicked_Expect(&ApplicationPresenter_CalculateClickedCallback);
  ApplicationView_WhenDivisorChanged_Expect(&ApplicationPresenter_DivisorChangedCallback);
  ApplicationView_WhenDividendChanged_Expect(&ApplicationPresenter_DividendChangedCallback);

  ApplicationPresenter_RegisterEvents();
}

void test_ApplicationPresenter_InitializesTheApplicationAndStartsTheGui(void)
{
  ApplicationView_Build_Expect();
  ApplicationView_Start_Expect();

  ApplicationPresenter_ApplicationStartCallback();
}

void test_ApplicationPresenter_CalculatesTheQuotientWhenClicked() {
  ApplicationView_GetDivisor_ExpectAndReturn("21");
  ApplicationView_GetDividend_ExpectAndReturn("7");
  ApplicationModel_ValidateArguments_ExpectAndReturn("21", "7", TRUE);
  ApplicationModel_Divide_ExpectAndReturn("21", "7", 3);
  ApplicationView_HideError_Expect();
  ApplicationView_SetQuotient_Expect(3);

  ApplicationPresenter_CalculateClickedCallback();
}

void test_ApplicationPresenter_ShowsErrorWhenBadArgs() {
  ApplicationView_GetDivisor_ExpectAndReturn("21");
  ApplicationView_GetDividend_ExpectAndReturn("0");
  ApplicationModel_ValidateArguments_ExpectAndReturn("21", "0", FALSE);
  ApplicationView_ShowError_Expect();

  ApplicationPresenter_CalculateClickedCallback();
}

void test_ApplicationPresenter_AllowsNumbersToBeEnteredForTheDivisor() {
  ApplicationView_GetDivisor_ExpectAndReturn("21");
  ApplicationModel_CheckArgumentFormat_ExpectAndReturn("21", "3", TRUE);

  ApplicationPresenter_DivisorChangedCallback("3");
}

void test_ApplicationPresenter_DoesNotAllowNonNumbersToBeEnteredForTheDivisor() {
  ApplicationView_GetDivisor_ExpectAndReturn("21");
  ApplicationModel_CheckArgumentFormat_ExpectAndReturn("21", "j", FALSE);
  ApplicationView_UndoDivisorTextChange_Expect();

  ApplicationPresenter_DivisorChangedCallback("j");
}

void test_ApplicationPresenter_AllowsNumbersToBeEnteredForTheDividend() {
  ApplicationView_GetDividend_ExpectAndReturn("21");
  ApplicationModel_CheckArgumentFormat_ExpectAndReturn("21", "7", TRUE);

  ApplicationPresenter_DividendChangedCallback("7");
}

void test_ApplicationPresenter_DoesNotAllowNonNumbersToBeEnteredForTheDividend() {
  ApplicationView_GetDividend_ExpectAndReturn("21");
  ApplicationModel_CheckArgumentFormat_ExpectAndReturn("21", "rescue", FALSE);
  ApplicationView_UndoDividendTextChange_Expect();

  ApplicationPresenter_DividendChangedCallback("rescue");
}
