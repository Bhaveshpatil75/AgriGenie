
import 'package:cosine/pages/door_page.dart';
import 'package:cosine/pages/add_farmer.dart';
import 'package:cosine/pages/login_page.dart';
import 'package:cosine/pages/register_page.dart';
import 'package:cosine/pages/splash_page.dart';
import 'package:cosine/pages/verification_page.dart';
import 'package:cosine/private/private.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'constants/routes.dart';


const String  key=geminiKey;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
 Gemini.init(apiKey: key);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
      routes: {
        loginRoute:(context)=>LoginPage(),
        registerRoute:(context)=>RegisterPage(),
        verifyRoute:(context)=>VerifyPage(),
        homeRoute:(context)=>AddFarmerPage()
      },
    );
  }
}

class RoutePage extends StatelessWidget {
  const RoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) { //snapshots are like real time states from the future of FutureBuilder
          switch(snapshot.connectionState) {  //switching cases a/c to state of connection of snapshot
            case ConnectionState.done: //in case if connection is established
              final curUser=AuthService.firebase().currentUser;
              if (curUser != null) {
                if (curUser.isEmailVerified) {
                  return DoorPage();
                } else {
                  return const VerifyPage();
                }
              }
              else{
                return const LoginPage();
                //return const DoorPage();
              }
            default:  //all other cases such as none and so on
              return Loading();
          }
        },
      ),
    );
  }
}








