import 'package:flutter/material.dart';

const code = '''

add below to android/app/src/main/AndroidManifest.xml

<uses-permission android:name=
"android.permission.BLUETOOTH_SCAN"/>
<uses-permission android:name=
"android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name=
"android.permission.ACCESS_FINE_LOCATION" />

/*********** main.dart **************/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import './home.dart';

late final Highlighter darkTheme;

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Highlighter.initialize(['dart','yaml']);
var dark = await HighlighterTheme.loadDarkTheme();
darkTheme = Highlighter(language: 'dart', theme: dark);
runApp(MainApp());}

class MainApp extends StatelessWidget {
MainApp({super.key});

@override Widget build(BuildContext context) {
return MaterialApp(debugShowCheckedModeBanner: false,
title: 'ble test', home: Home());}}

/*********** home.dart **************/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import './source_code.dart';

TextStyle connectedStyle = TextStyle(
color:Colors.blue,fontSize:18,
fontWeight:FontWeight.bold);

TextStyle notConnectedStyle = 
TextStyle(color:Colors.red);

//use nrf connect to find info
const String BLE_ADDRESS =
'28:CD:C1:01:8D:5F';
const String SERVICE = 
'112233445566778899aabbccddeeff00';
const String CHARACTERISTIC = 'CAFE';

class Home extends StatefulWidget{
Home({super.key});
@override State<Home> createState() 
=> HomeState();}
  
class HomeState extends State<Home>{

Key key = UniqueKey();
late BluetoothDevice device;
String? status = 'connect';
bool isConnected = false;
var txCharacteristic;

void sendString(String data) async {
try{ List<int>? toSend = utf8.encode(data);
await txCharacteristic.write(
toSend, withoutResponse: true);}catch (e){}}
  
void connect()async{
device = BluetoothDevice(
remoteId:DeviceIdentifier(BLE_ADDRESS));
await device.connect();//connect without bluetooth scan
List<BluetoothService> services = 
await device.discoverServices();
txCharacteristic = BluetoothCharacteristic(
remoteId: device.remoteId,
serviceUuid: Guid(SERVICE),
characteristicUuid: Guid(CHARACTERISTIC));
setState((){status = 'ready'; 
isConnected = true;});}

@override Widget build(BuildContext context){
return Scaffold(appBar: AppBar(
title: Text('Home')),
   
/////////////////////////
//body of app 
body: Column(children:[

////////////////////////////////
// 1st column
Padding(padding:EdgeInsets.fromLTRB(20,20,0,0),
child:Text('Notes:',style:TextStyle(
color:Colors.purple,fontSize:20,
fontWeight:FontWeight.bold))),

////////////////////////////////
// 2nd column
Padding(padding:EdgeInsets.all(10), 
child:Text(TRIPLE_SINGLE_QUOTE
make sure ble device is on
update AndroidManifest.xml with location
permissions and allowed this app with location
permissions on settings
TRIPLE_SINGLE_QUOTE)),
         
////////////////////////////////
// 3rd column with a row
Padding(padding: EdgeInsets.all(20), 
child:Row(children:[

Text('ble address: '),

Text('DOLLAR_SIGN{BLE_ADDRESS} ',style:
TextStyle(fontSize:16)),

SizedBox(width:5),

ElevatedButton(child:Text('DOLLAR_SIGN{status}',
style: isConnected ? connectedStyle : 
notConnectedStyle), onPressed:() => connect(),)
])),

///////////////////////////
// 4th column
Padding(padding:EdgeInsets.all(20),
child:ElevatedButton(child:Text('button 3'), 
onPressed:(){sendString('android33 mnlop qrst');})),

//////////////////////////
// 5th column
Padding(padding:EdgeInsets.all(20),
child:ElevatedButton(child:Text('button 4'),
onPressed:(){sendString('android44 abcdef ghijklm');})),

/////////////////////////
// 6th column
Padding(padding:EdgeInsets.all(20),
child:ElevatedButton(child:Text('source code'),
onPressed:(){Navigator.push(context,
MaterialPageRoute(builder: (context) => 
SourceCode()));})),

///////////////////////
// 7th column
Padding(padding:EdgeInsets.all(20),
child:ElevatedButton(child:Text('exit'),
onPressed:() async {await device.disconnect();
SystemNavigator.pop();}))
  
]));}}
/********* source_code.dart *********/
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syntax_highlight/syntax_highlight.dart';
import './code.dart';
import './main.dart';

class SourceCode extends StatelessWidget{
SourceCode({super.key});

@override Widget build(BuildContext context){
return Scaffold(appBar: AppBar(title: Text('source code')),
body: SingleChildScrollView(
child: Container(padding: const EdgeInsets.all(16),
color: Colors.black,
child: Text.rich(
darkTheme.highlight(code),
style: GoogleFonts.jetBrainsMono(
fontSize: 14, height: 1.3,)))));}}

/********** picow server *********/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "btlib.h"
#include "pico/stdlib.h"
#include "pico/cyw43_arch.h"
#include "mywork.h"

  // callback for LE server
int lecallback(int node,int op,int cticn);

char *devices = { 
"DEVICE = Picostack type=mesh  node=1  address=local          \n\
PRIMARY_SERVICE=1800                                          \n\
  LECHAR=Device name    SIZE=16 PERMIT=02 UUID=2A00  ;index 0 \n\
PRIMARY_SERVICE=112233445566778899AABBCCDDEEFF00              \n\
   LECHAR = Data        SIZE=8  PERMIT=06 UUID=ABCD  ;index 1 \n\
   LECHAR = LED control SIZE=1  PERMIT=04 UUID=CAFE  ;index 2 \n\
"};
                                                                 
void mycode(void);

void mycode(){
  
  sleep_ms(3000);
  init_gfx();
  if(init_blue(devices) == 0) return;
  while(1){le_server(lecallback,10);}}  // 10 = 1 second timer 

int lecallback(int node,int op,int cticn){
  unsigned char data_received[30];
  
  if(op == LE_CONNECT) cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN, 1);

  else if(op == LE_WRITE && cticn == 2){ //reading characteristic CAFE, index 2
    read_ctic(localnode(),2,data_received,sizeof(data_received));
    process_data(data_received);
  }
  else if(op == LE_DISCONNECT) cyw43_arch_gpio_put(CYW43_WL_GPIO_LED_PIN,0);

  return(SERVER_CONTINUE);
  }

/************** my_work.h ***************/
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

/********** server CMakeLists.txt *********/
cmake_minimum_required(VERSION 3.13)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PICO_BOARD "pico_w")
include("/opt/pico-sdk/external/pico_sdk_import.cmake")
project(main C CXX ASM)
pico_sdk_init()
add_compile_definitions(CYW43_ENABLE_BLUETOOTH=1)
add_executable(main main.c ble/picostack.c ble/btlibp.c gfx/gfx.c gfx/st7789.c)
target_compile_definitions(main PRIVATE PICO_STACK_SIZE=4096)
target_link_libraries(main
  pico_stdlib
  hardware_spi
  hardware_pwm
  pico_cyw43_arch_none)
pico_enable_stdio_usb(main 1)
target_include_directories(main PUBLIC src ble gfx

/********* picow client **************/

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


/******** client CMakeLists.txt **********/
cmake_minimum_required(VERSION 3.13)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(PICO_BOARD "pico_w")
include("/opt/pico-sdk/external/pico_sdk_import.cmake")
project(main C CXX ASM)
pico_sdk_init()
add_compile_definitions(CYW43_ENABLE_BLUETOOTH=1)
add_executable(main main.c ble/picostack.c ble/btlibp.c)
target_compile_definitions(main PRIVATE PICO_STACK_SIZE=4096)
target_link_libraries(main
  pico_stdlib
  pico_cyw43_arch_none)
pico_enable_stdio_usb(main 1)
target_include_directories(main PUBLIC src ble)
pico_add_extra_outputs(main)

''';
