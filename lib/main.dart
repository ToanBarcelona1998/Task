import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:task_management/db/db_helper.dart';
import 'package:task_management/services/notification_services.dart';
import 'package:task_management/services/theme_services.dart';
import 'package:task_management/ui/pages/add_task_page.dart';
import 'package:task_management/ui/pages/home_page.dart';
import 'package:task_management/ui/theme.dart';

final BehaviorSubject<String> didReceiveLocalNotificationSubject =
BehaviorSubject<String>();
final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
String initRoute="/";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotifyHelper().initializeNotification();
  String payload="";
  final NotificationAppLaunchDetails notificationAppLaunchDetails = await NotifyHelper().flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if(notificationAppLaunchDetails.didNotificationLaunchApp??false){
    initRoute=".";
    payload=notificationAppLaunchDetails.payload;
  }

  await DBHelper.initDb();
  await GetStorage.init();
  runApp(MyApp(payload));
}

class MyApp extends StatefulWidget {
  String payload;
  @override
  _MyAppState createState() => _MyAppState();

  MyApp(this.payload);
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initRoute,
      routes: {
        '/': (context)=>HomePage(),
        '.':(context)=> AddTaskPage(widget.payload),
      },
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
    );
  }
}
