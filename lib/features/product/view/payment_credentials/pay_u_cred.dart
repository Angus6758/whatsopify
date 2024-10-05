class PayUCreds {
  const PayUCreds({
    required this.secretKey,
    required this.salt,
  });

  factory PayUCreds.fromMap(Map<String, dynamic> map) {
    return PayUCreds(
      secretKey: map['merchant_key'] ?? '',
      salt: map['salt'] ?? '',
    );
  }

  final String salt;
  final String secretKey;
}
