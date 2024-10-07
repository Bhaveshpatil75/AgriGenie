import 'dart:developer';

import 'package:cosine/constants/questions.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/auth/auth_user.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddfarmPage extends StatefulWidget {
  const AddfarmPage({super.key});

  @override
  State<AddfarmPage> createState() => _AddfarmPageState();
}

class _AddfarmPageState extends State<AddfarmPage> {
  final  _formKey=GlobalKey<FormBuilderState>();
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
        title: Text("ADD FARM"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            FormBuilderTextField(name: "name",decoration: InputDecoration(
              hintText: farmQue[0]
            ),
            ),
            FormBuilderCheckboxGroup(name: "watersrc", decoration: InputDecoration(
              hintText: farmQue[1]
            ),
                options: ["well","pond","tube well","None"].map((val)=>FormBuilderFieldOption(value: val)).toList()),
            FormBuilderSlider(name: "waterTime", initialValue: 0, min: 0, max: 24,
              divisions: 48,
              decoration: InputDecoration(
                  label: Text(farmQue[2])
              ),
            ),
            FormBuilderTextField(name: "size",decoration: InputDecoration(
              hintText: farmQue[3]
            ),),
            FormBuilderSwitch(name: "emp", title: Text(farmQue[4]),initialValue: false,onSaved: (val)=>val ?? false,),
            ElevatedButton(onPressed: ()async{
              if(_formKey.currentState!.isValid){
                _formKey.currentState!.saveAndValidate();
                Map<String,dynamic> map=Map.from(_formKey.currentState!.value);
                map.remove("name");
                //log(map.toString());
                await _databaseService.addFarm(_formKey.currentState!.fields["name"]!.value, map);
                Navigator.pop(context);
              }
            }, child: Text("Create"))
          ],
        ),
      ),
    );
  }
}
