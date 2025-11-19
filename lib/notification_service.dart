
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize notifications
  static Future<void> init() async {

    const AndroidInitializationSettings androidSettings =AndroidInitializationSettings("@mipmap/logo"); // make sure icon exists

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: (details) {
      print('Notification clicked!');
    });
  }

  /// Show a notification immediately
  static Future<void> showNotification({required String title,required String body,}) async {
    final AndroidNotificationDetails androidDetails =AndroidNotificationDetails(
      'order_channel',
      'Order Notifications',
      channelDescription: 'Reminder for food delivery',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: "@mipmap/logo",
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/logo'),
      onlyAlertOnce: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(body),
      
      
    );

    final NotificationDetails notificationDetails =NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
  
 
 
  
  
}