import 'package:cosine/pages/add_farmer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowDetails extends StatelessWidget {
   dynamic data;
   ShowDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Center(child: Text(data.toString())),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>AddFarmerPage()));
      },
        child: FaIcon(FontAwesomeIcons.pen),
      ),
    );
  }
}
