#ifndef _APPLICATION_VIEW_
#define _APPLICATION_VIEW_

#define DIVISION_FIELD_SIZE 6

void ApplicationView_WhenCalculateClicked(void(*callback)(void));
void ApplicationView_WhenDivisorChanged(void(*callback)(char* new_text));
void ApplicationView_WhenDividendChanged(void(*callback)(char* new_text));

void ApplicationView_Build();
void ApplicationView_Start();
const char* ApplicationView_GetDivisor();
const char* ApplicationView_GetDividend();
void ApplicationView_SetQuotient(int);
void ApplicationView_HideError();
void ApplicationView_ShowError();
void ApplicationView_UndoDivisorTextChange();
void ApplicationView_UndoDividendTextChange();

#endif
