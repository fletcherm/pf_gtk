#ifndef _ApplicationModel_H
#define _ApplicationModel_H

void ApplicationModel_WhenApplicationStarts(void(*callback)(void));

int ApplicationModel_Run();
int ApplicationModel_ComputeSquare();

#endif // _ApplicationModel_H
