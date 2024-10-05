
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_widgets/app_image.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/check_out/controller/checkout_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/view/local/address_card.dart';
import 'package:seller_management/features/product/view/check_out/view/local/billing_address_fields.dart';
import 'package:seller_management/features/product/view/check_out/view/local/selectable_card.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/scrollable_flex.dart';
import 'package:seller_management/features/product/view/settings/controller/settings_ctrl.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

class CheckoutShippingView extends HookConsumerWidget {
  const CheckoutShippingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final checkout = ref.watch(checkoutCtrlProvider);

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final isLoggedIn = ref.watch(authCtrlProvider);
    if (settings == null) return ErrorView1.withScaffold('Settings not found');

    final isCarrierSpecific =
        settings.settings.shippingConfig.type.isCarrierSpecific;
    return Scaffold(
      appBar: KAppBar(
        title: Text(TR.checkout(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        actions: [
          if (kDebugMode)
            IconButton(
              onPressed: () {
                formKey.currentState?.patchValue({
                  'first_name': 'waw',
                  'last_name': 'aaa',
                  'phone': '01234567899',
                  'email': 'waw@example.com',
                  'address': 'test address',
                  'country_id': 1,
                  'state_id': 8,
                  'city_id': 2,
                  'zip': '12345',
                  'latitude': '0.0',
                  'longitude': '0.0',
                });
              },
              icon: const Icon(Icons.pattern),
            ),
        ],
      ),
      body: Padding(
        padding: defaultPadding,
        child: RefreshIndicator(
          onRefresh: () => ref.read(settingsCtrlProvider.notifier).reload(),
          child: SingleChildScrollView(
            physics: defaultScrollPhysics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                //! shipping details
                if (!isLoggedIn)
                  FormBuilder(
                    key: formKey,
                    child: BillingAddressFields(formKey: formKey),
                  )
                else
                  AddressCard(checkout: checkout),

                const SizedBox(height: 30),

                //! Delivery Method
                if (isCarrierSpecific) ...[
                  Text(
                    TR.shoppingMethod(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 15),
                  ScrollableFlex(
                    clipBehavior: Clip.none,
                    children: [
                      ...settings.validShipping.map(
                        (ship) {
                          final priceConfig = checkout.priceConfig(ship);

                          return SelectableCard(
                            header: HostedImage(
                              ship.image,
                              height: 50,
                              width: 90,
                              fit: BoxFit.contain,
                            ),
                            isSelected: checkout.shipping?.uid == ship.uid,
                            onTap: () => checkoutCtrl().setShipping(ship),
                            title: Text(
                              ship.methodName,
                              textAlign: TextAlign.center,
                            ),
                            subTitle: priceConfig == null
                                ? Text(
                                    ship.isFreeShipping ? 'Free' : 0.formate(),
                                  )
                                : Text(
                                    priceConfig.formate(rateCheck: true),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          onPressed: () {
            // if user is Guest validate billing fields and save them
            if (!isLoggedIn) {
              final isValid = formKey.currentState?.saveAndValidate(
                autoScrollWhenFocusOnInvalid: true,
              );
              if (isValid != true) return;

              final data = formKey.currentState!.value;

              checkoutCtrl().setBillingFromMap(data);
            }

            if (isCarrierSpecific && checkout.shipping == null) {
              Toaster.showError(TR.selectShippingMethod(context));
              return;
            }

            if (ref.watch(checkoutCtrlProvider).billingAddress == null) {
              Toaster.showError(TR.nextPay(context));
              return;
            }
            RouteNames.checkoutPayment.pushNamed(context);
          },
          child: Text(TR.nextPay(context)),
        ),
      ),
    );
  }
}
