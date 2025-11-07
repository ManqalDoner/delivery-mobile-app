import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class ConnectScreen extends StatelessWidget{
 
  Widget build(BuildContext context){

    return Scaffold(
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              
              child: Lottie.asset("shapes/splash_anime/connectError.json",width:250,height: 250 ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Şəbəkə bağlantısını yoxlayın...",
                style: TextStyle(
                  fontFamily: "NatoSans",
                  fontSize: 20,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500
                ),
              ),
            )
          ],
        )
      )
    );
  }
}