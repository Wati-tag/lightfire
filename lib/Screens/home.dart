import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lightfire/Services/widgets.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


   BluetoothService monservice;
   BluetoothCharacteristic macharacteristic;
   FlutterBlue flutterBlue = FlutterBlue.instance;

    lookservices() async  {
    flutterBlue.stopScan();
    List<BluetoothService> services = await widget.device.discoverServices();
      services.forEach((service) {
          print(service.uuid.toString().toUpperCase().substring(4, 8));
         if(service.uuid.toString().toUpperCase().substring(4, 8) == 'FFE0'){
            monservice = service;
         }
      });

        var characteristics = monservice.characteristics;
        for(BluetoothCharacteristic c in characteristics) {

          
          if(c.uuid.toString().toUpperCase().substring(4, 8) == 'FFE1'){
                macharacteristic = c;
                
                 await macharacteristic.setNotifyValue(!macharacteristic.isNotifying);
                 await macharacteristic.read();    
                } 
        }
   
  }
      
 


  @override

  
  Widget build(BuildContext context) {
    bool valide = false;
    

    lookservices(); 

       
    
    
   

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.device.name),
        actions: <Widget>[
          StreamBuilder<BluetoothDeviceState>(
            stream: widget.device.state,
            initialData: BluetoothDeviceState.connecting,
            builder: (c, snapshot) {
              VoidCallback onPressed;
              String text;
              switch (snapshot.data) {
                case BluetoothDeviceState.connected:
                  onPressed = () {widget.device.disconnect();
                  Navigator.pop(context);};
                  text = 'DISCONNECT';
                  break;
                case BluetoothDeviceState.disconnected:
                  onPressed = () => widget.device.connect();
                  text = 'CONNECT';
                  break;
                default:
                  onPressed = null;
                  text = snapshot.data.toString().substring(21).toUpperCase();
                  break;
              }
              return FlatButton(
                  onPressed: onPressed,
                  child: Text(
                    text,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .button
                        .copyWith(color: Colors.white),
                  ));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
          
              FlatButton(child: Text('envoyer un 1'),
           onPressed: () {
             
           //print(String.fromCharCodes(value));
           macharacteristic.write([0x51]);
             
           } ,),
             
              
       
        
           
           StreamBuilder<List<int>>(
      stream: macharacteristic.value,
      initialData: macharacteristic.lastValue,
      builder: (c, snapshot) {
        final value = snapshot.data;
        return Container(
          child:
          Column(
            children: [
              Text('Characteristic : '+value.toString()),
              
            ],
          ),
         
        );
     
      },
    ),
   //Text('Validé', style: TextStyle(color: valide ? Colors.green : Colors.red,))
            
  
            
            
          ],
          
        ),
      ),
    );
  }
}

