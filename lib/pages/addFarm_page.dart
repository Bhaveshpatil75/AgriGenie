
import 'dart:developer';

import 'package:cosine/constants/questions.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:cosine/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddfarmPage extends StatefulWidget {
  String? farmName;
   AddfarmPage({super.key,this.farmName});

  @override
  State<AddfarmPage> createState() => _AddfarmPageState();
}

class _AddfarmPageState extends State<AddfarmPage> {
  final  _formKey=GlobalKey<FormBuilderState>();
  late DatabaseService _databaseService;
  Map<String,dynamic>? initData;
  @override
  void initState() {
    _databaseService=DatabaseService(uid: AuthService.firebase().currentUser!.uid);
    fetchData();
    super.initState();
  }
  Future<void> fetchData()async{
    if (widget.farmName!=null){
      initData=(await _databaseService.getAfarm(widget.farmName!)) as Map<String, dynamic>?;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD FARM"),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }else{
        return FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(name: "name",initialValue: widget.farmName,
                decoration: InputDecoration(
                hintText: farmQue[0]
              ),
              ),
              FormBuilderCheckboxGroup(name: "watersrc", initialValue: initData == null ? null : (initData?["watersrc"] as List<dynamic>).map((item) => item as String).toList(),
                  decoration: InputDecoration(
                hintText: farmQue[1]
              ),
                  options: ["well","pond","tube well","None"].map((val)=>FormBuilderFieldOption(value: val)).toList()),
              FormBuilderSlider(name: "waterTime", initialValue: initData==null?0:initData?["waterTime"], min: 0, max: 24,
                divisions: 48,
                decoration: InputDecoration(
                    label: Text(farmQue[2])
                ),
              ),
              FormBuilderTextField(name: "size", initialValue: initData==null?"0":initData?["size"],decoration: InputDecoration(
                hintText: farmQue[3]
              ),),
              FormBuilderSwitch(name: "emp", title: Text(farmQue[4]),initialValue: initData==null?false:initData?["emp"],onSaved: (val)=>val ?? false,),
              ElevatedButton(onPressed: ()async{
                if(_formKey.currentState!.isValid){
                  _formKey.currentState!.saveAndValidate();
                  Map<String,dynamic> map=Map.from(_formKey.currentState!.value);
                  map.remove("name");
                  if (initData==null) {
                    await _databaseService.addFarm(
                        _formKey.currentState!.fields["name"]!.value, map);
                  }else{
                    await _databaseService.editFarm(widget.farmName!, _formKey.currentState!.fields["name"]!.value, map);
                  }
                  Navigator.pop(context);
                }
              }, child: Text(initData==null?"Create":"Update"))
            ],
          ),
        );}},
      ),
    );
  }
}