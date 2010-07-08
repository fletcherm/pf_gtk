#include <gtk/gtk.h>
#include "ApplicationView.h"

static void(*whenCalculateClicked)(void) = 0;
static void calculateClicked(GtkWidget *widget, gpointer data) {
  whenCalculateClicked();
}
void ApplicationView_WhenCalculateClicked(void(*callback)(void)) {
  whenCalculateClicked = callback;
}

static void(*whenDivisorChanged)(gchar*) = 0;
static void divisorChanged(GtkWidget *widget, gchar *new_text, gint new_text_length, gint *position, gpointer data) {
  whenDivisorChanged(new_text);
}
void ApplicationView_WhenDivisorChanged(void(*callback)(gchar*)) {
  whenDivisorChanged = callback;
}

static void(*whenDividendChanged)(gchar*) = 0;
static void dividendChanged(GtkWidget *widget, gchar *new_text, gint new_text_length, gint *position, gpointer data) {
  whenDividendChanged(new_text);
}
void ApplicationView_WhenDividendChanged(void(*callback)(gchar*)) {
  whenDividendChanged = callback;
}

GtkWidget *dividend;
GtkWidget *divisor;
GtkWidget *result;
GtkWidget *errorLabel;

void ApplicationView_Build() {
  // divisor stuff
  GtkWidget *divisorLabel = gtk_label_new("Divisor");
  divisor = gtk_entry_new();
  gtk_entry_set_max_length(GTK_ENTRY(divisor), DIVISION_FIELD_SIZE);
  g_signal_connect(divisor, "insert-text", G_CALLBACK(divisorChanged), NULL);

  GtkWidget *divisorBox = gtk_hbox_new(TRUE, 0);
  gtk_box_pack_start(GTK_BOX(divisorBox), divisorLabel, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(divisorBox), divisor, FALSE, FALSE, 0);

  gtk_widget_show(divisorLabel);
  gtk_widget_show(divisor);
  gtk_widget_show(divisorBox);

  // dividend stuff
  GtkWidget *dividendLabel = gtk_label_new("Dividend");
  dividend = gtk_entry_new();
  gtk_entry_set_max_length(GTK_ENTRY(dividend), DIVISION_FIELD_SIZE);
  g_signal_connect(dividend, "insert-text", G_CALLBACK(dividendChanged), NULL);

  GtkWidget *dividendBox = gtk_hbox_new(TRUE, 0);
  gtk_box_pack_start(GTK_BOX(dividendBox), dividendLabel, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(dividendBox), dividend, FALSE, FALSE, 0);

  gtk_widget_show(dividendLabel);
  gtk_widget_show(dividend);
  gtk_widget_show(dividendBox);

  // result stuff
  GtkWidget *resultLabel = gtk_label_new("Result");
  result = gtk_entry_new();
  gtk_entry_set_max_length(GTK_ENTRY(result), DIVISION_FIELD_SIZE);
  gtk_editable_set_editable(GTK_EDITABLE(result), FALSE);

  GtkWidget *resultBox = gtk_hbox_new(TRUE, 0);
  gtk_box_pack_start(GTK_BOX(resultBox), resultLabel, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(resultBox), result, FALSE, FALSE, 0);

  gtk_widget_show(resultLabel);
  gtk_widget_show(result);
  gtk_widget_show(resultBox);

  // calculate button stuff
  GtkWidget *calculateButton = gtk_button_new_with_label("Calculate");
  g_signal_connect(calculateButton, "clicked", G_CALLBACK(calculateClicked), NULL);
  gtk_widget_show(calculateButton);

  // error label stuff
  errorLabel = gtk_label_new("Cannot compute with these arguments.");

  // box it up
  GtkWidget *bigBox = gtk_vbox_new(TRUE, 0);
  gtk_box_pack_start(GTK_BOX(bigBox), divisorBox, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(bigBox), dividendBox, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(bigBox), resultBox, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(bigBox), calculateButton, FALSE, FALSE, 0);
  gtk_box_pack_start(GTK_BOX(bigBox), errorLabel, FALSE, FALSE, 0);
  gtk_widget_show(bigBox);

  // window stuff
  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "MCH Calculator");
  gtk_window_set_default_size(GTK_WINDOW(window), 300, 80);
  gtk_container_set_border_width(GTK_CONTAINER(window), 10);
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
  g_signal_connect_swapped(window, "delete-event", G_CALLBACK(gtk_widget_destroy), window);
  gtk_widget_show(window);

  // tie the room together
  gtk_container_add(GTK_CONTAINER(window), bigBox);
}

void ApplicationView_Start() {
  gtk_main();
}

const char* ApplicationView_GetDivisor() {
  return gtk_entry_get_text(GTK_ENTRY(divisor));
}

const char* ApplicationView_GetDividend() {
  return gtk_entry_get_text(GTK_ENTRY(dividend));
}

void ApplicationView_SetQuotient(int q) {
  char quotient[DIVISION_FIELD_SIZE];
  sprintf(quotient, "%d", q);
  gtk_entry_set_text(GTK_ENTRY(result), quotient);
}

void ApplicationView_HideError() {
  gtk_widget_hide(errorLabel);
}

void ApplicationView_ShowError() {
  gtk_widget_show(errorLabel);
}

void ApplicationView_UndoDivisorTextChange() {
  g_signal_stop_emission_by_name(divisor, "insert-text");
}

void ApplicationView_UndoDividendTextChange() {
  g_signal_stop_emission_by_name(dividend, "insert-text");
}
