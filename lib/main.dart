import 'package:delivery_app/FloatingNavigation.dart';
import 'package:delivery_app/notification_service.dart';
import 'package:delivery_app/network.dart';
import 'package:delivery_app/pages/closeApp.dart';
import 'package:delivery_app/pages/register_screen.dart';
import 'package:delivery_app/splash_screen.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";


//subebase Db
import "package:supabase_flutter/supabase_flutter.dart";


final String supebaseUrl="***********";
final String supebaseKey="************";

main() async {
 await Supabase.initialize(
    url: supebaseUrl, 
    anonKey: supebaseKey
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  //Notification Server
  await NotificationService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Manqal Döner",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Metropolis"
      ),
      
      initialRoute: "/",
      routes: {
        "/":(_)=>NetworkServer(child:  Closeapp(child:SplashScreen())),
        "Register":(_)=>NetworkServer(child: RegisterScreen()),
        "Menu":(_)=>NetworkServer(child:Closeapp(child:NavigationPages())),
       
      },
      
     
       
    );
  }
}



