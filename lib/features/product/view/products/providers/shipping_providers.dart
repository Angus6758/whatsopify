
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/settings/shipping_model.dart';

final selectedShipProvider = StateProvider<ShippingData?>((ref) {
  return null;
});

final shipCtrlProvider = Provider<ShippingCtrl>((ref) {
  return ShippingCtrl(ref);
});

class ShippingCtrl {
  ShippingCtrl(this._ref);

  final Ref _ref;

  onChange(ShippingData? shipping) {
    _ref.read(selectedShipProvider.notifier).update((state) => shipping);
  }

  ShippingData? get getState => _ref.watch(selectedShipProvider);

  bool get isNull => getState == null;
}
