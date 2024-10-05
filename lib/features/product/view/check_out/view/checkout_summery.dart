

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_widgets/app_image.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/cart/controller/carts_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/controller/checkout_ctrl.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/extensions/widget_ex.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/settings/shipping_zone.dart';
import 'package:seller_management/features/product/view/spaced_text.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/user_content/carts_model.dart';
import 'package:seller_management/routes/go_route_name.dart';



class CheckoutSummeryView extends HookConsumerWidget {
  const CheckoutSummeryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config =
        ref.watch(settingsProvider.select((v) => v?.settings.shippingConfig));

    if (config == null) return ErrorView1.withScaffold('Settings not found');

    final carts = ref
        .watch(cartCtrlProvider.select((data) => data.valueOrNull?.listData));
    final checkout = ref.watch(checkoutCtrlProvider);
    final checkoutCtrl =
        useCallback(() => ref.read(checkoutCtrlProvider.notifier));
    final isLoggedIn = ref.read(authCtrlProvider);
    final isLoading = useState(false);

    //! Calculation

    final originalTotal = carts?.map((e) => e.originalTotal).sum ?? 0;
    final allTax = (carts?.map((e) => e.totalTaxes).sum ?? 0)
        .formateSelf(rateCheck: !isLoggedIn);
    // final totalDiscount = carts?.map((e) => e.discount * e.quantity).sum ?? 0;

    num shipping() {
      final result = switch (config.type) {
        ShippingType.carrierSpecific =>
          checkout.priceConfig()?.formateSelf(rateCheck: true),
        ShippingType.productCentric =>
          checkout.carts.map((e) => e.shippingFeeFormatted).sum,
        ShippingType.flat => config.standardFee.formateSelf(rateCheck: true),
        ShippingType.locationBased => checkout
            .billingAddress?.city?.shippingFees
            .formateSelf(rateCheck: true),
      };

      return result ?? 0;
    }

    final cartTotal = (carts?.map((e) => e.total).sum ?? 0)
        .formateSelf(rateCheck: !isLoggedIn);

    num total = cartTotal + shipping();

    if (!isLoggedIn) total += allTax;

    final charge = (total / 100) * (checkout.payment?.percentCharge ?? 0);

    final couponCodeCtrl = useTextEditingController();

    final ifFreeShipping = config.type.isCarrierSpecific &&
        (checkout.shipping?.isFreeShipping ?? false);

