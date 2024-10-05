import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:seller_management/main.export.dart';

Future<void> backgroundMessage(RemoteMessage message) async {
  Logger.json(message.toMap(), 'FireMessage');
}

class FireMessage extends Repo {
  FireMessage._();

  final _message = FirebaseMessaging.instance;

  static FireMessage get instance => FireMessage._();

  static Future<void> initiate() async {
    final fcm = FireMessage.instance;
    await fcm._initMessaging();
  }

  void onEvents({
    Function(RemoteMessage msg)? onMessage,
    Function(RemoteMessage msg)? onMessageOpenedApp,
  }) {
    Logger('FCM onEvents', 'FCM');
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }

  Future<void> updateServerToken(bool isLoggedIn) async {
    final permitted = await _checkPermission();
    if (!permitted) return;
    final token = await _message.getToken();
    Logger(token, 'FCM update');

    if (token == null) return;

    if (isLoggedIn) {
      await _updateFCMToken(token);
      _message.onTokenRefresh.listen((t) => _updateFCMToken(t));
      return;
    }

    Logger('Unauthenticated', 'FCM update');
    return;
  }

  Future<void> _initMessaging() async {
    final permitted = await _checkPermission();
    if (!permitted) return;
    Logger('FCM init', 'FCM');
    FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  }

  Future<void> onInitialMessage(Function(RemoteMessage msg)? onMessage) async {
    final msg = await _message.getInitialMessage();
    if (msg == null) return;

    onMessage?.call(msg);
  }

  Future<bool> _checkPermission() async {
    final permission = await _message.requestPermission();
    return permission.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _updateFCMToken(String token) async {
    await rdb.updateFCMToken(token);
  }
}
