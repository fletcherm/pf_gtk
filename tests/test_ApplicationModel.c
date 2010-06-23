#include "types.h"
#include "unity.h"
#include "ApplicationModel.h"
#include "mock_Conductors.h"

bool application_starts_called;

void setUp(void) {
  application_starts_called = FALSE;
}

void tearDown(void) {}

void application_starts(void) {
  application_starts_called = TRUE;
}

void test_ApplicationModel_StartsTheApplication(void)
{
  ApplicationModel_WhenApplicationStarts(&application_starts);
  Conductors_RegisterForEvents_Expect();

  ApplicationModel_Run();
  TEST_ASSERT(application_starts_called);
}
