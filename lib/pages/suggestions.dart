import 'dart:developer';
import 'package:cosine/pages/demo.dart';
import 'package:cosine/pages/weather_page.dart';
import 'package:cosine/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Suggestions extends StatefulWidget {
  String geminiData;
   Suggestions({super.key,required this.geminiData});

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  late bool loading;
   String? msg;
  @override
  void initState() {
    loading=true;
    getSuggestion();
    super.initState();
  }
  Future<void> getSuggestion()async{
    log("get suggestions called");
    dynamic gemini=Gemini.instance;
    Map<String,double> locMap=await showData();
    log(locMap.toString());
    widget.geminiData+=await getWeather(locMap["latitude"]??0, locMap["longitude"]??0);
    log(widget.geminiData);
    gemini.text("generate suggestions based on the farm related data i am providing,this is the data ${widget.geminiData}")
        .then((value){
          msg=value?.content?.parts?.last.text ?? '';
          setState(() {
            loading=false;
          });
        })
    .catchError((e)=>log(e.code));
  }
  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      appBar: AppBar(
        title: Text("Suggestions"),
      ),
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(msg??"No response"),
          )
      ),
    );
  }
}
