#include <gtk/gtk.h>
#include "ApplicationHardware.h"

static void(*whenCalculateClicked)(void) = 0;
static void calculateClicked(GtkWidget *widget, gpointer data)
{
  whenCalculateClicked();
}
void ApplicationHardware_WhenCalculateClicked(void(*callback)(void)) {
  whenCalculateClicked = callback;
}

static void destroy(GtkWidget *widget, gpointer data)
{
    gtk_main_quit();
}

void ApplicationHardware_Build() {

  GtkWidget *calculateButton = gtk_button_new_with_label("Calculate");
  g_signal_connect(calculateButton, "clicked", G_CALLBACK(calculateClicked), NULL);

  GtkWidget *box = gtk_vbox_new(TRUE, 0);
  gtk_box_pack_start(GTK_BOX(box), calculateButton, FALSE, FALSE, 0);

  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "MCH Calculator");
  gtk_window_set_default_size(GTK_WINDOW(window), 300, 80);
  gtk_container_set_border_width(GTK_CONTAINER(window), 10);
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
  g_signal_connect_swapped(window, "delete-event", G_CALLBACK(gtk_widget_destroy), window);

  gtk_container_add(GTK_CONTAINER(window), box);

  gtk_widget_show(calculateButton);
  gtk_widget_show(box);
  gtk_widget_show(window);
}

void ApplicationHardware_Start() {
  gtk_main();
}
