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

void test_ApplicationConductor_CalculatesTheSquareWhenTheButtonIsClicked() {
  ApplicationModel_ComputeSquare_ExpectAndReturn(25);

  ApplicationConductor_CalculateClickedCallback();
}
