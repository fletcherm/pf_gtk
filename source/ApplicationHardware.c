#include <gtk/gtk.h>
#include "ApplicationHardware.h"

void ApplicationHardware_Build() {
  int argc = 0;
  char** argv;
  gtk_init(&argc, &argv);

  GtkWidget *window = gtk_window_new (GTK_WINDOW_TOPLEVEL);
  GtkWidget *button = gtk_button_new_with_label ("Hello World");

  gtk_window_set_title((GtkWindow*)window, "Hello World with MCH");
  gtk_container_set_border_width(GTK_CONTAINER (window), 10);
  gtk_container_add(GTK_CONTAINER (window), button);
  gtk_widget_show(button);
  gtk_widget_show(window);
}

void ApplicationHardware_Start() {
  gtk_main();
}
