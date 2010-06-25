#ifndef _APPLICATION_HARDWARE_
#define _APPLICATION_HARDWARE_

void ApplicationHardware_WhenCalculateClicked(void(*callback)(void));
void ApplicationHardware_WhenTextChanged(void(*callback)(void));

void ApplicationHardware_Build();
void ApplicationHardware_Start();
const char* ApplicationHardware_GetDivisor();
const char* ApplicationHardware_GetDividend();
void ApplicationHardware_SetQuotient(int);
void ApplicationHardware_HideError();
void ApplicationHardware_ShowError();
void ApplicationHardware_UndoLatestTextEntry();

#endif
