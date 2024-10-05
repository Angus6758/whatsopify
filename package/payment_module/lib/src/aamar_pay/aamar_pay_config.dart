/// {@template amarPay_config}
/// This is the config for aamarPay
/// {@endtemplate}
class AamarPayConfig {
  /// {@macro amarPay_config}
  const AamarPayConfig({
    required this.email,
    required this.mobile,
    required this.signature,
    required this.storeID,
    required this.amount,
    required this.transactionId,
    required this.isSandBox,
    this.name,
    this.description,
    this.address1,
    this.address2,
    this.city,
    this.postCode,
    this.state,
  });

  /// email of the customer
  final String email;

  /// mobile of the customer
  final String mobile;

  /// name of the customer
  final String? name;

  /// signature key from aamarPay dashboard
  final String signature;

  /// storeID from aamarPay dashboard
  final String storeID;

  /// transaction amount
  final String amount;

  /// transaction id <br> ***must be unique for every payment***
  final String transactionId;

  /// transaction description
  final String? description;

  /// customer address
  final String? address1;

  /// customer secondary address
  final String? address2;

  /// customer city
  final String? city;

  /// customer postCode
  final String? postCode;

  /// customer state
  final String? state;

  /// isSandBox
  final bool isSandBox;
}
