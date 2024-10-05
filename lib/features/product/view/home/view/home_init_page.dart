
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/fire_msg/fcm_payload.dart';
import 'package:seller_management/features/product/view/common/fire_msg/fire_msg.dart';
import 'package:seller_management/features/product/view/common/fire_msg/ln_ctrl.dart';
import 'package:seller_management/features/product/view/common/fire_msg/on_device_notification.dart';
import 'package:seller_management/features/product/view/common/logger.dart';

class HomeInitPage extends HookConsumerWidget {
  const HomeInitPage({
    super.key,
    required this.child,
  });

  final Widget child;

  static String route = '';

  bool canShowNF(RemoteMessage message) {
    final data = FCMPayload.fromRM(message);
    final type = data.type;
    if (type == null) return true;

    final id = route.split('/').lastOrNull;
    bool canShow = true;

    type.action(
      onSellerChat: () {
        if (data.sellerId == id) canShow = false;
      },
    );
    return canShow;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void refreshDataOnMessage(RemoteMessage message) {
      final data = FCMPayload.fromRM(message);
      final type = data.type;
      if (type == null) return;

      // type.action(
      //   onOrder: () => ref.invalidate(orderDetailsProvider),
      //   onSellerChat: () => ref.invalidate(sellerChatDetailsProvider),
      // );
    }

    // Future<void> fcmMSG() async {
    //   final fcm = FireMessage.instance;
    //   if (fcm == null) return;
    //
    //   await fcm.onInitialMessage(
    //     (msg) => OnDeviceNotification.openPage(msg, context),
    //   );
    //   fcm.onEvents(
    //     onMessage: (msg) {
    //       refreshDataOnMessage(msg);
    //       Logger(route, 'onMessage');
    //       if (canShowNF(msg)) LNService.displayRM(msg);
    //     },
    //     onMessageOpenedApp: (msg) =>
    //         OnDeviceNotification.openPage(msg, context),
    //   );
    // }

    useEffect(
      () {
       // fcmMSG();
        return null;
      },
      const [],
    );

    return child;
  }
}
