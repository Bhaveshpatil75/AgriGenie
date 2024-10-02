import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';

class SplashPage extends StatefulWidget{
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() { //managing the state initially
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RoutePage()));  //calling homepage from old_main1.dart
    });//using pushReplacement will not add splash_page to stack hence when user hits back from homepage he will be exited directly rather than switching to splashPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.blueGrey[200],
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("COSINE",style: TextStyle(fontSize: 30,fontFamily: "Font1",color: Colors.black,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            //Text("   -By Bhavesh Patil",style: TextStyle(fontSize: 20,color: Colors.black,))
          ],
        )),
      ),
    );
  }
}