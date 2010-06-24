#include "types.h"
#include "unity.h"
#include "ApplicationConductor.h"
#include "mock_ApplicationModel.h"
#include "mock_ApplicationHardware.h"

void setUp(void) {}
void tearDown(void) {}

void test_ApplicationConductor_RegistersForEvents(void) {
  ApplicationModel_WhenApplicationStarts_Expect(&ApplicationConductor_ApplicationStartCallback);
  ApplicationHardware_WhenCalculateClicked_Expect(&ApplicationConductor_CalculateClickedCallback);

  ApplicationConductor_RegisterEvents();
}

void test_ApplicationConductor_InitializesTheApplicationAndStartsTheGui(void)
{
  ApplicationHardware_Build_Expect();
  ApplicationHardware_Start_Expect();

  ApplicationConductor_ApplicationStartCallback();
}

void test_ApplicationConductor_CalculatesTheQuotientWhenClicked() {
  ApplicationHardware_GetDivisor_ExpectAndReturn("21");
  ApplicationHardware_GetDividend_ExpectAndReturn("7");
  ApplicationModel_CheckArgs_ExpectAndReturn("21", "7", TRUE);
  ApplicationModel_Divide_ExpectAndReturn("21", "7", 3);
  ApplicationHardware_HideError_Expect();
  ApplicationHardware_SetQuotient_Expect(3);

  ApplicationConductor_CalculateClickedCallback();
}

void test_ApplicationConductor_ShowsErrorWhenBadArgs() {
  ApplicationHardware_GetDivisor_ExpectAndReturn("21");
  ApplicationHardware_GetDividend_ExpectAndReturn("0");
  ApplicationModel_CheckArgs_ExpectAndReturn("21", "0", FALSE);
  ApplicationHardware_ShowError_Expect();

  ApplicationConductor_CalculateClickedCallback();
}

void test_ApplicationConductor_AllowsNumbersToBeEntered() {
  TEST_IGNORE();
}

void test_ApplicationConductor_DoesNotAllowNonNumbersToBeEntered() {
  TEST_IGNORE();
}
