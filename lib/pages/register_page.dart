
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../dialogs/show_error_dialog.dart';
import '../services/auth/auth_exceptionss.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_service.dart';
import '../widgets/loading.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {

  var em=TextEditingController();
  var ps=TextEditingController();
  var cps=TextEditingController();
  var name=TextEditingController();
 late bool loading,showPass,showCPass;
 @override
  void initState() {
    loading=showPass=showCPass=false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return loading? Loading():Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Register"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                  controller: em,
                  decoration: InputDecoration(
                    hintText: "Email",
                      suffixIcon: Icon(Icons.mail)
                  )
              ),
              TextField(
                controller: ps,
                obscureText: !showPass,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      showPass=!showPass;
                    });
                  }, icon: Icon(showPass?Icons.remove_red_eye:Icons.remove_red_eye_outlined),),
                ),
              ),
              TextField(
                controller: cps,
                obscureText: !showCPass,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  suffixIcon: IconButton(onPressed: () {
                    setState(() {
                      showCPass=!showCPass;
                    });
                  }, icon: Icon(showCPass?Icons.remove_red_eye:Icons.remove_red_eye_outlined),),
                ),
              ),
              TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: "Name",
                  )
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    ps.text != cps.text? throw NotMatchException():null;
                    setState(() {
                      loading=true;
                    });
                    await AuthService.firebase().createUser(
                      email: em.text,
                      password: ps.text
                    );
                    //await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).addUser(name.text);
                    final user=FirebaseAuth.instance.currentUser;
                    user?.updateDisplayName(name.text);
                    await AuthService.firebase().sendVerificationMail();
                    Navigator.pushNamed(context,verifyRoute);

                  } on NotMatchException {
                    await showErrorDialog(context, "Password and Confirm password must be same");
                    loading=false;
                  } on EmailAlreadyInUseAuthException {//catching the exception if creation of user fails
                    await showErrorDialog(context, "Email already Taken");//various types of exception could be handled here. (like we did in Loginpage)
                    setState(() {
                      loading=false;
                    });
                  }on WeakPasswordAuthException{
                    await showErrorDialog(context, "Password is too Weak");
                    setState(() {
                      loading=false;
                    });
                  }on InvalidEmailAuthException{
                    await showErrorDialog(context, "Invalid Email");
                    setState(() {
                      loading=false;
                    });
                  }on GenericAuthException {
                    await showErrorDialog(context, "Something went wrong!!");
                    setState(() {
                      loading=false;
                    });
                  }
                },
                child: Text("Register"),
              ),
              SizedBox(height: 20,),
              ElevatedButton(onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
              },  child: Text("Already registered? Login Now!!"))
            ],
          ),
        )
    );
  }
}

 class NotMatchException implements Exception{}