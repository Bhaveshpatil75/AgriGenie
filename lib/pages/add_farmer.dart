
import 'dart:developer';
import 'package:cosine/constants/routes.dart';
import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../constants/questions.dart';

class AddFarmerPage extends StatefulWidget {
  const AddFarmerPage({super.key});

  @override
  State<AddFarmerPage> createState() => _AddFarmerPageState();
}

class _AddFarmerPageState extends State<AddFarmerPage> {
  final _formKey=GlobalKey<FormBuilderState>();
  late DatabaseService _databaseService;
  @override
  void initState() {
    _databaseService=DatabaseService(uid: AuthService.firebase().currentUser?.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderCheckboxGroup(
                  name: "you_have",
                  decoration: InputDecoration(
                    labelText: questions[0],
                  ),
                  options: [
                    'degree in field of Agriculture','tractor',
                  ].map((val)=>FormBuilderFieldOption(value: val)).toList(growable: false),
              ),
              FormBuilderSlider(name: "workers", initialValue: 1, min: 0, max: 30,
              divisions: 30,
                decoration: InputDecoration(
                  label: Text(questions[1])
              ),
              ),
              FormBuilderSlider(name: "dependents", initialValue: 1, min: 0, max: 30,
                divisions: 30,
                decoration: InputDecoration(
                    labelText: questions[2],
                ),
              ),
              FormBuilderSwitch(name: "selfwork", title: Text(questions[3])),
              ElevatedButton(onPressed: () async {
                if (_formKey.currentState!.isValid){
                  _formKey.currentState!.saveAndValidate();
                  await _databaseService.addFarmer(_formKey.currentState!.value);

                }
              }, child: Text("Submit")),
            ],
          ),
        ),
      )
    );
  }
}
