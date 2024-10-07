import 'package:cosine/pages/show_details.dart';
import 'package:cosine/pages/show_farms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../constants/routes.dart';
import '../dialogs/show_logout_dialog.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_service.dart';



Drawer MyDrawer(BuildContext context){
  var userName=FirebaseAuth.instance.currentUser!.displayName??"User";
  DatabaseService databaseService=DatabaseService(uid: AuthService.firebase().currentUser?.uid);
  userName=userName==""?"User":userName;
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            child: DrawerHeader(
                child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    currentAccountPicture:CircleAvatar(
                      child: Text(userName.substring(0,1)),)
                    ,accountName: Text(userName) , accountEmail:Text(FirebaseAuth.instance.currentUser?.email??""))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              tileColor: Colors.deepPurple.shade100,
              title: Text("Log Out"),
              onTap: ()async{
                final isLoggedOut=await showDialogLogOut(context);
                if (isLoggedOut){
                  await AuthService.firebase().logOut();
                  Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route)=>false);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              tileColor: Colors.deepPurple.shade100,
              title: Text("My details"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ShowDetails()));
              },
            ),
          ),
          ListTile(
            tileColor: Colors.deepPurple.shade100,
            title: Text("My Farms"),
            onTap: ()async{

              Navigator.push(context, MaterialPageRoute(builder: (_)=>ShowFarms()));
            },
          ),
        ],
      ),
    );
  }
