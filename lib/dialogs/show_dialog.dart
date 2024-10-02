import "package:flutter/material.dart";

Future<void> showMsg(BuildContext context,String title,String content)async{
  return showDialog(context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("Continue"))
        ],
      );
    },
  );
}