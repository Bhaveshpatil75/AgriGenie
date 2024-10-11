import 'package:cosine/pages/addFarm_page.dart';
import 'package:cosine/pages/add_farmer.dart';
import 'package:cosine/pages/home_page.dart';
import 'package:cosine/pages/suggestions.dart';
import 'package:cosine/widgets/appBar.dart';
import 'package:flutter/material.dart';

class DoorPage extends StatefulWidget {
  const DoorPage({super.key});

  @override
  State<DoorPage> createState() => _DoorPageState();
}

class _DoorPageState extends State<DoorPage> {
  var users=["FARMER","OTHERS"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("welcome")),
      ),
      body: Center(
        child: ListView.separated(itemBuilder: (context,index)  {
          return ListTile(
            title: Text("${users[index]}"),
            onTap: ()async{
             await Navigator.push(context,MaterialPageRoute(builder: (_)=>HomePage()));
            },
            tileColor: Colors.blueGrey,
          );
        }, separatorBuilder: (context,index){
          return Divider(thickness: 15,);
        }, itemCount: 2)
      ),
    );
  }
}