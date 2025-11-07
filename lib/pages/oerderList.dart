import "package:delivery_app/widgets/_order_list_box.dart";
import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:lottie/lottie.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";


class Oerderlist extends StatefulWidget{
  State<Oerderlist> createState()=> _oerderlist();
}

class _oerderlist extends State<Oerderlist>{
  bool displayText=false;
  List<String> orderName=[];
  List<int> orderCount=[];


  List<dynamic> image=[];


  //delet box
  CancelBox(int index,name) async{
    final prefs=await SharedPreferences.getInstance();
    final userID=prefs.getInt("id");
    if(userID==null){
        prefs.clear();
        return;
    }
    if(name.isNotEmpty){
        await Supabase.instance.client
      .from("Order")
      .delete()
      .eq("user_id",userID)
      .eq("name", name[index])
      .select("order_id");
    
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
      .select("name,count")
      .eq("user_id",userID);
   
    
    if(getOrderID.isNotEmpty){
      orderName=List.generate(getOrderID.length, (index)=>getOrderID[index]["name"]);
      orderCount=List.generate(getOrderID.length, (index)=>getOrderID[index]["count"]);
      
      
      orderName.forEach((value){
        switch (value){
            case "Qızardılmış Toyuq":
               image.add("shapes/menu/menu4.jpg");

            case "Lavaş Döner":
               image.add("shapes/menu/menu3.jpg");

            case "Limuzin Döner":
              image.add("shapes/menu/menu1.jpg");

            case "Yarım Tendir Döner":
              image.add("shapes/menu/menu6.png");

            case "Tendir Döner":
              image.add("shapes/menu/menu5.jpg");

            case "Qoşa Lavaş Döner":
              image.add("shapes/menu/menu7.png");

            case "Normal Döner":
               image.add("shapes/menu/menu2.jpg");
        };
      
      });
     
    }
    yield getOrderID;
  }
  

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
          index: 0,
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
                  case 1:
                    Navigator.pushReplacementNamed(context, "Menu");
                  case 2:
                    Navigator.pushReplacementNamed(context, "Account");
                  
                }
             });
          },
        ),
      ),
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
          if(getOrder.isNotEmpty){
            return GridView.builder(
                itemCount: orderName.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:1,childAspectRatio: 2.1),
                itemBuilder: (context,index){
                if(image.isNotEmpty){
                    return CustomeBox(
                    orderImg: image[index],
                    orderName: orderName[index],
                    orderCount: orderCount[index].toString(),
                    OnPressed:(){
                        setState(() {
                          CancelBox(index,orderName);
                        });
                    },
                );
                }else {
                    return Text("");
                }
                
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