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

void test_ApplicationModel_Divide_WithNonEvenNumber()
{
  TEST_IGNORE();
}

void test_ApplicationModel_CheckArgs_ArgsAreOK()
{
  TEST_ASSERT(ApplicationModel_CheckArgs(1, 1));
  TEST_ASSERT(ApplicationModel_CheckArgs(21, 1));
  TEST_ASSERT(ApplicationModel_CheckArgs(-9, 1));
  TEST_ASSERT(ApplicationModel_CheckArgs(-9, -7777));
}

void test_ApplicationModel_CheckArgs_DividendIsZero()
{
  TEST_ASSERT_EQUAL(FALSE, ApplicationModel_CheckArgs(-9, 0));
}
