
import 'package:flutter/material.dart';

Future<bool> showDialogLogOut(BuildContext context){
  return showDialog<bool>(context: context, builder: (context){
    return AlertDialog(
      title: Text("Log Out!!"),
      content: Text("Are you sure you want to Log out??"),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: Text("Cancel")),
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        },  child:Text("Log out")),
      ],
    );
  }
  ).then((value)=> value ?? false);
}