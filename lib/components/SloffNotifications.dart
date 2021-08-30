import 'package:flutter_local_notifications/flutter_local_notifications.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class SloffNotifications {
  static instructionsNotification(int timeSeconds,
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    int time = timeSeconds >= 60 ? (timeSeconds / 60).round() : timeSeconds;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        timeSeconds > 60 ? "Enjoy your $time minutes off the screen!" : "Enjoy your $time seconds off the screen!",
        "Remember not to use apps, or your focus will be lost. Unlock the screen at any time to see how long you've got left!",
        platformChannelSpecifics,
        payload: 'item x');
  }

    static warningNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        "I see you! 👀",
        "Return to Sloff, or you'll lose your focus.",
        platformChannelSpecifics,
        payload: 'item x');
  }
}

class SloffScheduledNotifications {
  static Future warningNotification(DateTime time, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        "I see you! 👀",
        "Return to Sloff, or you'll lose your focus.",
        time,
        platformChannelSpecifics,
        payload: 'item x');
  }

  static Future lostFocusNotification(DateTime time, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        2,
        "Sorry! 😕",
        "You've lost your focus. Return to Sloff and start over!",
        time,
        platformChannelSpecifics,
        payload: 'item x');
  }

    static Future focusCompletedNotification(DateTime time, String name, FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your channel id', 'Sloff', 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
            ongoing: true,
            styleInformation: BigTextStyleInformation(''));
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        1,
        "Congrats " + name.capitalize() + "! 🎉",
        "You have completed your focus.",
        time,
        platformChannelSpecifics,
        payload: 'item x');
  }
}
