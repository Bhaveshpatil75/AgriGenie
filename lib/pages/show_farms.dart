import 'package:cosine/pages/addFarm_page.dart';
import 'package:cosine/pages/show_each_farm.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:flutter/material.dart';

class ShowFarms extends StatefulWidget {
  late List list;
   ShowFarms({super.key,required this.list});

  @override
  State<ShowFarms> createState() => _ShowFarmsState();
}

class _ShowFarmsState extends State<ShowFarms> {
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
        title: Text("Farms"),
      ),
      body: widget.list.length==0?Center(child:Text("No Farms")):
      ListView.separated(itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              tileColor: Colors.blueGrey[200],
              leading: CircleAvatar(child: Text("${index+1}"),),
              title: Text(widget.list[index]),
              onTap: ()async{
                var data=await _databaseService.getAfarm(widget.list[index]);
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ShowEachFarm(data: data)));
              },
            ),
          ),
        );
      }, separatorBuilder: (context,index){
        return Divider(thickness: 3,);
      }, itemCount: widget.list.length),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_)=>AddfarmPage()));
      },child: Icon(Icons.add),
      ),
    );
  }
}
