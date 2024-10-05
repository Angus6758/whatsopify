// // ignore_for_file: depend_on_referenced_packages
// //cspell:words pointycastle,payu_checkoutpro_flutter,hmac

// import 'package:e_com/feature/payment/payment_gateway/pay_u_ctrl.dart';
// import 'package:e_com/models/models.dart';
// import 'package:e_com/routes/routes.dart';
// import 'package:e_com/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';

// class PayUPaymentPage extends ConsumerStatefulWidget {
//   const PayUPaymentPage({
//     super.key,
//     required this.paymentData,
//   });

//   final PaymentData paymentData;

//   @override
//   ConsumerState<PayUPaymentPage> createState() => _PayUPaymentPageState();
// }

// class _PayUPaymentPageState extends ConsumerState<PayUPaymentPage>
//     implements PayUCheckoutProProtocol {
//   late PayUCheckoutProFlutter _checkoutPro;

//   @override
//   generateHash(Map response) {
//     final payUCtrl =
//         ref.read(payUPaymentCtrlProvider(widget.paymentData).notifier);
//     final hash = payUCtrl.createHash(response);
//     _checkoutPro.hashGenerated(hash: hash);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _checkoutPro = PayUCheckoutProFlutter(this);
//     Future.delayed(0.ms, () => startPayment());
//   }

//   startPayment() {
//     final payUCtrl =
//         ref.read(payUPaymentCtrlProvider(widget.paymentData).notifier);
//     payUCtrl.startPayment(_checkoutPro);
//   }

//   @override
//   onError(Map? response) {
//     RouteNames.afterPayment.goNamed(
//       context,
//       query: {'status': 'f'},
//     );
//   }

//   @override
//   onPaymentCancel(Map? response) {
//     RouteNames.afterPayment.goNamed(
//       context,
//       query: {
//         'status': 'f',
//         'data': 'The payment was cancelled',
//       },
//     );
//   }

//   @override
//   onPaymentFailure(dynamic response) {
//     RouteNames.afterPayment.goNamed(
//       context,
//       query: {
//         'status': 'f',
//         'data': 'Failed to make a payment',
//       },
//     );
//   }

//   @override
//   onPaymentSuccess(dynamic response) async {
//     RouteNames.afterPayment.goNamed(
//       context,
//       query: {'status': 's'},
//     );
//   }

//   showAlertDialog(BuildContext context, String title, String content) {
//     final okButton = TextButton(
//       child: const Text("OK"),
//       onPressed: () => Navigator.pop(context),
//     );

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           scrollable: true,
//           title: Text(title),
//           content: Text(content),
//           actions: [okButton],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PayU Checkout Pro'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: HostedImage.square(
//             widget.paymentData.image,
//             dimension: 200,
//           ),
//         ),
//       ),
//     );
//   }
// }
