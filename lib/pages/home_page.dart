
import 'dart:developer';

import 'package:cosine/services/auth/auth_service.dart';
import 'package:cosine/services/database/database_service.dart';
import 'package:cosine/services/database/models.dart';
import 'package:cosine/widgets/loading.dart';
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
  late DatabaseService _databaseService;
  @override
  void initState() {
    _databaseService=DatabaseService(uid:AuthService.firebase().currentUser!.uid );
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
      body:StreamBuilder<List<Post>>(
        stream: _databaseService.showPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState==ConnectionState.waiting){
            return Loading();
          }
          else {
            List<Post>? posts=snapshot.data;
            return snapshot.hasData?
                ListView.separated(
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Text(posts[index].title),
                        subtitle: Text("By-${posts[index].owner}"),
                        trailing: Text(posts[index].likes.toString()),
                      );
                    },
                    separatorBuilder: (context,index){
                      return Divider(thickness: 3,);
                    },
                    itemCount: posts!.length)
                :Center(child: Text("No posts"));
          }
        }
      )
      ,
      drawer: MyDrawer(context),
      bottomNavigationBar: MyBottomNav(context),
    ):OfflinePage();
  }
}