class PayHereCreds {
  const PayHereCreds({
    required this.merchantId,
    required this.merchantSecret,
  });

  factory PayHereCreds.fromMap(Map<String, dynamic> map) {
    return PayHereCreds(
      merchantId: map['merchant_id'] ?? '',
      merchantSecret: map['secret_key'] ?? '',
    );
  }

  final String merchantId;
  final String merchantSecret;
}
