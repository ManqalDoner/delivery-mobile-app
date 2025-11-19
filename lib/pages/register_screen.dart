
import "package:delivery_app/FloatingNavigation.dart";
import "package:flutter/material.dart";
import "dart:async";
import "package:shared_preferences/shared_preferences.dart";
import "package:flutter/services.dart";
import "package:supabase_flutter/supabase_flutter.dart";

final supabase=Supabase.instance.client;

class RegisterScreen  extends StatefulWidget{

  State<RegisterScreen> createState()=>_Register();

}


class _Register extends State<RegisterScreen>{
  ScrollController _scrollController=ScrollController();
  late Timer _timer;
  bool BtnColor=false;
  int count=0;
  // Form Validation Controller
  final List<TextEditingController> getData=List.generate(3,(index)=>TextEditingController());
  String? Error_Valid_name ,Error_Valid_tel ,Error_Valid_address;
  

  //the shapes belongs to Title bar at Register pages
  List<String> tileShapes=[
    "shapes/images/shape1.jpg",
    "shapes/images/shape2.jpg",
    "shapes/images/shape3.jpg",
    "shapes/images/shape4.jpg",
    "shapes/images/shape5.jpg",
    "shapes/images/shape6.jpg",

  ];
  //BackEend
  sendData(value) async{
    final supabase=await Supabase.instance.client.from("User").insert({
      "Username":value[0].text,
      "Tel":value[1].text,
      "Address":value[2].text
    }).select();
    
    
    if(supabase.isNotEmpty){
      final user=supabase.first;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', user["user_id"]);
      await prefs.setString('username', user["Username"]);
     
      print('User saved locally.');
      
    }
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>NavigationPages()),(_)=>false);
   
      
  }
  
  void initState(){
    super.initState();
    //
    //SharedData();
    //validate section
    getData.forEach((value){
        value.addListener((){
            if(Error_Valid_name!=null||Error_Valid_tel!=null||Error_Valid_address!=null){
                setState(() {
                  Error_Valid_name=null;
                  Error_Valid_tel=null;
                  Error_Valid_address=null;
                });
            }
            // button color change
            setState(() {
              if(getData[0].text.isNotEmpty&&getData[1].text.isNotEmpty&&getData[2].text.isNotEmpty){
                  BtnColor=true;
                }
                else{
                    if(getData[0].text.isEmpty||getData[1].text.isEmpty||getData[2].text.isEmpty){
                        
                        BtnColor=false;
                    }
                }
                DataExpression();
            });
            
        });
    });
    

    // title Shabe section
    _timer=Timer.periodic(Duration(milliseconds: 20),(_){
      if(_scrollController.hasClients){
        
        double currentScroll = _scrollController.offset + 1;
        
        if (currentScroll >= _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
        
        } else {
          _scrollController.jumpTo(currentScroll);
          
        }
      }
      
    });

  }
 
  //Processing of send data
  void DataProcess(context){
    setState(() {
        if(getData[0].text.isEmpty){
            Error_Valid_name="Ad ve Soyad yeri boşdur.";
        }else if(getData[1].text.isEmpty){
            Error_Valid_tel="Nömüre yeri boşdur.";
        }else if(getData[2].text.isEmpty){
            Error_Valid_address="Ünvan yeri boşdur.";
        }
       //next menu page
       else if(getData[0].text.isNotEmpty&&getData[1].text.isNotEmpty&&getData[2].text.isNotEmpty){
          sendData(getData);
          //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context)=>AccountScreen()),(_)=>false);
          
       }
    });
    
  }
  // alert Message
  

  //Regular Expression and Syntax errors on Data
  void DataExpression(){
    if(getData[0].text.isNotEmpty||getData[2].text.isNotEmpty){
        final chr=RegExp(r'[^\w\s]');
        if(chr.hasMatch(getData[0].text)){
            getData[0].text=getData[0].text.substring(0,getData[0].text.length-1);
            
        }
        /*
        else if(chr.hasMatch(getData[2].text)||getData[2].text.contains("_")){
            getData[2].text=getData[2].text.substring(0,getData[2].text.length-1);
        }
        */
    }
  }

  //Custom Images
  Widget CustomShape({item}){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          width: 120,
          height: 140,
          image: AssetImage(item.toString()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  // Create Register body
  Widget build(BuildContext context){
    // Create dublicats list items
    final itemShape=List.generate(50,(index){
      final getShape=tileShapes[index%tileShapes.length];
      
      return CustomShape(item: getShape);
    });
    //Title shape and Register forms
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(220), // set height for your shape
          child: AppBar(
            automaticallyImplyLeading: false, // remove back arrow if not needed
            backgroundColor: Colors.transparent, // transparent so your shape shows
            shadowColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            flexibleSpace: Container(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 15),
              decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.elliptical(190, 80),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 0.8,
                    spreadRadius: 0.2,
                  )
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350,
                      height: 140,
                      child: ListView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: itemShape,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),


      body:SingleChildScrollView(
          child:CustomRegister(context) ,
      )
                  
                   
                  
    );
  }
  //Create Reg form
  Widget CustomRegister (context){
    
    return Container(
       
        padding: EdgeInsets.all(30),
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          
          children: [
          
            Padding(
              padding: EdgeInsets.all(10),
              child:TextField(
                controller: getData[0],
                maxLength: 25,
                style: TextStyle(
                 
                ),
                decoration: InputDecoration(
                  counter: SizedBox.shrink(),
                  errorText: Error_Valid_name,
                  errorStyle: TextStyle(color:Colors.red.shade400,fontSize: 15,fontWeight: FontWeight.bold,),
                  hintText: "Ad ve Soyad",
                  prefixIcon: Icon(Icons.account_circle,color: Colors.amber,),
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
                controller: getData[1],
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                
                decoration: InputDecoration(
                    counter: SizedBox.shrink(),
                    errorText: Error_Valid_tel,
                    errorStyle: TextStyle(color:Colors.red.shade400,fontSize: 15,fontWeight: FontWeight.bold),
                    icon: Icon(Icons.phone),
                    iconColor: Colors.amber,
                    hintText: "Tel",
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
              child:TextFormField(
                controller: getData[2],
                style: TextStyle(
                  fontFamily: "NatoSant"
                ),
                decoration: InputDecoration(
                  errorText: Error_Valid_address,
                  errorStyle: TextStyle(color:Colors.red.shade400,fontSize: 15,fontWeight: FontWeight.bold, fontFamily: "NatoSans"),
                  icon: Icon(Icons.location_on),
                  iconColor: Colors.amber,
                  hintText: "Ünvan daxil edin",
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

            //here is click button
            Padding(
                padding: EdgeInsets.all(30),
               child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: ()=>DataProcess(context),
                    
                    child:Container(
                        width: 200,
                        height: 60,
                        //padding: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                            border: Border.all(color:  Colors.amber,width: 2),
                            color:BtnColor? Colors.amber:Colors.white12,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child:Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                    "Davam Et",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black45
                                    ),
                                ),
                                SizedBox(width: 8,),
                                Icon(
                                    Icons.arrow_forward,
                                    color:Colors.black54 ,
                                    size: 30,
                                )
                            ],

                        ), 
                    )
                     
                ),
            ),
           
           //here is logo
          Container(
              margin: EdgeInsets.only(top: 50),
              child: ListTile(
                
                leading: Image(
                  image: AssetImage("shapes/logo/logo.png"),
                ),
                title:  Text("Manqal Döner",style: TextStyle(fontFamily: "Metropolis",fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black.withValues(alpha: 0.5)),textAlign: TextAlign.start,),
              ),
          ),
            
            
          ],
        ),
      
    );
    
  }
}