import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

class OnDeviceNotification {
  static BuildContext? get _ctx => Toaster.navigator?.currentContext;

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

  static openPage(RemoteMessage message, [BuildContext? context]) {
    final data = FCMPayload.fromRM(message);
    final ctx = context ?? _ctx;
    if (ctx == null) throw Exception('context not found on `openPage`');
    _NotificationDialogView._buttonAction(data, ctx);
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
              backgroundColor: context.colorTheme.primary.withOpacity(.1)),
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
          RouteNames.orderDetails.pushNamed(
            context,
            pathParams: {'id': data.orderNumber!},
          );
        }
      },
      onCustomerChat: () {
        if (data.userId != null) {
          RouteNames.customerChat.pushNamed(
            context,
            pathParams: {'id': data.userId!},
          );
        }
      },
      onProductUpdate: () {
        if (data.productUid != null) {
          RouteNames.productDetails
              .pushNamed(context, pathParams: {'id': data.productUid!});
        }
      },
    );
  }
}
