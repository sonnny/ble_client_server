#include <stdlib.h>
#include "st7789.h"
#include "gfx.h"

char *token;
char tokens[5][30];
int x=0;

void init_gfx(){
LCD_initDisplay(240,240);
LCD_setRotation(2);
GFX_createFramebuf();
GFX_clearScreen();
GFX_setCursor(0,0);
GFX_printf("waiting...");
GFX_flush();}

void process_data(char *s){
x=0;
token=strtok(s," ");
while(token != NULL){
  strcpy(tokens[x],token);
  token=strtok(NULL," ");
  x++;}
  
GFX_clearScreen();
GFX_setCursor(0,0);
GFX_printf("ble data:\n\n command: %s\n\n param1: %s\n\n param2: %s\n",
  tokens[0],tokens[1],tokens[2]);
GFX_flush();}
