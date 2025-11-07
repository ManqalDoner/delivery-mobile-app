import "package:delivery_app/pages/menu_screen.dart";
import "package:delivery_app/widgets/_counterBtn.dart";
import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";




orderDB(addressValue,order_name,counter_value,dishes_value) async{
    final prefs= await SharedPreferences.getInstance();
    final userID=prefs.getInt("id");
   
    List<Map<String,dynamic>> SideDishesData=[];

    if(userID==null){
        prefs.clear();
        return;
    }else{
        //upgrade address
        await Supabase.instance.client
        .from("User")
        .upsert({
            "user_id":userID,
            "Address":addressValue
        })
        .eq("user_id", userID)
        .select();

        for(int s=0;s<dishes_value.length;s++){
            if(dishes_value[s].isNotEmpty&&counter_value[s]!=0){
                SideDishesData.add({
                    //"sidedishes_id":s,
                    "name":dishes_value[s],
                    "count":counter_value[s]
                });
            }
        };
       final SideDishesDB= await Supabase.instance.client
            .from("SideDishes")
            .upsert(SideDishesData)
            .select();
        
        final OrderDB=await Supabase.instance.client
            .from("Order")
            .insert({
                "user_id":userID,
                 "count":counter_value[0],
                "name":order_name,
                "order_address":addressValue,
            }).select().maybeSingle();
        if(OrderDB==null){
            return;
        }
        final orderID=OrderDB["order_id"];
        //to make OrderAndSidedishes map
        List<Map<String,dynamic>> orderAndSidedishesData=[];
        for(var dish in SideDishesDB){
            orderAndSidedishesData.add({
                "order_id":orderID,
                "sidedishes_id":dish["sidedishes_id"],
                "quantity":dish["count"]
            });
        }
        await Supabase.instance.client
         .from("OrderAndSideDishes")
         .insert(orderAndSidedishesData);
    }

    
   
}

class OrderScreen extends StatefulWidget{
  
  String orderName="";
  String orderShape="";
  

  OrderScreen({
    this.orderName="",
    this.orderShape="",
  });
  
  State<OrderScreen> createState()=> _OrderPage();
 
}

final List<String> dishesListCola=["Kola 0.3","Kola 0.5","Kola 1L","Kola 1.5L","Kola 2L","Kola 2.5L"];
final List<String> dishesListFanta=["Fanta 0.3","Fanta 0.5","Fanta 1L","Fanta 1.5L","Fanta 2L","Fanta 2.5L"];

class _OrderPage extends State<OrderScreen>{
  bool toColor=false;

  //dropDownbutton and selected dishes button
  final ValueNotifier selectedCola = ValueNotifier(dishesListCola.first);
  final ValueNotifier selectedFanta = ValueNotifier(dishesListFanta.first);
  
 

  String selectFanta=dishesListFanta.first;
  String? Error_valid;
  TextEditingController getText =TextEditingController();
  int x=0;

  //for the Error valid on Address box
  initState(){
    super.initState();
    getText.addListener((){
        if(Error_valid!=null){
            setState(()=>Error_valid=null);
        }
    });
  }

  //for the Address
  DisplayAddressOnBox() async{
   final prefs= await SharedPreferences.getInstance();
   final userID=prefs.getInt("id");
   if(userID==null){
    prefs.clear();
    return;
   }else{
    final getAddress=await Supabase.instance.client
    .from("User")
    .select("Address")
    .eq("user_id", userID);
    if(getAddress.isNotEmpty||getAddress[0].isNotEmpty){
        getText.text=getAddress[0]["Address"];
    }
   }
   
  }
  
