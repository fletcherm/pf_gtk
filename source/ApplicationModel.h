#ifndef _ApplicationModel_H
#define _ApplicationModel_H

void ApplicationModel_WhenApplicationStarts(void(*callback)(void));

int ApplicationModel_Run();
int ApplicationModel_Divide(const char* divisor, const char* dividend);
int ApplicationModel_ValidateArguments(const char* divisor, const char* dividend);
int ApplicationModel_CheckArgumentFormat(const char* previouslyEnteredText, const char* newText);

#endif // _ApplicationModel_H
