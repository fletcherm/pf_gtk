#ifndef _ApplicationModel_H
#define _ApplicationModel_H

void ApplicationModel_WhenApplicationStarts(void(*callback)(void));

int ApplicationModel_Run();
int ApplicationModel_Divide(int divisor, int dividend);
int ApplicationModel_CheckArgs(int divisor, int dividend);

#endif // _ApplicationModel_H
