// // ignore_for_file: use_build_context_synchronously

// import 'package:e_com/feature/check_out/providers/provider.dart';
// import 'package:e_com/models/models.dart';
// import 'package:e_com/routes/go_route_name.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

// final payHereCtrlProvider =
//     NotifierProviderFamily<PayHereCtrlNotifier, String, PaymentData>(
//         PayHereCtrlNotifier.new);

// class PayHereCtrlNotifier extends FamilyNotifier<String, PaymentData> {
//   @override
//   String build(PaymentData arg) {
//     return '';
//   }

//   // Dio get _dio => Dio()..interceptors.add(talk.dioLogger);

//   String callback([String type = '']) => 'https://callback.com/payment/$type';

//   PayHereCreds get _cred => PayHereCreds.fromMap(arg.paymentParameter);
//   //     (
//   //   merchantId: '1227090',
//   //   merchantSecret:
//   //       'MTk0MTQ3MzUzNDI5NDUwMDg0MTQxOTc2MTUzMDg1MzQyOTk0OTU0Ng==',
//   // );

//   Future<void> initializePayment(BuildContext context) async {
//     PayHere.startPayment(
//       _payload(),
//       (paymentId) {
//         RouteNames.afterPayment.goNamed(context, query: {'status': 'w'});
//       },
//       (error) {
//         RouteNames.afterPayment
//             .goNamed(context, query: {'status': 'f', 'data': error});
//       },
//       () {
//         RouteNames.afterPayment.goNamed(context, query: {
//           'status': 'f',
//           'data': 'Payment was dismissed',
//         });
//       },
//     );
//   }

//   int get _finalAmount => _order!.paymentLog.finalAmount.round();

//   Map<String, dynamic> _payload() {
//     final bill = _order!.order.billingAddress;
//     final notify = '${arg.callbackUrl}/${_order!.paymentLog.trx}/success';
//     final paymentObject = {
//       "sandbox": true,
//       "merchant_id": _cred.merchantId,
//       "merchant_secret": _cred.merchantSecret,
//       "notify_url": notify,
//       "order_id": _order!.paymentLog.trx,
//       "first_name": bill?.firstName,
//       "last_name": bill?.lastName,
//       "email": bill?.email,
//       "phone": bill?.phone,
//       "address": bill?.address,
//       "city": bill?.city,
//       "country": bill?.country,
//       "items": _order!.order.orderId,
//       "amount": _finalAmount,
//       "currency": arg.currency.name,
//     };

//     return paymentObject;
//   }

//   Future<void> executePayment(BuildContext context, Uri? url) async {
//     RouteNames.afterPayment.goNamed(
//       context,
//       query: {'status': '$url'.contains('success') ? 's' : 'f'},
//     );
//   }

//   OrderBaseModel? get _order => ref.read(checkoutStateProvider);
// }
