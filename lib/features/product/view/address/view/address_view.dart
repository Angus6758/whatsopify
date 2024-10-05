
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/product/view/address/controller/address_ctrl.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/dashed_rect.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/user_content/billing_address.dart';
import 'package:seller_management/features/product/view/user_dash/controller/dash_ctrl.dart';
import 'package:seller_management/routes/go_route_name.dart';

class AddressView extends ConsumerWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressListProvider);
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(TR.street(context)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(userDashCtrlProvider.notifier).reload();
        },
        child: Padding(
          padding: defaultPadding,
          child: Column(
            children: [
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  RouteNames.addAddress13.pushNamed(context);
                },
                child: CustomPaint(
                  painter: DottedBorderPainter(context),
                  child: SizedBox(
                    width: context.width,
                    height: 120,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_location_alt_outlined,
                          size: 28,
                          color: context.colors.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          TR.addAddress(context),
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colors.primary,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  physics: defaultScrollPhysics,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: addresses.length,
                  itemBuilder: (context, index) {
                    final address = addresses[index];
                    return AddressTile(address: address);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressTile extends HookConsumerWidget {
  const AddressTile({
    super.key,
    required this.address,
  });
  final BillingAddress address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = useState(false);
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: defaultRadius,
            color: context.colors.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 6,
                color: context.colors.primaryContainer
                    .withOpacity(context.isDark ? 0.3 : 0.1),
                offset: const Offset(0, 0),
              ),
            ],
          ),
          padding: defaultPaddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: Corners.smBorder,
                      border: Border.all(
                        width: 0,
                        color: context.colors.primary,
                      ),
                    ),
                    child: const Icon(Icons.location_on_outlined),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      address.addressName,
                      maxLines: 1,
                      style: context.textTheme.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: defaultPaddingAll,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: InkWell(
                      onTap: () async {
                        isLoading.value = true;
                        await ref
                            .read(addressCtrlProvider(address).notifier)
                            .deleteAddress();
                        isLoading.value = false;
                      },
                      child: Assets.logo.delete.image(height: 20),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: defaultPaddingAll,
                    decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: InkWell(
                      onTap: () => RouteNames.editAddress
                          .pushNamed(context, extra: address),
                      child: Assets.logo.edit
                          .image(height: 20, color: context.colors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                address.fullName,
                style: context.textTheme.bodyLarge,
              ),
              Text(
                address.phone ?? 'N/A',
                style: context.textTheme.bodyLarge,
              ),
              Text(
                address.email,
                style: context.textTheme.bodyLarge,
              ),
              Text(
                address.address,
                style: context.textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        if (isLoading.value) const Positioned.fill(child: BlurredLoading())
      ],
    );
  }
}
