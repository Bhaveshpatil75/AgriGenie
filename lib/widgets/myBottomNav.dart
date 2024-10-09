import 'package:cosine/pages/show_farms.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final List<Widget>list=[ShowFarms(),ShowFarms(),ShowFarms()];

BottomNavigationBar MyBottomNav(BuildContext context){
  return BottomNavigationBar(items: [
    BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.leaf),
        label:"My Farms" ,
    ),

    BottomNavigationBarItem(icon: Icon(Icons.add),label: "two"),
    BottomNavigationBarItem(icon: Icon(Icons.add),label: "three"),

  ],onTap: (index){
    Navigator.push(context, MaterialPageRoute(builder: (_)=>list[index]));
  },
  );
}