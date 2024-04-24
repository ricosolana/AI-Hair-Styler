import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // handle action
}

class MyNotifications {
  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
        'app_icon'
    );
    // iOS
    //final initializationSettingsDarwin = DarwinInitializationSettings(
    //    onDidReceiveLocalNotification: onDidReceiveLocalNotification
    //);
    const initializationSettingsLinux = LinuxInitializationSettings(
      defaultActionName: 'Open notification',
    );
    const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        //iOS: initializationSettingsDarwin,
        //macOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        //switch (notificationResponse.notificationResponseType) {
        //  case NotificationResponseType.selectedNotification:
        //    selectNotificationStream.add(notificationResponse.payload);
        //    break;
        //  case NotificationResponseType.selectedNotificationAction:
        //    if (notificationResponse.actionId == navigationActionId) {
        //      selectNotificationStream.add(notificationResponse.payload);
        //    }
        //    break;
        //}
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground
    );
  }

  NotificationDetails createNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'channelId',
          'channelName',
          icon: 'main_icon',
          importance: Importance.max
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload, // what is this? in terms of Android
  }) async {
    await flutterLocalNotificationsPlugin.show(1, title, body, createNotificationDetails(), payload: payload);
  }

}