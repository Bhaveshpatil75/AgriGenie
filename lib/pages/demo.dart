
import 'package:cosine/pages/bot_chat_page.dart';
import 'package:cosine/pages/weather_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'access_location.dart';

class Demo extends StatefulWidget {
  const Demo({super.key});

  @override
  State<Demo> createState() => _DemoState();
}
double lon=0;
double lat=0;


class _DemoState extends State<Demo> {
  String data="";
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("demo"),

      ),
      body: Center(
        child:Column(
          children: [
            ElevatedButton(onPressed: () async{
              await showData();
            }, child: Text("get location"),
            ),
            ElevatedButton(onPressed: ()async{
              await openSetts(false);
            }, child: Text("open settings")),
            ElevatedButton(onPressed: ()async{
              await openSetts(true);
            }, child: Text("open location settings")),
            ElevatedButton(onPressed: ()async{
              data=await getWeather(lat, lon);
              setState(()  {
              });

            }, child: Text("get weather")),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>BotChat(data: data,)));
            }, child: Text("AI"))
          ],
        ),
      ),
    );
  }
}

Future<void> showData()async{
  Position data=await determinePosition();
  lon=data.longitude;
  lat=data.latitude;
  print("longitude : ${lon}");
  print("latitude : ${lat}");
}
Future<void> openSetts(bool loc)async{
  !loc? await Geolocator.openAppSettings():
  await Geolocator.openLocationSettings();
}
