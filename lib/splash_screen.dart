import "package:delivery_app/pages/menu_screen.dart";
import "package:delivery_app/pages/register_screen.dart";
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:supabase_flutter/supabase_flutter.dart";

class SplashScreen extends StatelessWidget{

  // this fuction : User session section
  NextLayout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id'); // get user_id from shared prefs

    if (userId == null) {
      // No user session saved
     Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
          (_) => false,
        );
      });
      return;
    }

    // Query from Supabase safely
    final response = await Supabase.instance.client
      .from("User")
      .select()
      .eq("user_id", userId) // ✅ use integer, not string . we don't add  string id because it is only intiger
      .maybeSingle(); // Single process

    if (response == null) {
      // User deleted from DB → clear session
      await prefs.clear();
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => RegisterScreen()),
          (_) => false,
        );
      });
    } else {
      // User still exists → go to account
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>MenuScreen()),
          (_) => false,
        );
      });
    }
  }
     
  Widget build(BuildContext context){
    WidgetsBinding.instance.addPostFrameCallback((_){
      NextLayout(context);
    });
    final ScreenSize=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: ScreenSize.width/8),
          child: Lottie.asset(
            "shapes/splash_anime/splashDelivery.json",
            animate: true,
            reverse: false,
            repeat: true,
          ),
          
        )
      ),
    );

  }
}