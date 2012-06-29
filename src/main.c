#include "ApplicationModel.h"
#include "Presenters.h"

int main(int argc, char* argv[]) {
  gtk_init(&argc, &argv);
  Presenters_RegisterForEvents();
  return ApplicationModel_Run();
}
