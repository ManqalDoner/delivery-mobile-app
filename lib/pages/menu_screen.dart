import "package:delivery_app/network.dart";
import "package:delivery_app/pages/oerderList.dart";
import "package:delivery_app/pages/order.dart";
import "package:delivery_app/widgets/_custome_Menu_box.dart";
import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";


/*
 ----this is menu Section--
*/

class MenuScreen  extends StatefulWidget{

  State<StatefulWidget> createState()=>_menu();
}

class _menu extends State<StatefulWidget>{
  static List<String> _nameOffood=[
    "Limuzin Döner",
    "Normal Döner",
    "Lavaş Döner",
    "Qızardılmış Toyuq",
    "Tendir Döner",
    "Yarım Tendir Döner",
     "Qoşa Lavaş Döner"
    
  ];
  static List<String> _foodPrice=[
    "2.40",
    "1.80",
    "2.40",
    "7.50",
    "6.00",
    "3.00",
    "3.00",
    
  ];
  //Food shapes
  final List<String> _foodShape=[
    "shapes/menu/menu1.jpg",
    "shapes/menu/menu2.jpg",
    "shapes/menu/menu3.jpg",
    "shapes/menu/menu4.jpg",
    "shapes/menu/menu5.jpg",
    "shapes/menu/menu6.png",
    "shapes/menu/menu7.png",
    
  ];
  nextOrder(context,index){
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:(context)=>NetworkServer(child:OrderScreen(orderName: _nameOffood[index],orderShape: _foodShape[index],)))
      );
      
    });
  }

  Widget build(BuildContext context){
    //var appSize=MediaQuery.of(context).size;
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
                switch(index){
                  case 0:
                    Navigator.pushReplacementNamed(context, "OrderList");
                  case 2:
                    Navigator.pushReplacementNamed(context, "Account");
                  
                }
             });
          },
        ),
      ),

      //Menu and Menu Boxs
      body:GridView.builder(
        itemCount: _nameOffood.length,
        //padding: EdgeInsets.all(10),
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,childAspectRatio: 2.1),
        itemBuilder: (context,index){
          return  MenuBox(
            name: _nameOffood[index],
            imgUrl: _foodShape[index],
            price: _foodPrice[index],
            onPressed:()=>nextOrder(context,index) ,
          );
        },
      ),
      
      
    );
  }
}