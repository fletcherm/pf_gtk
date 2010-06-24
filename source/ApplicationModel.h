#ifndef _ApplicationModel_H
#define _ApplicationModel_H

void ApplicationModel_WhenApplicationStarts(void(*callback)(void));

int ApplicationModel_Run();
int ApplicationModel_Divide(char* divisor, char* dividend);
int ApplicationModel_CheckArgs(char* divisor, char* dividend);

#endif // _ApplicationModel_H
