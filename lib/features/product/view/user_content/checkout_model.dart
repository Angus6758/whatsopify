import 'package:collection/collection.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/settings/shipping_model.dart';
import 'package:seller_management/features/product/view/settings/shipping_zone.dart';
import 'package:seller_management/features/product/view/user_content/billing_address.dart';
import 'package:seller_management/features/product/view/user_content/carts_model.dart';


class CheckoutModel {
  const CheckoutModel({
    required this.couponCode,
    required this.payment,
    required this.shipping,
    required this.billingAddress,
    this.carts = const [],
    this.createAccount = false,
    this.inputs = const {},
    this.zones = const [],
  });

  static CheckoutModel empty = const CheckoutModel(
    couponCode: '',
    payment: null,
    shipping: null,
    billingAddress: null,
  );

  final BillingAddress? billingAddress;
  final List<CartData> carts;
  final String couponCode;
  final bool createAccount;
  final Map<String, dynamic> inputs;
  final PaymentData? payment;
  final ShippingData? shipping;
  final List<ShippingZone> zones;

  CheckoutModel copyWith({
    String? couponCode,
    PaymentData? payment,
    ShippingData? shippingUid,
    BillingAddress? billingAddress,
    List<CartData>? carts,
    bool? createAccount,
    Map<String, dynamic>? inputs,
    List<ShippingZone>? zones,
  }) {
    return CheckoutModel(
      billingAddress: billingAddress ?? this.billingAddress,
      carts: carts ?? this.carts,
      couponCode: couponCode ?? this.couponCode,
      payment: payment ?? this.payment,
      shipping: shippingUid ?? shipping,
      createAccount: createAccount ?? this.createAccount,
      inputs: inputs ?? this.inputs,
      zones: zones ?? this.zones,
    );
  }

  ShippingZone? zone() {
    return zones.firstWhereOrNull(
      (x) => x.countries.map((e) => e.id).contains(billingAddress?.country?.id),
    );
  }

  num? priceConfig([ShippingData? shipping]) {
    final amount = carts.map((e) => e.total).sum;
    final weight = carts.map((e) => e.product.weight * e.quantity).sum;

    final ship = shipping ?? this.shipping;

    if (ship == null) return null;

    final price = ship.priceConfigs.firstWhereOrNull(
      (x) =>
          x.zoneId == zone()?.id &&
          x.isBetween(ship.type.isPriceWise ? amount : weight),
    );
    return price?.cost;
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    //* check if payment method is COD and pass the appropriate code
    final paymentCode = payment?.isCOD == true ? 0 : payment?.id;

    result.addAll({'address_id': billingAddress?.id});
    result.addAll({'payment_id': paymentCode});
    result.addAll({'shipping_method': shipping?.uid});
    result.addAll({'coupon_code': couponCode});
    result.addAll({
      'custom_input': {
        for (var key in inputs.keys) key: inputs[key],
      }.nonNull(),
    });

    return result.removeNullAndEmpty();
  }

  Map<String, dynamic> toGuestMap() {
    final result = <String, dynamic>{};

    //* check if payment method is COD and pass the appropriate code
    final paymentCode = payment?.isCOD == true ? 0 : payment?.id;

    result.addAll({'first_name': billingAddress?.firstName});
    result.addAll({'last_name': billingAddress?.lastName});
    result.addAll({'address': billingAddress?.address});
    result.addAll({'email': billingAddress?.email});
    result.addAll({'phone': billingAddress?.phone});
    result.addAll({'city_id': billingAddress?.city?.id});
    result.addAll({'state_id': billingAddress?.state?.id});
    result.addAll({'country_id': billingAddress?.country?.id});
    result.addAll({'latitude': billingAddress?.lat});
    result.addAll({'longitude': billingAddress?.lng});
    result.addAll({'zip': billingAddress?.zipCode});
    result.addAll({'payment_id': paymentCode});
    result.addAll({'shipping_method': shipping?.uid});
    if (createAccount) result.addAll({'create_account': 1});
    result.addAll(
      {
        'custom_input': {
          for (var key in inputs.keys) key: inputs[key],
        },
      },
    );
    result.addAll(
      {
        'items': [
          for (var item in carts)
            {
              'uid': item.product.uid,
              'qty': item.quantity,
              'price': item.baseDiscount + item.tax,
              'original_price': item.basePrice + item.tax,
              'discount': item.price - item.discount,
              'total_taxes': item.tax,
              'attribute': item.variant,
            }
        ],
      },
    );

    return result;
  }
}
