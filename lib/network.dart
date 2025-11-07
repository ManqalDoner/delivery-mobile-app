
import "package:delivery_app/pages/network_screen.dart";
import "package:flutter/material.dart";
import "dart:io";

Future<bool> tryConncet() async{
  try{
    final socket=await InternetAddress.lookup("google.com");
    if(socket.isNotEmpty&&socket[0].rawAddress.isNotEmpty){
      return true;
    }
    
  }on SocketException catch(_){
    return false;
  }

  return false;
}

Stream<bool> StreamConnect() async*{
  while(true){
    await Future.delayed(Duration(seconds: 2));
    bool connect= await tryConncet();
    yield connect;
  }
}

class NetworkServer extends StatelessWidget{
  
  final Widget child;
  NetworkServer({super.key,required this.child});
  

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.amber,
      body:StreamBuilder<bool>(
        stream: StreamConnect(),
        builder: (context, snapshot) {
          final connect=snapshot.data?? true;
          if(!connect){
            return ConnectScreen();
          }
          else {
            return child;
          }
          
        }
      )
    );
  }
}