import 'package:cosine/pages/addFarm_page.dart';
import 'package:cosine/pages/add_crop.dart';
import 'package:cosine/pages/show_each_crop.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:cosine/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShowEachFarm extends StatefulWidget {
  dynamic data;
  String farmName;
   ShowEachFarm({super.key,required this.data,required this.farmName});

  @override
  State<ShowEachFarm> createState() => _ShowEachFarmState();
}

class _ShowEachFarmState extends State<ShowEachFarm> {
  late List farmList=[];
  late DatabaseService _databaseService;
  late String geminiData;
  @override
  void initState() {
    _databaseService=DatabaseService(uid: AuthService.firebase().currentUser!.uid);
    geminiData=widget.data;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.farmName),
      ),
      body: Column(
        children: [
          Center(child:Text(widget.data.toString())),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: _databaseService.getCrops(widget.farmName),
              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                } else {
                  farmList=snapshot.data??[];
                  return snapshot.hasData? ListView.separated(itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(farmList[index]),
                        tileColor: Colors.blueGrey[200],
                        leading: CircleAvatar(child: Text("${index + 1}"),),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>AddCrop(farmName: widget.farmName,cropName: farmList[index],)));
                              }, icon:const  FaIcon(FontAwesomeIcons.pen)),
                              IconButton(onPressed: () async {
                                await _databaseService.deleteCrop(
                                    widget.farmName, farmList[index]);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Deleted Successfully")));
                              }, icon: Icon(Icons.delete),),
                            ],
                          ),
                        ),
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        onTap: () async {
                          var data = await _databaseService.getAcrop(
                              widget.farmName, farmList[index]);
                          geminiData += data.toString();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (_) =>
                                  ShowEachCrop(cropName: farmList[index],
                                    farmName: widget.farmName,
                                    data: data,
                                    geminiData: geminiData,)));
                        },
                      ),
                    );
                  }, separatorBuilder: (context, index) {
                    return const Divider(thickness: 3,);
                  }, itemCount: farmList.length):Center(child: Text("No Crops here..."));
                }
              }
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { 
          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddCrop(farmName: widget.farmName)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}