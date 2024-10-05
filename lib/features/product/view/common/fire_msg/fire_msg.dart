import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../firebase_options.dart';
import '../../../../../locator.dart';

Future<void> backgroundMessage(RemoteMessage message) async {
  Logger.json(message.toMap(), 'FireMessage');
}

class FireMessage {
  FireMessage._();

  static bool isFireActive = false;

  final _message = FirebaseMessaging.instance;

  static FireMessage? get instance => isFireActive ? FireMessage._() : null;

  static Future<void> initiate() async {
    final fcm = FireMessage.instance;
    await fcm?._initMessaging();
  }

  static Future<void> initiateWithFirebase() async {
    if (!isFireActive) {
      Logger('Firebase is not active', 'FireMessage');
      return;
    }

    Logger('Initiating Firebase', 'FireMessage');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await initiate();
  }

  void onEvents({
    Function(RemoteMessage msg)? onMessage,
    Function(RemoteMessage msg)? onMessageOpenedApp,
  }) {
    Logger('FCM onEvents', 'FCM');
    FirebaseMessaging.onMessage.listen(onMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(onMessageOpenedApp);
  }

  Future<void> onInitialMessage(Function(RemoteMessage msg)? onMessage) async {
    final msg = await _message.getInitialMessage();
    if (msg == null) return;

    onMessage?.call(msg);
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

  Dio _dio() {
    final token = locate<SharedPreferences>().getString(PrefKeys.accessToken);
    final langCode = locate<RegionRepoEx1>().getLanguage();
    final currencyUid = locate<RegionRepoEx1>().getCurrency()?.uid;

    final headers = {
      'api-lang': langCode,
      'currency-uid': currencyUid,
      'Authorization': 'Bearer $token',
    };
    final dio = Dio();

    dio.options
      ..baseUrl = Endpoints.baseUrl!!
      ..headers.addAll(headers);
    dio.interceptors.add(talk.dioLogger);

    return dio;
  }

  Future<void> _initMessaging() async {
    final permitted = await _checkPermission();
    if (!permitted) return;
    Logger('FCM init', 'FCM');
    FirebaseMessaging.onBackgroundMessage(backgroundMessage);
  }

  Future<bool> _checkPermission() async {
    final permission = await _message.requestPermission();
    return permission.authorizationStatus == AuthorizationStatus.authorized;
  }

  Future<void> _updateFCMToken(String token) async {
    await _dio().post(Endpoints.updateFCM, data: {'fcm_token': token});
  }
}
