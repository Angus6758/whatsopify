class SenangPayCreds {
  const SenangPayCreds({
    required this.secret,
    required this.merchantId,
  });

  factory SenangPayCreds.fromMap(Map<String, dynamic> map) {
    return SenangPayCreds(
      secret: map['secret_key'] ?? '',
      merchantId: map['merchant_id'] ?? '',
    );
  }

  final String secret;
  final String merchantId;
}
