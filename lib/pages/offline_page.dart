import 'package:flutter/material.dart';
class OfflinePage extends StatelessWidget {
  const OfflinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline"),
      ),
      body:Center(child: Text("Please connect to a Network"),),
    );
  }
}
