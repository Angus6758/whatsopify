class PhonePyCreds {
  const PhonePyCreds({
    required this.merchantId,
    required this.salt,
    required this.saltIndex,
  });

  factory PhonePyCreds.fromMap(Map<String, dynamic> map) {
    return PhonePyCreds(
      merchantId: map['merchant_id'] ?? '',
      salt: map['salt_key'] ?? '',
      saltIndex: map['salt_index'] ?? '',
    );
  }

  final String merchantId;
  final String salt;
  final String saltIndex;
}
