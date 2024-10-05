import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:seller_management/_core/common/fire_msg/on_device_notification.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

class LNService {
  static final _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    const androidSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/launcher_icon"),
    );

    _notificationsPlugin.initialize(
      androidSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == null) return;
        final data = json.decode(details.payload!);
        OnDeviceNotification.openPageFromLN(data);
      },
    );
  }

  static Future<void> displayRM(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          message.notification!.android!.sound ?? "Channel Id",
          message.notification!.android!.sound ?? "Main Channel",
          groupKey: AppDefaults.appName,
          setAsGroupSummary: true,
          importance: Importance.max,
          playSound: true,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification?.title,
        message.notification?.body,
        details,
        payload: json.encode(message.data),
      );
    } catch (e, s) {
      talk.ex(e, s, 'error on displayRM');
    }
  }
}
