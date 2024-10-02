import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Botchat2 extends StatefulWidget {
  String? path;
   Botchat2({super.key,this.path});
  @override
  State<Botchat2> createState() => _Botchat2State();
}

class _Botchat2State extends State<Botchat2> {
  List<Content> chats=[Content(role: 'model',parts:  [Parts(text: "Hello I am Pyster an AI assistant. how may I help you today?")])];
  var message=TextEditingController();
  dynamic chat;
  dynamic gemini,file;
  late ScrollController scroll;
  @override
  void initState() {
    scroll=ScrollController();
     gemini = Gemini.instance;
     file = File(widget.path!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    gemini.textAndImage(
        text: "What is this picture?", /// text
        images: [file.readAsBytesSync() as Uint8List] /// list of images
    )
        .then((value) => log(value?.content?.parts?.last.text ?? ''))
        .catchError((e) => log('textAndImageInput', error: e));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade200,
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_outlined),),
        title: Row(
          children: [
            CircleAvatar(child: Text("P"),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Pyster"),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView(controller: scroll,
                children: chats.map((chat){
                  return Container(
                    padding: EdgeInsets.all(10),
                    alignment: chat.role!="model"?Alignment.centerRight:Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width-50),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepPurple.shade100
                          ),
                          padding: EdgeInsets.all(10),
                          child: Text(chat.parts!.lastOrNull?.text??"")),
                    ),
                  );
                }).toList(),)
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onTap: () async{
                  Timer(Duration(milliseconds: 500), () => scroll.jumpTo(scroll.position.maxScrollExtent));
                },
                decoration: InputDecoration(
                    hintText: "Message",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(onPressed: () async{
                      setState(() {
                        chats.add(Content(parts: [Parts(text: message.text),],role: "user"));
                        Timer(Duration(milliseconds: 300),
                                () => scroll.jumpTo(scroll.position.maxScrollExtent));
                      });
                      message.clear();

                        gemini.chat(chats).then((value) {
                          print(value.toString());
                          chats.add(Content(role: "model",parts: [Parts(text: value?.content?.parts?.last?.text??"No data")]));
                          setState(() {
                            Timer(Duration(milliseconds: 300),
                                    () => scroll.jumpTo(scroll.position.maxScrollExtent));

                          });
                        });
                        //chats.add(Message(text: response.text??"", receiver: "User"));


                    }, icon: Icon(Icons.arrow_forward),)
                ),
                controller: message,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
