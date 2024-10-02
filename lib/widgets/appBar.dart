
import 'package:flutter/material.dart';
import '../dialogs/show_error_dialog.dart';
import '../enums/menu_actions.dart';
import '../services/open_url.dart';

PreferredSizeWidget? MyAppbar(BuildContext context,String title){
  return AppBar(
    title: Text("$title"),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    actions: [
      IconButton(onPressed: ()async{
      //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatListPage()));
      }, icon: Icon(Icons.chat)),
      PopupMenuButton<MenuAction>(itemBuilder: (value){
        return [
          PopupMenuItem(child: Text("New Game"),value: MenuAction.newGame,),
          PopupMenuItem(child: Text("Previous Matches"),value: MenuAction.records,),
          PopupMenuItem(child: Text("Global Rankings"),value: MenuAction.globalRank,),
          PopupMenuItem(child: Text("Feedback"),value: MenuAction.feedback,),
        ];
      },
        onSelected: (value)async{
        switch(value){
          case MenuAction.newGame:
            //Navigator.pushNamedAndRemoveUntil(context, tossRoute, (_)=>false);
          case MenuAction.records:
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>const Records()));
          case MenuAction.feedback:
            try{
             await openUrl("https://flutter.dev");
            }catch(e){
              await showErrorDialog(context, "Error in opening URL");
            }
          case MenuAction.globalRank:
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>()));
        }
        },
      )
    ],
  );
}