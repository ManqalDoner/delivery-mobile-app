import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:supabase_flutter/supabase_flutter.dart";



class Closeapp extends StatelessWidget{
  final Widget child;
  
  Closeapp({super.key,required this.child});

  Stream<List<Map<String,dynamic>>> ControllDB() async*{
     final getControll=await Supabase.instance.client
      .from("MobileControll")
      .select("controll");
      
    yield getControll;
  }

  Widget build(BuildContext context){
    return Scaffold(

      body: StreamBuilder(
        stream: ControllDB(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return child;
          }

          final controll=snapshot.data!;
          if(controll[0]["controll"]!){
             return Center(
              child: ClosePage(),
             );
          }else{
             return child;
          }
        },
      )
    );

  }
  ClosePage(){
    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      
      
      children: [
        Lottie.asset("shapes/splash_anime/Close.json",width: 500,height: 500),
        Text(
          "Manqal Döner Bağlıdır.",
            style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.black54
            ),
        )
      ],
    );
  }
}