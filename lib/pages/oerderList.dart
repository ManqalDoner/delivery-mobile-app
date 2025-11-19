import "package:delivery_app/notification_service.dart";
import "package:delivery_app/widgets/_order_list_box.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import 'dart:async';




class Oerderlist extends StatefulWidget{
  State<Oerderlist> createState()=> _oerderlist();
}

class _oerderlist extends State<Oerderlist>{
  bool displayText=false;
  List<String> orderName=[];
  List<int> orderCount=[];
  int selectIndex=0;

  List<dynamic> image=[];

  ScrollController scrollcontroller=ScrollController();
  //delet box
  CancelBox(value) async{
    final prefs=await SharedPreferences.getInstance();
    final userID=prefs.getInt("id");
    if(userID==null){
        prefs.clear();
        return;
    }
    if(value.isNotEmpty){
        await Supabase.instance.client
      .from("Order")
      .delete()
      .eq("user_id",userID)
      .eq("name", value["name"])
      .select("order_id");
     NotificationService.showNotification(title: value["name"], body:"Sifarişiniz Silindi."); 
    }
    
  }
  Stream<List<Map<String,dynamic>>> getDataOnDB()async*{
    final prefs=await SharedPreferences.getInstance();
    final userID=prefs.getInt("id");

    if(userID==null){
      prefs.clear();
      return;
    }
    
    final getOrderID=await Supabase.instance.client
    .from("Order")
    .stream(primaryKey: ["order_id"])
    .eq("user_id",userID)
    .order("order_id",ascending: false);

    
  
    yield * getOrderID;

    
    
  }
  
  


  String getFoodImages(String name){
    switch (name){
      case "Qızardılmış Toyuq":
        return "shapes/menu/menu4.jpg";

      case "Lavaş Döner":
        return "shapes/menu/menu3.jpg";

      case "Limuzin Döner":
        return "shapes/menu/menu1.jpg";

      case "Yarım Tendir Döner":
        return "shapes/menu/menu6.png";

      case "Tendir Döner":
        return "shapes/menu/menu5.jpg";

      case "Qoşa Lavaş Döner":
        return "shapes/menu/menu7.png";

      case "Normal Döner":
          return "shapes/menu/menu2.jpg";
       default:
        return "assets/food/default.jpg";
    }
  }

  Widget build(BuildContext context){
    return Scaffold(
      body: StreamBuilder(
        stream: getDataOnDB(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                    width:200,
                    height: 200,
                    alignment: Alignment.center,
                    child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 20,
                        children: [
                            Lottie.asset(
                                "shapes/splash_anime/order.json",
                                repeat: true,
                                reverse: false,
                                animate: true,
                                width: 200,
                                height: 200
                            ),
                        
                        
                        ],
                    )
                    
                ),   
            );
          }
          final getOrder=snapshot.data!;

          WidgetsBinding.instance.addPostFrameCallback((_){
            if(scrollcontroller.hasClients){
                scrollcontroller.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 500),
                    curve:Curves.linear
                );
            }
            
          });
          
          if(getOrder.isNotEmpty){
            return ListView.builder(
                itemCount: getOrder.length,
                controller: scrollcontroller,
                itemBuilder: (context,index){
                  final getData=getOrder[getOrder.length-1-index];
                  if(getData["take_order"]=="Alındı"){
                     
                    NotificationService.showNotification(title: getData["name"], body:"Sifarişiniz qəbul edildi.\n Sifarişiniz yaxın zamanda çatdırılacaq.");      

                  }
                  return CustomeBox(
                    orderImg: getFoodImages(getData["name"]),
                    orderName: getData["name"],
                    orderCount: getData["count"].toString(),
                    takeOrder: getData["take_order"]=="Alındı"? "Alındı":"",
                    OnPressed:(){
                        setState(() {
                          CancelBox(getData);
                        });
                    },
                  );
                
                
                },
            );
          }else{
            return Center(
                child: Text(
                    "Hazırda sifarişiniz yoxdur.",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withValues(alpha: 0.6)
                    ),
                ),
            );
          }
        }
            
        
      )
           
          
           
    );
  }
}