class ESewaCredentials {
  ESewaCredentials({
    required this.isSandbox,
    required this.clientId,
    required this.clientSecret,
    required this.productCode,
    required this.secretKey,
    required this.note,
  });

  factory ESewaCredentials.fromMap(Map<String, dynamic> map) {
    return ESewaCredentials(
      isSandbox: map['environment'] == 'sandbox',
      clientId: map['client_id'] ?? '',
      clientSecret: map['client_secret'] ?? '',
      productCode: map['product_code'] ?? '',
      secretKey: map['secret_key'] ?? '',
      note: map['note'] ?? '',
    );
  }

  final String secretKey;
  final String productCode;
  final String clientId;
  final String clientSecret;
  final bool isSandbox;
  final String note;
}
