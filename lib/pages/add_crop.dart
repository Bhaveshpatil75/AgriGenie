

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cosine/constants/questions.dart';
import 'package:cosine/pages/show_each_farm.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:cosine/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddCrop extends StatefulWidget {
   String farmName;
   String? cropName;
   AddCrop({super.key,required this.farmName,this.cropName});

  @override
  State<AddCrop> createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  late DatabaseService _databaseService;
  final  _formKey=GlobalKey<FormBuilderState>();
  Map<String,dynamic>? initData;
  @override
  void initState() {
    _databaseService=DatabaseService(uid: AuthService.firebase().currentUser!.uid);
    fetchData();
    super.initState();
  }
  Future<void>fetchData()async{
    if (widget.cropName!=null){
    initData=(await _databaseService.getAcrop(widget.farmName, widget.cropName!)) as Map<String, dynamic>?;
  }
  }


  @override
  Widget build(BuildContext context) {
    log(initData.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Crop"),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }else {
            return FormBuilder(
          key: _formKey,
          child: ListView(
          children: [
            FormBuilderTextField(name: "name",decoration: InputDecoration(hintText: cropQue[9]),initialValue: initData==null?null:widget.cropName,),
            FormBuilderTextField(name: "size",decoration: InputDecoration(hintText: cropQue[0]),initialValue: initData==null?null:initData?["size"],),
            FormBuilderDateTimePicker(
              name: "planted_on",
              inputType: InputType.date,
              decoration: InputDecoration(labelText: cropQue[1]),
              initialValue: initData==null?null:(initData?["planted_on"] as Timestamp).toDate() ,
            ),
            FormBuilderDateTimePicker(
              name: "watered_on",
              inputType: InputType.both,
              decoration: InputDecoration(labelText: cropQue[2]),
              initialValue: initData==null?null:(initData?["watered_on"] as Timestamp).toDate(),
            ),
            FormBuilderDateTimePicker(
              name: "fertilized_on",
              inputType: InputType.both,
              decoration: InputDecoration(labelText: cropQue[3]),
              initialValue: initData==null?null:(initData?["watered_on"] as Timestamp).toDate(),
            ),
            FormBuilderTextField(name: "fertilizer",decoration: InputDecoration(hintText: cropQue[4]),initialValue: initData==null?null:initData?["fertilizer"],),
            FormBuilderTextField(name: "fertilizer_quantity",decoration: InputDecoration(hintText:cropQue[5] ),initialValue: initData==null?null:initData?["fertilizer_quantity"],),
            FormBuilderTextField(name: "watering_frequency",decoration: InputDecoration(hintText: cropQue[6]),initialValue: initData==null?null:initData?["watering_frequency"],),
            FormBuilderTextField(name: "watering_system",decoration: InputDecoration(hintText: cropQue[7]),initialValue: initData==null?null:initData?["watering_system"],),
            FormBuilderTextField(name: "harms",decoration: InputDecoration(hintText: cropQue[8]),initialValue: initData==null?null:initData?["harms"],),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: ()async{
                if(_formKey.currentState!.isValid){
                  _formKey.currentState!.saveAndValidate();
                  Map<String,dynamic> map=Map.from(_formKey.currentState!.value);
                  map.remove("name");
                  if (initData==null) {
                    await _databaseService.addCrop(widget.farmName,
                        _formKey.currentState!.fields["name"]!.value, map);
                  }else{
                    await _databaseService.editCrop(widget.farmName, widget.cropName!,  _formKey.currentState!.fields["name"]!.value, map);
                  }Navigator.pop(context);
                }
              }, child: Text(initData==null?"Add":"Update")),
            )
          ],
                ),
        );
          }}
      ),
    );
  }
}