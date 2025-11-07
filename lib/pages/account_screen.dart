import "package:flutter/material.dart";
import "package:curved_navigation_bar/curved_navigation_bar.dart";
import "package:flutter/services.dart";
import "dart:math";
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class AccountScreen extends StatefulWidget{
  State<StatefulWidget> createState()=>_accountscreen();
}

class _accountscreen extends State<AccountScreen>{
  // the data change and save 
  bool onOff=true;

  bool onBtn=false;
  
  final random=Random();
  
  int nextShape=0;
  // data process
  List<TextEditingController> _accountData=List.generate(2,(_)=>TextEditingController());
  String Username="";
  // Error valid
  String? Error_tel,Error_address;
  // profile image
  List<String> ProfileShape=[
    "shapes/profile/account.jpg",
    "shapes/profile/account2.jpg",
    "shapes/profile/account3.jpg",
    "shapes/profile/account4.jpg",
    "shapes/profile/account5.jpg",
    "shapes/profile/account6.jpg",
  ];
  // change profile image
  
  void initState(){
    super.initState();
    _accountData.forEach((action){
      action.addListener((){
        if(Error_address!=null||Error_tel!=null){
          setState(() {
            Error_address=null;
            Error_tel=null;
          });
          
        }
      });
    });
    nextShape=random.nextInt(ProfileShape.length-1);
    
  }
  //this function: the User data for the display at Account page
  Stream<List<Map<String,dynamic>>> ShareData() async*{
    final prefs = await SharedPreferences.getInstance();
    // get each User Id
    final userId = prefs.getInt('id'); 
   
    //we clear user from DB and old user_id will clear.
    if(userId==null){
      prefs.clear();
      return;
    }
    final dbUser= await Supabase.instance.client.from("User").stream(primaryKey: ["user_id"]).eq("user_id",userId);
    
    yield* dbUser;
    
  }

  // Account page : upgrade profil==> (Address and Tel number)
  upgradeData(value) async{
    final prefs = await SharedPreferences.getInstance();    
    final userId = prefs.getInt('id'); 

    if(userId==null){
      prefs.clear();
      return;
    }
    else if(value[0].text.isNotEmpty &&value[1].text.isNotEmpty){
      await Supabase.instance.client.from("User")
      .upsert({
        "user_id":userId,
        "Tel":value[0].text,
        "Address":value[1].text
      })
      .eq("user_id",userId)
      .select();
      
    }else{
      if(value[0].text.isEmpty){
        Error_tel="Nömüre yeri boşdur.";
      }
      else if(value[1].text.isEmpty){
        Error_address="Ünvan yeri boşdur.";
      }
    }
    
  }

  Widget build(BuildContext context){
    return Scaffold (
      //Section: Bottom Nav bart
      bottomNavigationBar:SafeArea(
        child: CurvedNavigationBar(
          height: 50,
          index: 2,
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
                  case 1:
                    Navigator.pushReplacementNamed(context, "Menu");
                  
                }
              });
          },
        ),
      ),
      body:StreamBuilder (
        stream:ShareData(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator()
            );
            
          };
          final account=snapshot.data!;
          if(!onBtn){
            if(account.isNotEmpty){
                Username=account[0]["Username"];
                _accountData[0].text=account[0]["Tel"];
                _accountData[1].text=account[0]["Address"];
            }
          }
           
        
          return  SafeArea(  
            child:  Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.all(60),
              child: SingleChildScrollView(
                child: Column(

                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage(ProfileShape[nextShape]),
                  ),
                  //Username
                  Padding(
                    padding: EdgeInsets.all(20),
                    child:RichText(
                      text: TextSpan(
                        text: "@",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.amber,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500
                        ),
                        children: [
                          TextSpan(
                            //we add data in here
                            text: Username,
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: 0.5),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.normal,
                              
                            )
                          ),
                        ]
                      ),
                    ),
                  ),
                  //tel and address box      
                  CustomBox(),
                     
                  
                ],
              ),
              )
            ),  
          
          );
          

        }
      )
      
    );
  }
  Widget CustomBox(){
    return Column(
        children: [
          
          Padding(
            padding: EdgeInsets.all(10),
            child:TextField(
              controller: _accountData[0],
              readOnly: onOff,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 10,
              decoration: InputDecoration(
                errorText: Error_tel,
                counter: SizedBox.shrink(),
                errorStyle: TextStyle(color:Colors.red.shade400,fontSize: 15,fontWeight: FontWeight.bold),
                
                prefixIcon: Icon(Icons.call,color: Colors.amber,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.amber,width: 2)
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child:TextField(
              controller: _accountData[1],
              style: TextStyle(
                fontFamily: "NatoSans"
              ),
              readOnly: onOff,
              decoration: InputDecoration(
                counter: SizedBox.shrink(),
                errorText: Error_address,
                errorStyle: TextStyle(color:Colors.red.shade400,fontSize: 15,fontWeight: FontWeight.bold, fontFamily: "NatoSans"),
                
                prefixIcon: Icon(Icons.location_on,color: Colors.amber,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.amber,width: 2)
                )
              ),
            ),
          ),
          SizedBox(height: 40,),
          Flex(
            direction:Axis.horizontal,
            
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            spacing: 30,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: (){
                  setState(() {
                    onOff=false;
                    onBtn=true;
                  });
                },

                child: Container(
                  width: 110,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.withValues(alpha: 0.7)),
                    borderRadius: BorderRadius.circular(15),
                    color: onOff? Colors.red.withValues(alpha: 0.7):Colors.white
                  ),
                  child: Text(
                    "Deyişiklik",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.6)
                    ),
                  ),
                )
                
              ),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: (){
                  setState(() {
                    onOff=true;
                  });
                  upgradeData(_accountData);
                },

                child: Container(
                  width: 100,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.withValues(alpha: 0.7)),
                    borderRadius: BorderRadius.circular(15),
                    color:  onOff? Colors.white:Colors.green.withValues(alpha: 0.7)
                  ),
                  child: Text(
                    "Saxla",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withValues(alpha: 0.6)
                    ),
                  ),
                )
                
              ),
            ],
          )
        ],
      
    );
  }
}