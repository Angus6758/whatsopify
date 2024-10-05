
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/base/order_base.dart';
import 'package:seller_management/features/product/view/cart/controller/carts_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/repository/checkout_repo.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/settings/country.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/settings/shipping_model.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:seller_management/features/product/view/user_content/billing_address.dart';
import 'package:seller_management/features/product/view/user_content/checkout_model.dart';
import 'package:seller_management/features/product/view/user_dash/controller/dash_ctrl.dart';
import 'package:seller_management/features/product/view/user_dash/provider/user_dash_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../../locator.dart';

final checkoutCtrlProvider =
    AutoDisposeNotifierProvider<CheckoutCtrlNotifier, CheckoutModel>(
        CheckoutCtrlNotifier.new);

class CheckoutCtrlNotifier extends AutoDisposeNotifier<CheckoutModel> {
  @override
  CheckoutModel build() {
    final billing =
        ref.watch(userDashProvider.select((v) => v?.user.billingAddress));

    final carts =
        ref.watch(cartCtrlProvider.select((v) => v.valueOrNull?.listData));

    final settings = ref.watch(settingsProvider.select((v) => v?.zones));

    return CheckoutModel.empty.copyWith(
      billingAddress: billing?.firstOrNull,
      carts: carts,
      zones: settings,
    );
  }

  CheckoutRepo get _repo => ref.watch(checkoutRepoProvider);

  void setShipping(ShippingData shippingUid) =>
      state = state.copyWith(shippingUid: shippingUid);

  void setPayment(PaymentData payment) {
    final iCodActive = ref.watch(
        settingsProvider.select((v) => v?.settings.cashOnDelivery ?? false));
    if (payment.isCOD && !iCodActive) {
      Toaster.showError('Cash on delivery is not available');
      return;
    }

    state = state.copyWith(payment: payment, inputs: {});
  }

  void setCodPayment() =>
      state = state.copyWith(payment: PaymentData.codPayment);

  void setBilling(BillingAddress address) {
    state = state.copyWith(billingAddress: address);
  }

  void setBillingFromMap(Map<String, dynamic> map) {
    final billing = state.billingAddress ?? BillingAddress.empty;
    state = state.copyWith(billingAddress: billing.copyWithMap(map));
  }

  void copyWithAddress({
    ValueGetter<Country?>? country,
    ValueGetter<CountryState?>? cState,
    ValueGetter<StateCity?>? city,
    ValueGetter<String?>? lat,
    ValueGetter<String?>? lng,
  }) {
    final billing = state.billingAddress ?? BillingAddress.empty;
    state = state.copyWith(
      billingAddress: billing.copyWith(
        country: country,
        state: cState,
        city: city,
        lat: lat,
        lng: lng,
      ),
    );
  }

  void setCoupon(String coupon) => state = state.copyWith(couponCode: coupon);

  void toggleCreateAccount() {
    state = state.copyWith(createAccount: !state.createAccount);
  }

  void setCustomInputData(Map<String, dynamic> inputs) {
    state = state.copyWith(inputs: inputs);
  }

  Future<bool> submitOrder({
    Function(String id)? onUrlLaunch,
  }) async {
    final isLoggedIn = ref.read(authCtrlProvider);

    final res = await _repo.submitOrder(state, !isLoggedIn);

    return await res.fold(
      (l) async {
        Toaster.showError(l);
        return false;
      },
      (r) async {
        if (r.data.paymentUrl != null) {
          await launchUrlString(r.data.paymentUrl!);
          onUrlLaunch?.call(r.data.paymentLog.trx);
          Toaster.remove();
        }

        if (state.createAccount && r.data.accessToken != null) {
          await ref
              .read(authCtrlProvider.notifier).getToken();
             // .setWildAccessToken(r.data.accessToken!);
        }

        await _setOrderBaseState(r.data);
        await ref.read(cartCtrlProvider.notifier).clearGuestCart();

        if (isLoggedIn) await ref.read(userDashCtrlProvider.notifier).reload();

        Toaster.showSuccess(r.data.message);
        return true;
      },
    );
  }

  _setOrderBaseState(OrderBaseModel order) async {
    final pref = locate<SharedPreferences>();
    await pref.setString(CachedKeys.orderBase, order.toJson());
  }

  Future<void> buyNow({
    required String productUid,
    required String digitalUid,
    required int paymentUid,
    required String email,
    required Map<String, dynamic> formData,
    Function()? onSuccess,
    Function(String id)? onUrlLaunch,
  }) async {
    final isLoggedIn = ref.read(authCtrlProvider);
    final data = {
      'product_uid': productUid,
      'payment_id': paymentUid,
      'digital_attribute_uid': digitalUid,
      if (!isLoggedIn) 'email': email,
      ...formData,
    };

    Toaster.showLoading('Loading...');
    final res = await _repo.submitDigitalOrder(data: data);

    res.fold(
      (l) => Toaster.showError(l),
      (r) async {
        if (r.data.paymentUrl != null) {
          await launchUrlString(r.data.paymentUrl!);
          onUrlLaunch?.call(r.data.paymentLog.trx);
          Toaster.remove();
          return;
        }
        await _setOrderBaseState(r.data);
        Toaster.showSuccess(r.data.message);
        onSuccess?.call();
      },
    );
    if (isLoggedIn) ref.read(userDashCtrlProvider.notifier).reload();
  }
}
