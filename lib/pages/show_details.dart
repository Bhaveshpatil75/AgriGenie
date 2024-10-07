import 'package:cosine/pages/add_farmer.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowDetails extends StatefulWidget {

   ShowDetails({super.key});

  @override
  State<ShowDetails> createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
   late DatabaseService _databaseService;

   @override
  void initState() {
     _databaseService=DatabaseService(uid: AuthService.firebase().currentUser!.uid);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: StreamBuilder<Map<String,dynamic>?>(
        stream: _databaseService.getFarmeranswers(),
        builder: (context, snapshot) {
          return Center(child: Text(snapshot.data.toString()));
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>AddFarmerPage()));
      },
        child: FaIcon(FontAwesomeIcons.pen),
      ),
    );
  }
}
