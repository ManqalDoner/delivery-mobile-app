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

import 'pages/closeApp.dart';

final String supebaseUrl="";
final String supebaseKey="";

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
        "/":(context)=>Closeapp(child:NetworkServer(child: SplashScreen(),)),
        "Register":(context)=>Closeapp(child:  NetworkServer(child: RegisterScreen())),
        "Menu":(context)=>Closeapp(child:NetworkServer(child:MenuScreen())),
        "OrderList":(context)=>Closeapp(child:  NetworkServer(child:Oerderlist())),
        "Account":(context)=>Closeapp(child:  NetworkServer(child:AccountScreen()))
      },
      
      //home: Closeapp(child:NetworkServer(child:SplashScreen())),
      
      
      
    );
  }
}

