/// {@template payment_method}
/// This is the list of all available payment methods
/// {@endtemplate}
enum PaymentMethod {
  stripe,
  paypal,
  payStack,
  flutterWave,
  razorPay,
  instaMojo,
  bkash,
  nagad,
  mercado,
  payeer,
  payUMoney,
  aamarPay,
  phonePe,
  payHere,
  payKu,
  senangPay,
  nGenius,
  esewa;

  /// {@macro payment_method}
  const PaymentMethod();

  /// get payment method from name
  static PaymentMethod? fromName(String? name) {
    return switch (name?.toLowerCase().replaceAll(' ', '')) {
      'stripe' => stripe,
      'paypal' => paypal,
      'paystack' => payStack,
      'flutterwave' => flutterWave,
      'razorpay' => razorPay,
      'instamojo' => instaMojo,
      'bkash' => bkash,
      'nagad' => nagad,
      'mercadopago' => mercado,
      'payeer' => payeer,
      'payumoney' => payUMoney,
      'aamarpay' => aamarPay,
      'phonepe' => phonePe,
      'payhere' => payHere,
      'payku' => payKu,
      'senangpay' => senangPay,
      'ngenius' => nGenius,
      'esewa' => esewa,
      _ => null,
    };
  }
}
