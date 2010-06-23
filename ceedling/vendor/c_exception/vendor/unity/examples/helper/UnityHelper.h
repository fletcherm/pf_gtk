#ifndef _TESTHELPER_H
#define _TESTHELPER_H

#include "Types.h"

void AssertEqualUintArray(const unsigned int* expected, const unsigned int* actual, const unsigned int length);
void AssertEqualIntArray(const int* expected, const int* actual, const unsigned int length);
void AssertEqualCharArray(const char expected[], const char actual[], const int length);
void AssertFloatArrayWithin(const float tolerance, const float* expected, const float* actual, const unsigned int length);
void AssertEqualExampleStruct(const EXAMPLE_STRUCT_T expected, const EXAMPLE_STRUCT_T actual);

#define TEST_ASSERT_EQUAL_uint32_ARRAY(expected, actual, length) {AssertEqualUintArray(expected, actual, length);}
#define TEST_ASSERT_EQUAL_INT_ARRAY(expected, actual, length) {AssertEqualIntArray(expected, actual, length);}
#define TEST_ASSERT_FLOAT_ARRAY_WITHIN(tolerance, expected, actual, length) {AssertFloatArrayWithin(tolerance, expected, actual, length);}
#define TEST_ASSERT_EQUAL_EXAMPLE_STRUCT_T(expected, actual) {AssertEqualExampleStruct(expected, actual);}

#endif // _TESTHELPER_H
