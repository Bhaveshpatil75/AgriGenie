import 'package:cosine/widgets/myBottomNav.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cosine/pages/offline_page.dart';
import 'package:cosine/services/notifications/notificationService.dart';
import 'package:cosine/widgets/mydrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static late BuildContext openContext;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<List<ConnectivityResult>> subscription;
  late bool isConnected;
  @override
  void initState() {
    isConnected=false;
    super.initState();
    requestNotificationPermission().then((_) {
      NotificationService.initialize(flutterLocalNotificationsPlugin);
    });
    subscription = Connectivity()
        .onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.other)
      ) {
        isConnected=true;
      }  else if (result.contains(ConnectivityResult.none)) {
        isConnected=false;
      }
      setState(() {
      });
    });
  }
  @override
   void dispose() {
    subscription.cancel();
    super.dispose();
  }
  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    HomePage.openContext=context;
    return  isConnected?Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body:Column(
        children: [
          Center(
              child: Text("Welcome...")
          ),
          ElevatedButton(onPressed: ()async{
            NotificationService.showBigTextNotification(title: "title", body: "body", fln: flutterLocalNotificationsPlugin);
          }, child: Text("send"))
        ],
      )
      ,
      drawer: MyDrawer(context),
      bottomNavigationBar: MyBottomNav(context),
    ):OfflinePage();
  }
}
