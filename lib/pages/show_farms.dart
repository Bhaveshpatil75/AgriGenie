import 'package:cosine/pages/addFarm_page.dart';
import 'package:cosine/pages/show_each_farm.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:cosine/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowFarms extends StatefulWidget {
   ShowFarms({super.key});

  @override
  State<ShowFarms> createState() => _ShowFarmsState();
}

class _ShowFarmsState extends State<ShowFarms> {
  late DatabaseService _databaseService;
  List list=[];
  @override
  void initState() {
    _databaseService=DatabaseService(uid: AuthService.firebase().currentUser!.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Farms"),
      ),
      body:
      StreamBuilder<List<dynamic>>(
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading();
          }
          else {
            list = snapshot.data!;
            return list.isEmpty ? Center(child: Text("No Farms")) :
            ListView.builder(itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  tileColor: Colors.blueGrey[200],
                  leading: CircleAvatar(child: Text("${index + 1}"),),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddfarmPage(farmName: list[index],)));
                        }, icon: FaIcon(FontAwesomeIcons.pen)),
                        IconButton(onPressed: () async {
                          try {
                            await _databaseService.deleteFarm(list[index]);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Farm deleted successfully")));
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Deletion failed...")));
                          }
                        }, icon: Icon(Icons.delete),),
                      ],
                    ),
                  ),
                  title: Text(list[index]),
                  onTap: () async {
                    var data = await _databaseService.getAfarm(list[index]);
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>
                        ShowEachFarm(
                            farmName: list[index], data: data.toString())));
                  },
                ),
              );
            },itemCount: list.length);
          }
        }
        , stream: _databaseService.getFarms(),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>AddfarmPage()));
      },child: Icon(Icons.add),
      ),
    );
  }
}
