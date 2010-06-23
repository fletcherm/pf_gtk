#include "ApplicationConductor.h"
#include "ApplicationModel.h"
#include <stdio.h>

void ApplicationConductor_RegisterEvents() {
  ApplicationModel_WhenApplicationStarts(&ApplicationConductor_ApplicationStartCallback);
  ApplicationHardware_WhenButtonClicked(&ApplicationConductor_ButtonClickedCallback);
}

void ApplicationConductor_ApplicationStartCallback() {
  ApplicationHardware_Build();
  ApplicationHardware_Start();
}

void ApplicationConductor_ButtonClickedCallback() {
  int square = ApplicationModel_ComputeSquare();
  printf("The square is [%d].\n", square);
}
