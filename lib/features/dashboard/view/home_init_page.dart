import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/features/chat/controller/chat_ctrl.dart';
import 'package:seller_management/features/product/controller/list_ctrls.dart';
import 'package:seller_management/main.export.dart';

class DashInitPage extends HookConsumerWidget {
  const DashInitPage({
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
      onCustomerChat: () {
        if (data.userId == id) canShow = false;
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

      type.action(
        onCustomerChat: () => ref.invalidate(chatMessageCtrlProvider),
        onProductUpdate: () {
          ref.invalidate(physicalProductCtrlProvider);
          ref.invalidate(digitalProductCtrlProvider);
        },
      );
    }

    Future<void> fcmMSG() async {
      final fcm = FireMessage.instance;
      fcm.onInitialMessage(
        (msg) => OnDeviceNotification.openPage(msg, context),
      );
      fcm.onEvents(
        onMessage: (msg) {
          refreshDataOnMessage(msg);
          if (canShowNF(msg)) LNService.displayRM(msg);
        },
        onMessageOpenedApp: (msg) => OnDeviceNotification.openPage(msg),
      );
    }

    useEffect(
      () {
        fcmMSG();
        return null;
      },
      const [],
    );

    return child;
  }
}
