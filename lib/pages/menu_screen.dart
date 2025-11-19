import "package:delivery_app/network.dart";
import "package:delivery_app/pages/order.dart";
import "package:delivery_app/widgets/_custome_Menu_box.dart";
import "package:flutter/material.dart";



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