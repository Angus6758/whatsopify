
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/fire_msg/fcm_payload.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/routes/go_route_config.dart';
import 'package:seller_management/routes/go_route_name.dart';

class OnDeviceNotification {
  static BuildContext? get _ctx => Get.context;

  // static Future<void> showNotification(RemoteMessage? message) async {
  //   if (_ctx == null) {
  //     throw Exception('context not found on `showNotification`');
  //   }
  //   if (message == null) throw Exception('Remote Message not found');
  //   FlutterRingtonePlayer().playNotification();
  //   showDialog(
  //     context: _ctx!,
  //     barrierDismissible: false,
  //     builder: (ctx) => _NotificationDialogView(message),
  //   );
  // }

  static openPage(RemoteMessage message, BuildContext context) {
    final data = FCMPayload.fromRM(message);
    _NotificationDialogView._buttonAction(data, context);
  }

  static openPageFromLN(Map<String, dynamic> message) {
    final data = FCMPayload.fromMap(message);

    if (_ctx == null) throw Exception('context not found on `openPage`');
    _NotificationDialogView._buttonAction(data, _ctx!);
  }
}

class _NotificationDialogView extends ConsumerWidget {
  const _NotificationDialogView(this.message);

  final RemoteMessage message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = FCMPayload.fromRM(message);
    final type = data.type;
    return AlertDialog(
      title: Text(data.title),
      content: SizedBox(
        width: context.width * .8,
        child: Text(data.body),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
              backgroundColor: context.colors.primary.withOpacity(.1)),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
        if (type != null)
          FilledButton(
            onPressed: () {
              _buttonAction(data, context);
            },
            child: Text(type.btnLabel),
          ),
      ],
    );
  }

  static void _buttonAction(FCMPayload data, BuildContext context) {
    final type = data.type;
    if (type == null) return;
    type.action(
      onOrder: () {
        if (data.orderNumber != null) {
          RouteNames.orderDetails.goNamed(
            context,
            query: {'id': data.orderNumber!},
          );
        }
      },
      onSellerChat: () {
        if (data.sellerId != null) {
          RouteNames.sellerChatDetails.pushNamed(
            context,
            pathParams: {'id': data.sellerId!},
          );
        }
      },
    );
  }
}
