// // cspell:words mercadopago
// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:e_com/core/core.dart';
// import 'package:e_com/feature/check_out/providers/provider.dart';
// import 'package:e_com/feature/payment/repository/payment_repo.dart';
// import 'package:e_com/feature/payment/view/payment_pages/pay_u_cb.dart';
// import 'package:e_com/models/models.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
// import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';

// final payUPaymentCtrlProvider = StateNotifierProvider.family<PayUPaymentCtrl,
//     Map<String, dynamic>, PaymentData>((ref, paymentData) {
//   return PayUPaymentCtrl(ref, paymentData);
// });

// class PayUPaymentCtrl extends StateNotifier<Map<String, dynamic>> {
//   PayUPaymentCtrl(this._ref, this.paymentData) : super({});

//   final PaymentData paymentData;

//   final Ref _ref;

//   void initializePayment(BuildContext context) {
//     Navigator.of(context).push(
//       MaterialPageRoute(
//         builder: (c) => PayUPaymentPage(paymentData: paymentData),
//       ),
//     );
//   }

//   void startPayment(PayUCheckoutProFlutter payU) {
//     payU.openCheckoutScreen(
//       payUPaymentParams: _createPayUPaymentParams(),
//       payUCheckoutProConfig: _createPayUConfigParams(),
//     );
//   }

//   Map<String, dynamic> _createPayUPaymentParams() {
//     final order = _order?.order;
//     final endDate = DateTime.now().add(const Duration(days: 5));
//     final siParams = {
//       PayUSIParamsKeys.billingAmount: _order?.paymentLog.finalAmount,
//       PayUSIParamsKeys.billingInterval: 1,
//       PayUSIParamsKeys.paymentStartDate: DateTime.now().formate('yyyy-MM-dd'),
//       PayUSIParamsKeys.paymentEndDate: endDate.formate('yyyy-MM-dd'),
//       PayUSIParamsKeys.billingCycle: 'daily',
//       PayUSIParamsKeys.remarks: 'Payment for order ${order?.orderId}',
//       PayUSIParamsKeys.billingCurrency: _order?.paymentLog.method.currency.name,
//       PayUSIParamsKeys.billingLimit: 'ON',
//       PayUSIParamsKeys.billingRule: 'MAX',
//     };

//     final payUPaymentParams = {
//       PayUPaymentParamKey.key: _payUCreds.secretKey,
//       PayUPaymentParamKey.amount: _order?.paymentLog.finalAmount,
//       PayUPaymentParamKey.productInfo: order?.quantity.toString(),
//       PayUPaymentParamKey.firstName: order?.billingAddress?.fullName ?? '',
//       PayUPaymentParamKey.email: order?.billingAddress?.email ?? '',
//       PayUPaymentParamKey.phone: order?.billingAddress?.phone ?? '',
//       PayUPaymentParamKey.ios_surl:
//           '${paymentData.callbackUrl}/${_order!.paymentLog.trx}/success',
//       PayUPaymentParamKey.ios_furl:
//           '${paymentData.callbackUrl}/${_order!.paymentLog.trx}/failed',
//       PayUPaymentParamKey.android_surl:
//           '${paymentData.callbackUrl}/${_order!.paymentLog.trx}/success',
//       PayUPaymentParamKey.android_furl:
//           '${paymentData.callbackUrl}/${_order!.paymentLog.trx}/failed',
//       PayUPaymentParamKey.environment: "0",
//       PayUPaymentParamKey.userCredential: null,
//       PayUPaymentParamKey.transactionId: _order?.paymentLog.trx,
//       PayUPaymentParamKey.payUSIParams: siParams,
//       PayUPaymentParamKey.enableNativeOTP: true,
//       PayUPaymentParamKey.userToken: "",
//     };

//     return payUPaymentParams;
//   }

//   Map<String, dynamic> _createPayUConfigParams() {
//     final payUCheckoutProConfig = {
//       PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
//       PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
//       PayUCheckoutProConfigKeys.merchantName: AppDefaults.appName,
//       PayUCheckoutProConfigKeys.merchantLogo: Assets.icon.appLogo.path,
//       PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
//       PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
//       PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
//       PayUCheckoutProConfigKeys.autoSelectOtp: true,
//       PayUCheckoutProConfigKeys.waitingTime: 30000,
//       PayUCheckoutProConfigKeys.autoApprove: true,
//       PayUCheckoutProConfigKeys.merchantSMSPermission: true,
//       PayUCheckoutProConfigKeys.showCbToolbar: true,
//     };
//     return payUCheckoutProConfig;
//   }

//   paymentConfirmation(Uri uri, BuildContext context) async {
//     final body = {...uri.queryParameters, ...state};

//     final callBack = '${paymentData.callbackUrl}/${_order!.paymentLog.trx}';

//     await PaymentRepo().confirmPayment(context, body, callBack);
//   }

//   Map createHash(Map response) {
//     final hashService =
//         _HashService(salt: _payUCreds.salt, secretKey: _payUCreds.secretKey);
//     return hashService.generateHash(response);
//   }

//   PayUCreds get _payUCreds => PayUCreds.fromMap(paymentData.paymentParameter);

//   OrderBaseModel? get _order => _ref.read(checkoutStateProvider);
// }

// class _HashService {
//   _HashService({required this.salt, required this.secretKey});

//   final String salt;
//   final String secretKey;

//   Map generateHash(Map response) {
//     final hashName = response[PayUHashConstantsKeys.hashName];
//     final hashStringWithoutSalt = response[PayUHashConstantsKeys.hashString];
//     final hashType = response[PayUHashConstantsKeys.hashType];
//     final postSalt = response[PayUHashConstantsKeys.postSalt];

//     String hash = "";

//     if (hashType == PayUHashConstantsKeys.hashVersionV2) {
//       hash = getHmacSHA256Hash(hashStringWithoutSalt, salt);
//     } else if (hashName == PayUHashConstantsKeys.mcpLookup) {
//       hash = getHmacSHA1Hash(hashStringWithoutSalt, secretKey);
//     } else {
//       String hashDataWithSalt = hashStringWithoutSalt + salt;
//       if (postSalt != null) {
//         hashDataWithSalt = hashDataWithSalt + postSalt;
//       }
//       hash = getSHA512Hash(hashDataWithSalt);
//     }
//     final finalHash = {hashName: hash};
//     return finalHash;
//   }

//   String getSHA512Hash(String hashData) {
//     var bytes = utf8.encode(hashData);
//     var hash = sha512.convert(bytes);
//     return hash.toString();
//   }

//   String getHmacSHA256Hash(String hashData, String salt) {
//     var key = utf8.encode(salt);
//     var bytes = utf8.encode(hashData);
//     final hmacSha256 = Hmac(sha256, key).convert(bytes).bytes;
//     final hmacBase64 = base64Encode(hmacSha256);
//     return hmacBase64;
//   }

//   String getHmacSHA1Hash(String hashData, String salt) {
//     var key = utf8.encode(salt);
//     var bytes = utf8.encode(hashData);
//     var hmacSha1 = Hmac(sha1, key);
//     var hash = hmacSha1.convert(bytes);
//     return hash.toString();
//   }
// }
