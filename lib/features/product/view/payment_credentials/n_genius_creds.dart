class NGeniusCreds {
  const NGeniusCreds({
    required this.apiKey,
    required this.outletId,
  });

  factory NGeniusCreds.fromMap(Map<String, dynamic> map) {
    return NGeniusCreds(
      apiKey: map['outlet_id'] ?? '',
      outletId: map['outletId'] ?? '',
    );
  }

  final String apiKey;
  final String outletId;
}
