#include <gtk/gtk.h>
#include "ApplicationHardware.h"

static void(*whenButtonClicked)(void) = 0;
static void buttonClicked(GtkWidget *widget, gpointer data)
{
  whenButtonClicked();
}
void ApplicationHardware_WhenButtonClicked(void(*callback)(void)) {
  whenButtonClicked = callback;
}

static void destroy(GtkWidget *widget, gpointer data)
{
    gtk_main_quit();
}

void ApplicationHardware_Build() {
  GtkWidget *button = gtk_button_new_with_label("Hello World");
  g_signal_connect(button, "clicked", G_CALLBACK(buttonClicked), NULL);

  GtkWidget *box = gtk_vbox_new(TRUE, 0);
  gtk_box_pack_start(GTK_BOX(box), button, FALSE, FALSE, 0);

  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "Hello World with MCH");
  gtk_window_set_default_size(GTK_WINDOW(window), 300, 80);
  gtk_container_set_border_width(GTK_CONTAINER(window), 10);
  g_signal_connect(window, "destroy", G_CALLBACK (destroy), NULL);

  gtk_container_add(GTK_CONTAINER(window), box);

  gtk_widget_show(button);
  gtk_widget_show(box);
  gtk_widget_show(window);
}

void ApplicationHardware_Start() {
  gtk_main();
}
