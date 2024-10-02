

import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url)async{
  final Uri u=Uri.parse(url);
  await launchUrl(u,mode: LaunchMode.inAppWebView);
  //await launchUrlString(url);
}