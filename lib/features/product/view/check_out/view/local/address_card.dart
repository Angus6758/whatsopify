
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/address/controller/address_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/controller/checkout_ctrl.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/widget_ex.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/user_content/checkout_model.dart';
import 'package:seller_management/routes/go_route_name.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    this.onChangeTap,
    required this.checkout,
  });

  final Function()? onChangeTap;
  final CheckoutModel checkout;

  @override
  Widget build(BuildContext context) {
    final billing = checkout.billingAddress;
    return InkWell(
      onTap: billing != null
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => AddressBottomSheet(billing?.id),
              );
            },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.colors.secondaryContainer.withOpacity(
            context.isDark ? 0.2 : 0.05,
          ),
          border: Border.all(
            color: context.colors.secondaryContainer,
            width: 1,
          ),
        ),
        alignment: billing == null ? Alignment.center : null,
        padding: defaultPaddingAll,
        child: billing == null
            ? Text(
                TR.chooseAddress(context),
                style: context.textTheme.titleMedium,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          billing.fullName,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: context.colors.secondary,
                        ),
                        onPressed: onChangeTap ??
                            () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => AddressBottomSheet(
                                  billing.id,
                                ),
                              );
                            },
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: Text(TR.change(context)),
                      ),
                    ],
                  ),
                  if (billing.phone != null) const SizedBox(height: 8),
                  Text(
                    billing.phone ?? '',
                    style: context.textTheme.bodyLarge,
                  ).removeIfEmpty(),
                  Text(
                    billing.email,
                    style: context.textTheme.bodyLarge,
                  ).removeIfEmpty(),
                  const Gap(8),
                  if (billing.country != null)
                    Text(
                      'Country: ${billing.country!.name}',
                      style: context.textTheme.bodyLarge,
                    ),
                  if (billing.state != null)
                    Text(
                      'State: ${billing.state!.name}',
                      style: context.textTheme.bodyLarge,
                    ),
                  if (billing.city != null)
                    Text(
                      'City: ${billing.city!.name}',
                      style: context.textTheme.bodyLarge,
                    ),
                  Text(
                    'Address: ${billing.address}',
                    style: context.textTheme.bodyLarge,
                  ),
                  if (checkout.shipping != null) ...[
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        style: context.textTheme.bodyLarge,
                        children: [
                          TextSpan(text: '${TR.shippingBy(context)}: '),
                          TextSpan(
                            text: checkout.shipping?.methodName ?? 'N/A',
                            style: context.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class AddressBottomSheet extends HookConsumerWidget {
  const AddressBottomSheet(this.addressKey, {super.key});
  final int? addressKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressListProvider);
    final aniCtrl = useAnimationController();
    return BottomSheet(
      animationController: aniCtrl,
      showDragHandle: true,
      onClosing: () {},
      builder: (c) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        padding: defaultPadding,
        child: Column(
          children: [
            Text(
              TR.chooseAddress(context),
              style: context.textTheme.titleLarge,
            ),
            const Divider(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 40),
                foregroundColor: context.colors.secondary,
                side: BorderSide(
                  color: context.colors.secondary,
                  width: 1,
                ),
              ),
              onPressed: () => RouteNames.address.pushNamed(context),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(TR.addAddress(context)),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: defaultScrollPhysics,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Card(
                  elevation: 0,
                  color: context.colors.secondary
                      .withOpacity(addressKey == address.id ? .1 : .05),
                  shape: RoundedRectangleBorder(
                    borderRadius: defaultRadius,
                    side: addressKey != address.id
                        ? BorderSide.none
                        : BorderSide(
                            color: context.colors.secondaryContainer,
                          ),
                  ),
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(address.fullName),
                    subtitle: Text(address.address),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      ref
                          .read(checkoutCtrlProvider.notifier)
                          .setBilling(address);
                      context.pop();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
