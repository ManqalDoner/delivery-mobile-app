import 'package:delivery_app/network.dart';
import 'package:delivery_app/pages/account_screen.dart';
import 'package:delivery_app/pages/closeApp.dart';
import 'package:delivery_app/pages/menu_screen.dart';
import 'package:delivery_app/pages/network_screen.dart';
import 'package:delivery_app/pages/oerderList.dart';
import 'package:delivery_app/pages/order.dart';
import 'package:delivery_app/pages/register_screen.dart';
import 'package:delivery_app/splash_screen.dart';
import 'package:delivery_app/widgets/_counterBtn.dart';
import 'package:delivery_app/widgets/_order_list_box.dart';
import 'package:delivery_app/widgets/map_display.dart';
import 'package:flutter/material.dart';
import "package:flutter/services.dart";

//subebase Db
import "package:supabase_flutter/supabase_flutter.dart";

import "package:delivery_app/pages/closeApp.dart";

final String supebaseUrl="https://gxkkcuayjovzvbsfhkoz.supabase.co";
final String supebaseKey="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd4a2tjdWF5am92enZic2Zoa296Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2NDUwMzksImV4cCI6MjA3NzIyMTAzOX0.W7IIqzWfuK_qMk67vPD6allqChe69TOlvE0ujPP_Wok";

Future<void> main() async {
 await Supabase.initialize(
    url: supebaseUrl, 
    anonKey: supebaseKey
  );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        "/":(context)=>NetworkServer(child:  Closeapp(child:SplashScreen())),
        "Register":(context)=>NetworkServer(child: RegisterScreen()),
        "Menu":(context)=>NetworkServer(child:Closeapp(child:MenuScreen())),
        "OrderList":(context)=>NetworkServer(child:Oerderlist()),
        "Account":(context)=> NetworkServer(child:AccountScreen())
      },
      
      //home: Closeapp(child:NetworkServer(child:SplashScreen())),
       
    );
  }
}

