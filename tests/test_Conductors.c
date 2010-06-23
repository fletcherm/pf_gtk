#include "unity.h"
#include "Conductors.h"
#include "mock_ApplicationConductor.h"

void setUp(void) {}

void tearDown(void) {}

void test_Conductors_RegisterForEvents_TellsAllConductorsToRegisterTheirEvents(void)
{
  ApplicationConductor_RegisterEvents_Expect();

  Conductors_RegisterForEvents();
}
