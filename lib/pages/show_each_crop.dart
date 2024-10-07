import 'package:cosine/pages/suggestions.dart';
import 'package:flutter/material.dart';
class ShowEachCrop extends StatefulWidget {
  String cropName;
  String farmName;
  dynamic data;
  String geminiData;
   ShowEachCrop({super.key,required this.cropName,required this.farmName,required this.data,required this.geminiData});

  @override
  State<ShowEachCrop> createState() => _ShowEachCropState();
}

class _ShowEachCropState extends State<ShowEachCrop> {
  @override
  void initState() {
    widget.geminiData+=" crop name : ${widget.cropName}";
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cropName),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text(widget.data.toString()),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Suggestions(geminiData: widget.geminiData,)));
                //Navigator.pop(context);
              },
              child: Text("Generate Content"),
            ),
          ),
        ],
      ),
    );
  }
}
