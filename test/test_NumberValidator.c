#include "unity.h"
#include "types.h"
#include "NumberValidator.h"

void setUp(void) {}
void tearDown(void) {}

void test_NumberValidator_IsNumber_AcceptsPositiveIntegers(void)
{
  TEST_ASSERT(NumberValidator_IsNumber("5"));
  TEST_ASSERT(NumberValidator_IsNumber("5555"));
  TEST_ASSERT(NumberValidator_IsNumber("93899393"));
}

void test_NumberValidator_IsNumber_AcceptsZero(void)
{
  TEST_ASSERT(NumberValidator_IsNumber("0"));
}

void test_NumberValidator_IsNumber_AcceptsNegativeIntegers(void)
{
  TEST_ASSERT(NumberValidator_IsNumber("-5"));
  TEST_ASSERT(NumberValidator_IsNumber("-5555"));
  TEST_ASSERT(NumberValidator_IsNumber("-93899393"));
}

void test_NumberValidator_IsNumber_AcceptsIntegersWithWhitespaceAroundThem(void)
{
  TEST_ASSERT(NumberValidator_IsNumber("  5"));
  TEST_ASSERT(NumberValidator_IsNumber(" 5555   "));
  TEST_ASSERT(NumberValidator_IsNumber(" \t 93899393 \t \t"));
}

void test_NumberValidator_IsNumber_DoesNotAcceptBlankString(void)
{
  TEST_ASSERT_FALSE(NumberValidator_IsNumber(""));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber(" "));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber(" \t\t "));
}

void test_NumberValidator_IsNumber_DoesNotAcceptNonNumbers(void)
{
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("-"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber(" -a"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("abc"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("a"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("100%"));
}

void test_NumberValidator_IsNumber_DoesNotAcceptFloatingPointNumbers(void)
{
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("1.0"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("-1.0"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("1.25"));
  TEST_ASSERT_FALSE(NumberValidator_IsNumber("0.830982"));
}