  Widget build(BuildContext context){
    // get to count and name and then they convert list
    List<int> numberAdd=[1,0,0,0];
    List<String> dishesName=[widget.orderName,"","",""];
   
    DisplayAddressOnBox();
    
    return Scaffold(
       appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 110,
        title: SizedBox(
           width: 330,
            child:TextField(
                controller: getText,
                cursorColor: Colors.black,
                
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "NatoSans"
                    
                ),
                decoration: InputDecoration(
                    errorText: Error_valid,
                    errorStyle: TextStyle(color:Colors.red.shade400,fontSize: 15,fontWeight: FontWeight.bold,),
                    hintText: "Ünvan daxil edin",
                    icon: Icon(Icons.location_on,color: Colors.amber,),
                    
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.amber),
                    
                    ),
                    focusedBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.amber,width: 1.5)
                    ) 
                )
                
            
            ),
        ),
        

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.all(10),
                elevation: 2.5,
                color: Colors.amber.shade200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child:Flex(
                        direction: Axis.vertical,
                        
                        children: [
                          Text(
                            widget.orderName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: Colors.black38
                            ),
                          ),
                        ],
                      ), 
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
                      child: Image(
                          width: 160,
                          height: 160,
                          image: AssetImage(widget.orderShape),
                          fit: BoxFit.cover,
                        
                      ) ,
                    ),
                  ],

                ),
              ),
              // counter button
             Container(
                margin: EdgeInsets.all(25),
            
                child:  Flex(
                    direction: Axis.vertical,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 20,
                    children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                RichText(
                                    
                                    text: TextSpan(
                                        children: [
                                            TextSpan(
                                                
                                                text: "${widget.orderName}  ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54,
                                                    fontFamily: "Metropolis",
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            
                                            WidgetSpan(
                                                alignment: PlaceholderAlignment.middle,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(5),
                                                    child: Image(
                                                        width: 30,
                                                        height: 30,
                                                        image: AssetImage(widget.orderShape),
                                                    ),
                                                )
                                            )
                                        ]
                                    ),
                                ),
                                CounterBox(
                                  count:1,
                                  
                                  onChanged: (value){
                                   dishesName[0]=widget.orderName;                                 
                                    numberAdd[0]=value;
                                  },
                                )
                                
                            ],
                        ) ,
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                RichText(
                                    
                                    text: TextSpan(
                                        children: [
                                            TextSpan(
                                                
                                                text: "Ayran  ",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black54,
                                                    fontFamily: "Metropolis",
                                                    fontWeight: FontWeight.w600
                                                )
                                            ),
                                            
                                            WidgetSpan(
                                                alignment: PlaceholderAlignment.middle,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(50),
                                                    child: Image(
                                                        width: 30,
                                                        height: 30,
                                                        image: AssetImage("shapes/side_dishes/ayran.png"),
                                                    ),
                                                )
                                            )
                                        ]
                                    ),
                                ),
                                CounterBox(
                                 
                                  onChanged: (value){
                                   dishesName[1]="Ayran";
                                    numberAdd[1]=value;
                                  },
                                  
                                  toOperator: true,
                                ) 
                            ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: selectedCola,
                                builder:(context, value, _) {
                                  return Container(
                                    height: 40,
                                    width: 180,
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.amber),
                                      borderRadius: BorderRadius.circular(40)
                                    ),
                                    child: DropdownButton<String>(
                                     underline: SizedBox(),
                                      elevation:2,
                                      icon:Row(
                                       
                                        children: [
                                          Image(
                                            width: 30,
                                            height: 30,
                                            image: AssetImage("shapes/side_dishes/cola.png"),
                                          ),
                                          Icon(
                                            Icons.arrow_circle_down
                                          ),
                                        ],
                                      ),

                                      value: value,
                                      
                                      items: dishesListCola.map((valuelist){
                                        dishesName[2]=selectedCola.value;
                                        return DropdownMenuItem<String>(
                                          alignment: AlignmentGeometry.center,
                                          value:valuelist,
                                          child: Text(
                                            valuelist,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black54,
                                              fontFamily: "Metropolis",
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                        );
                                      }).toList(),

                                      onChanged:(newValue) {
                                        
                                        selectedCola.value=newValue.toString();
                                        dishesName[2]=newValue.toString();
                                        
                                      },
                                    ),
                                  );
                                },
                              ),
                               

                                CounterBox(
                                  count: 0,
                                  onChanged: (value){
                                   
                                    numberAdd[2]=value;
                                   
                                  },
                                  toOperator: true,
                                )
                            ],
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: selectedFanta,
                                builder: (context, value, _) {
                                  return Container(
                                    height: 40,
                                    width: 180,
                                    padding: EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.amber),
                                      borderRadius: BorderRadius.circular(40)
                                    ),
                                    child:  DropdownButton(
                                     
                                      underline: SizedBox(),
                                      elevation:2,
                                      icon:Row(
                                       
                                        children: [
                                          Image(
                                            width: 30,
                                            height: 30,
                                            image: AssetImage("shapes/side_dishes/fanta.png"),
                                          ),
                                          Icon(
                                            Icons.arrow_circle_down
                                          ),
                                        ],
                                      ),

                                      value: value,
                                      
                                      items: dishesListFanta.map((valueList){
                                        dishesName[3]=selectedFanta.value;
                                        return DropdownMenuItem<String>(
                                          
                                          alignment: AlignmentGeometry.center,
                                          value:valueList,
                                          child: Text(
                                            valueList,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black54,
                                              fontFamily: "Metropolis",
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                        );
                                      }).toList(),

                                      onChanged:(newValue) {
                                      
                                        selectedFanta.value=newValue;
                                        dishesName[3]=newValue.toString();
                                      
                                      },
                                    )
                                  );
                                },
                              ),
                              
                              CounterBox(
                                onChanged: (value){                                    
                                  
                                  numberAdd[3]=value;
                                },
                                toOperator: true,
                              )
                                
                            ],
                        ), 
                       
                    ],
                ),
             ),
             SizedBox(height:50 ,),
              Material(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: (){
                        
                        if(getText.text.isNotEmpty){
                            displayAlert(context);
                            Future.delayed(Duration(seconds: 1),(){
                                orderDB(getText.text,widget.orderName, numberAdd,dishesName);
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context)=>MenuScreen()),
                                 (_)=>false
                                );
                            });
                        }
                        
                        else if(getText.text.isEmpty){
                            displayError(context);
                        }
                        
                      
                       
                    },
                    child: Container(
                        width: 220,
                        height: 60,
                        alignment: Alignment.center,
                        
                        decoration: BoxDecoration(
                            //border: Border.all(color: Colors.amber,width: 2),
                            borderRadius: BorderRadius.circular(10),
                            //color: !toColor? Colors.transparent:Colors.amber
                            color: Colors.amber.shade200
                        ),
                        child: Text(
                            "Sifariş ver",
                            style:TextStyle(
                                fontSize: 25,
                                color: Colors.black.withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold
                            ) ,
                        ),
                    )
                ),
              )
            ],
          ),
        ),
      )
      
    );
  }
  void displayAlert(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
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
        },
    );
  }
  void displayError(BuildContext context){
    showDialog(
        context: context,
        builder: (context) {
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
                            "shapes/splash_anime/location.json",
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
        },
    );
  }
}
