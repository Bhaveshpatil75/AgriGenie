import 'package:cosine/constants/questions.dart';
import 'package:cosine/pages/show_each_farm.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddCrop extends StatefulWidget {
  late String farmName;
   AddCrop({super.key,required this.farmName});

  @override
  State<AddCrop> createState() => _AddCropState();
}

class _AddCropState extends State<AddCrop> {
  late DatabaseService _databaseService;
  final  _formKey=GlobalKey<FormBuilderState>();
  @override
  void initState() {
    _databaseService=DatabaseService(uid: AuthService.firebase().currentUser!.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Crop"),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView(
        children: [
          FormBuilderTextField(name: "name",decoration: InputDecoration(hintText: cropQue[9])),
          FormBuilderTextField(name: "size",decoration: InputDecoration(hintText: cropQue[0])),
          FormBuilderDateTimePicker(
            name: "planted_on",
            inputType: InputType.date,
            decoration: InputDecoration(labelText: cropQue[1]),
          ),
          FormBuilderDateTimePicker(
            name: "watered_on",
            inputType: InputType.both,
            decoration: InputDecoration(labelText: cropQue[2]),
          ),
          FormBuilderDateTimePicker(
            name: "fertilized_on",
            inputType: InputType.both,
            decoration: InputDecoration(labelText: cropQue[3]),
          ),
          FormBuilderTextField(name: "fertilizer",decoration: InputDecoration(hintText: cropQue[4]),initialValue: "None",),
          FormBuilderTextField(name: "fertilizer_quantity",decoration: InputDecoration(hintText:cropQue[5] ),initialValue: "0",),
          FormBuilderTextField(name: "watering_frequency",decoration: InputDecoration(hintText: cropQue[6]),initialValue: "0",),
          FormBuilderTextField(name: "watering_system",decoration: InputDecoration(hintText: cropQue[7]),initialValue: "None",),
          FormBuilderTextField(name: "harms",decoration: InputDecoration(hintText: cropQue[8]),initialValue: "None",),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: ()async{
              if(_formKey.currentState!.isValid){
                _formKey.currentState!.saveAndValidate();
                Map<String,dynamic> map=Map.from(_formKey.currentState!.value);
                map.remove("name");
                await _databaseService.addCrop(widget.farmName, _formKey.currentState!.fields["name"]!.value, map);
                //Navigator.push(context, MaterialPageRoute(builder: (_)=>ShowEachFarm(data: "data", farmName: widget.farmName)));
                Navigator.pop(context);
              }
            }, child: Text("Add")),
          )
        ],
              ),
      ),
    );
  }
}