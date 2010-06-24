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

  TEST_ASSERT(ApplicationModel_Run());
  TEST_ASSERT(application_starts_called);
}

void test_ApplicationModel_Divide_WithEvenNumbers()
{
  TEST_ASSERT_EQUAL(4, ApplicationModel_Divide(8, 2));
  TEST_ASSERT_EQUAL(-2, ApplicationModel_Divide(-4, 2));
  TEST_ASSERT_EQUAL(2, ApplicationModel_Divide(-8, -4));
  TEST_ASSERT_EQUAL(-3, ApplicationModel_Divide(9, -3));
}
