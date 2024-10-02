import 'package:flutter/material.dart';

class ShowEachFarm extends StatelessWidget {
  dynamic data;
   ShowEachFarm({super.key,required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FARM"),
      ),
      body: Center(child:Text(data.toString())),
    );
  }
}
