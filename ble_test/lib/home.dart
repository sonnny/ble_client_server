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
const String BLE_ADDRESS = '28:CD:C1:01:8D:5F';
const String SERVICE = '112233445566778899aabbccddeeff00';
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
child:Text('''
make sure ble device is on
update AndroidManifest.xml with location
permissions and allowed this app with location
permissions on settings
''')),
         
////////////////////////////////
// 3rd column with a row
Padding(padding: EdgeInsets.all(20), 
child:Row(children:[

Text('ble address: '),

Text('${BLE_ADDRESS} ',style:
TextStyle(fontSize:16)),

SizedBox(width:5),

ElevatedButton(child:Text('${status}',
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


