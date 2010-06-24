#ifndef _APPLICATION_HARDWARE_
#define _APPLICATION_HARDWARE_

void ApplicationHardware_WhenCalculateClicked(void(*callback)(void));

void ApplicationHardware_Build();
void ApplicationHardware_Start();
int ApplicationHardware_GetDivisor();
int ApplicationHardware_GetDividend();
void ApplicationHardware_SetQuotient(int);

#endif
