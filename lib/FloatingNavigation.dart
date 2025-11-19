import "package:delivery_app/network.dart";
import "package:delivery_app/pages/account_screen.dart";
import "package:delivery_app/pages/closeApp.dart";
import "package:delivery_app/pages/menu_screen.dart";
import "package:delivery_app/pages/oerderList.dart";
import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";



class NavigationPages extends StatefulWidget{
  State<NavigationPages> createState()=>_navigationPages();
  
}

class _navigationPages extends State<NavigationPages>{

  final screen=[
    NetworkServer(child:Closeapp(child:Oerderlist() )),
    NetworkServer(child:Closeapp(child:MenuScreen() )),
    NetworkServer(child:Closeapp(child:AccountScreen())),
    
  ];
 int selectIndex=1;

  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.amber,
        title: Container(
          margin: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                width: 60,
                height: 60,
                image: AssetImage("shapes/logo/logo.png"),
              ),
              Text(
                "Manqal Döner",
                style: TextStyle(
                  fontFamily: "Metropolis",
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withValues(alpha: 0.7)),
                  textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
      //Section: Bottom Nav bart
      bottomNavigationBar:SafeArea(
        child: CurvedNavigationBar(
          height: 50,
          index: 1,
          animationDuration: Duration(milliseconds:200),
          backgroundColor: Colors.amber,
          buttonBackgroundColor: Colors.white12.withValues(alpha: 0.7),
          animationCurve: Curves.bounceInOut,
          items:<Widget> [
            Icon(Icons.shopping_basket_outlined,size: 45,),
            Icon(Icons.home,size: 45,),
            Icon(Icons.account_circle_sharp,size: 45,)
          ],
          onTap: (index){
             setState(() {
                selectIndex=index;
             });
            
            
          },
        ),
      ),
      body: screen[selectIndex]

    );
  
  }
}