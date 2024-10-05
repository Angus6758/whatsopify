class PayKuCreds {
  const PayKuCreds({
    required this.publicToken,
    required this.privateToken,
    required this.isSandBox,
  });

  factory PayKuCreds.fromMap(Map<String, dynamic> map) {
    return PayKuCreds(
      publicToken: map['public_token'] ?? '',
      privateToken: map['private_token'] ?? '',
      isSandBox: map['isSandBox'] ?? '',
    );
  }

  final String publicToken;
  final String privateToken;
  final bool isSandBox;
}
