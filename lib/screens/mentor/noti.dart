import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Noti {
  // static Future initialize(
  //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  //   var androidInitialize =
  //       new AndroidInitializationSettings('mipmap/ic_launcher');
  //   // var iOSInitialize = new IOSInitializationSettings();

  //   var initializationsSettings =
  //       new InitializationSettings(android: androidInitialize);

  //   await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  // }
  static final _notification = FlutterLocalNotificationsPlugin();
  static init() {
    _notification.initialize(InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()));
  }

  static pushNotification({required String title, required String body}) async {
    var androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidDetails);
    await _notification.show(0, title, body, notificationDetails);
  }
  // static Future showBigTextNotification(
  //     {var id = 0,
  //     required String title,
  //     required String body,
  //     var payload,
  //     required FlutterLocalNotificationsPlugin fln}) async {
  //   AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       new AndroidNotificationDetails(
  //     'ecommerce1',
  //     'channel_name',
  //     playSound: true,
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   var not = NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await fln.show(0, title, body, not);
  // }
}
