#include "unity.h"
#include "Presenters.h"
#include "mock_ApplicationPresenter.h"

void setUp(void) {}

void tearDown(void) {}

void test_Presenters_RegisterForEvents_TellsAllPresentersToRegisterTheirEvents(void)
{
  ApplicationPresenter_RegisterEvents_Expect();

  Presenters_RegisterForEvents();
}
