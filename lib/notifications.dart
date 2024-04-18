import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class Notifications {
  static final notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidInitSettings = AndroidInitializationSettings('main_icon');
    final iOSInitSettings = DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final initSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: iOSInitSettings,
    );

    await notificationsPlugin.initialize(
        initSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground, //(response) async {}
    );
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          //icon: 'flutter_logo',
          //icon: 'ic_notification',
          icon: 'main_icon',
          importance: Importance.max
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future show({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return notificationsPlugin.show(id, title, body, const NotificationDetails());
  }

}