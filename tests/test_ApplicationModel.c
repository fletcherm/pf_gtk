#include "types.h"
#include "unity.h"
#include "ApplicationModel.h"
#include "mock_Presenters.h"
#include "mock_NumberValidator.h"

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
  Presenters_RegisterForEvents_Expect();

  TEST_ASSERT(ApplicationModel_Run());
  TEST_ASSERT(application_starts_called);
}

void test_ApplicationModel_Divide_WithEvenNumbers()
{
  TEST_ASSERT_EQUAL(4, ApplicationModel_Divide("8", "2"));
  TEST_ASSERT_EQUAL(-2, ApplicationModel_Divide("-4", "2"));
  TEST_ASSERT_EQUAL(2, ApplicationModel_Divide("-8", "-4"));
  TEST_ASSERT_EQUAL(-3, ApplicationModel_Divide("9", "-3"));
}

void test_ApplicationModel_Divide_WithNonEvenNumber()
{
  TEST_ASSERT_EQUAL(4, ApplicationModel_Divide("9", "2"));
  TEST_ASSERT_EQUAL(-2, ApplicationModel_Divide("-5", "2"));
}

void test_ApplicationModel_ValidateArguments_ArgsAreOK()
{
  TEST_ASSERT(ApplicationModel_ValidateArguments("1", "1"));
  TEST_ASSERT(ApplicationModel_ValidateArguments("21", "1"));
  TEST_ASSERT(ApplicationModel_ValidateArguments("-9", "1"));
  TEST_ASSERT(ApplicationModel_ValidateArguments("-9", "-7777"));
}

void test_ApplicationModel_ValidateArguments_DividendIsZero()
{
  TEST_ASSERT_FALSE(ApplicationModel_ValidateArguments("-9", "0"));
}

void test_ApplicationModel_CheckArgumentFormat_IsOkWhenArgIsANumber() {
  NumberValidator_IsNumber_ExpectAndReturn("32122", TRUE);

  TEST_ASSERT(ApplicationModel_CheckArgumentFormat("321", "22"));
}

void test_ApplicationModel_CheckArgumentFormat_IsNotOkWhenArgIsNotANumber() {
  NumberValidator_IsNumber_ExpectAndReturn("evenflow", FALSE);

  TEST_ASSERT_FALSE(ApplicationModel_CheckArgumentFormat("even", "flow"));
}

void test_ApplicationModel_CheckArgumentFormat_DoesNotValidateArgThatIsTooLong() {
  TEST_IGNORE();
}