    return Scaffold(
      appBar: KAppBar(
        title: Text(TR.summery(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          isLoading: isLoading.value,
          onPressed: () async {
            if (couponCodeCtrl.text.isNotEmpty) {
              checkoutCtrl().setCoupon(couponCodeCtrl.text);
            }
            isLoading.value = true;
            final result = await checkoutCtrl().submitOrder(
              onUrlLaunch: (id) => RouteNames.afterPayment
                  .goNamed(context, query: {'status': 'w', 'id': id}),
            );
            isLoading.value = false;

            if (!context.mounted) return;
            if (result) RouteNames.orderPlaced.goNamed(context);
          },
          child: Text(TR.submitOrder(context)),
        ),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPadding.copyWith(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //! shipping
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: context.width),
                  Text(
                    TR.shippingDetails(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    checkout.billingAddress?.fullName ?? '--',
                    style: context.textTheme.titleMedium,
                  ),
                  Text(
                    checkout.billingAddress?.phone ?? '',
                    style: context.textTheme.titleMedium,
                  ).removeIfEmpty(),
                  Text(
                    checkout.billingAddress?.email ?? '',
                    style: context.textTheme.titleMedium,
                  ).removeIfEmpty(),
                  Text(
                    'Country : ${checkout.billingAddress?.country?.name ?? '--'}',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    'State :${checkout.billingAddress?.state?.name ?? '--'}',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    'City :${checkout.billingAddress?.city?.name ?? '--'}',
                    style: context.textTheme.bodyLarge,
                  ),
                  Text(
                    checkout.billingAddress?.address ?? '--',
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            //! shipping method
            if (checkout.shipping != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.secondaryContainer.withOpacity(0.05),
                ),
                padding: defaultPaddingAll,
                margin: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TR.shippingBy(context),
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: defaultRadius,
                          child: HostedImage.square(
                            checkout.shipping?.image ?? 'N/A',
                            dimension: 50,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              checkout.shipping?.methodName ?? 'N/A',
                              style: context.textTheme.titleMedium,
                            ),
                            Text(
                              '${TR.estimated(context)}: ${checkout.shipping?.duration ?? 'N/A'} days',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 15),

            //! payment method
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TR.paymentMethod(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (checkout.payment?.isCOD ?? false)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: defaultRadius,
                            color: context.colors.surface,
                          ),
                          height: 50,
                          width: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(Assets.logo.cod.path),
                          ),
                        )
                      else
                        ClipRRect(
                          borderRadius: defaultRadius,
                          child: HostedImage.square(
                            checkout.payment?.image ?? '',
                            dimension: 50,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            checkout.payment?.name ?? 'N/A',
                            style: context.textTheme.titleMedium,
                          ),
                          Text(
                            '${TR.charge(context)}: ${checkout.payment?.percentCharge}%',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (checkout.inputs.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.secondaryContainer.withOpacity(0.05),
                ),
                padding: defaultPaddingAll,
                width: context.width,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Information',
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    for (var MapEntry(:key, :value) in checkout.inputs.entries)
                      Text(
                        '$key : $value',
                        style: context.textTheme.titleMedium,
                      ),
                  ],
                ),
              ),

            const SizedBox(height: 15),
            //! Products
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TR.products(context)}: [${carts?.length}]',
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  if (carts == null)
                    Text(TR.somethingWentWrong(context))
                  else
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: CheckoutProductCard(cart: carts[index]),
                        );
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 40),
            if (isLoggedIn) ...[
              Text(
                TR.couponCode(context),
                style: context.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: couponCodeCtrl,
                onSubmitted: (v) {
                  checkoutCtrl().setCoupon(v);
                  couponCodeCtrl.clear();
                },
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.discount_outlined),
                  hintText: TR.enterCoupon(context),
                  suffixIcon: TextButton(
                    onPressed: () {
                      checkoutCtrl().setCoupon(couponCodeCtrl.text);
                      couponCodeCtrl.clear();
                    },
                    child: Text(TR.apply(context)),
                  ),
                ),
              ),
              if (checkout.couponCode.isNotEmpty) ...[
                const SizedBox(height: 10),
                SpacedText.diffStyle(
                  leftText: TR.yourCoupon(context),
                  rightText: checkout.couponCode,
                  styleRight: context.textTheme.titleMedium,
                  rightAction: IconButton(
                    padding: const EdgeInsets.all(3),
                    constraints: const BoxConstraints(),
                    onPressed: () => checkoutCtrl().setCoupon(''),
                    icon: const Icon(Icons.cancel_outlined),
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text('The coupon will be applied at checkout'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 15),
            ],
            Container(
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
              ),
              padding: defaultPaddingAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TR.billingInfo(context),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  SpacedText(
                    leftText: 'Original Amount',
                    rightText: originalTotal.formate(rateCheck: !isLoggedIn),
                  ),
                  const Divider(),
                  const Gap(5),
                  SpacedText(
                    leftText: 'All Taxes',
                    rightText: allTax.formate(),
                  ),
                  const SizedBox(height: 5),
                  // SpacedText(
                  //   leftText: 'Regular Discount',
                  //   rightText: totalDiscount.formate(rateCheck: !isLoggedIn),
                  // ),
                  // const SizedBox(height: 5),
                  SpacedText(
                    leftText: TR.shippingCharge(context),
                    rightText: ifFreeShipping ? 'Free' : shipping().formate(),
                  ),
                  SpacedText(
                    leftText: TR.charge(context),
                    rightText: charge.formate(),
                  ),
                  const SizedBox(height: 5),
                  SpacedText(
                    leftText: TR.total(context),
                    rightText: (total + charge).formate(),
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (!isLoggedIn) ...[
              Card(
                elevation: 0,
                color: context.colors.secondaryContainer.withOpacity(0.05),
                child: CheckboxListTile(
                  title: Text(TR.registerWithEmail(context)),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkout.createAccount,
                  onChanged: (v) => checkoutCtrl().toggleCreateAccount(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.info_outline_rounded),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(TR.submitWithoutAccountWarn(context)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class CheckoutProductCard extends ConsumerWidget {
  const CheckoutProductCard({
    required this.cart,
    super.key,
  });
  final CartData cart;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.read(authCtrlProvider);

    return Container(
      decoration: BoxDecoration(
        borderRadius: defaultRadius,
        color: context.colors.surface,
      ),
      child: Padding(
        padding: defaultPaddingAll,
        child: Row(
          children: [
            ClipRRect(
              child: HostedImage.square(
                cart.product.featuredImage,
                dimension: 80,
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.product.name,
                    style: context.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        if (isLoggedIn)
                          TextSpan(
                            text: cart.price.formate(),
                          )
                        else
                          TextSpan(
                            text: cart.baseDiscount.formate(rateCheck: true),
                          ),
                        TextSpan(
                          text: ' x ${cart.quantity}',
                        ),
                        TextSpan(
                          text: ' (${cart.variant})',
                        ),
                      ],
                      style: context.textTheme.bodyLarge!
                          .copyWith(color: context.colors.outlineVariant),
                    ),
                    maxLines: 2,
                  ),
                  Text(
                    'Total: ${cart.total.formate(rateCheck: !isLoggedIn)}',
                    style: context.textTheme.bodyLarge!,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
