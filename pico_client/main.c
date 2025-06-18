
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "btlib.h"
#include "hardware/gpio.h"
#include "pico/cyw43_arch.h"

  // callback for LE server
int lecallback(int node,int op,int cticn);

char *devices = { 
"DEVICE = Picostack type=mesh  node=1005  address=28:CD:C1:01:8D:5F          \n\
PRIMARY_SERVICE=1800                                          \n\
  LECHAR=Device name    SIZE=16 PERMIT=02 UUID=2A00  ;index 0 \n\
PRIMARY_SERVICE=112233445566778899AABBCCDDEEFF00              \n\
   LECHAR = Data        SIZE=8  PERMIT=06 UUID=ABCD  ;index 1 \n\
   LECHAR = LED control SIZE=2  PERMIT=04 UUID=CAFE  ;index 2 \n\
"};
                                                                 
void mycode(void);

void mycode(){
  char button3[] = "button3 333 123412";
  char button4[] = "button4 444 ABCDEF";
  char nopress[] = "no button pressed";
  char data[20];
  sleep_ms(3000);
  

  if(init_blue(devices) == 0)
    return;
    
  gpio_init(3); gpio_set_dir(3,GPIO_IN); gpio_pull_up(3);
  gpio_init(4); gpio_set_dir(4,GPIO_IN); gpio_pull_up(4);
    
  connect_node(1005,CHANNEL_LE,0);//connect
  set_le_wait(1000);
  find_ctics(1005);//read services
  sleep_ms(1000);
  while(1){
    strcpy(data,nopress);
    if(!gpio_get(3)) strcpy(data,button3);
    else if(!gpio_get(4)) strcpy(data,button4);
  write_ctic(1005,2,data,sizeof(data));//write to index 2
  sleep_ms(200);
  //set_le_wait(2000);
  //disconnect_node(1);
  }
}




