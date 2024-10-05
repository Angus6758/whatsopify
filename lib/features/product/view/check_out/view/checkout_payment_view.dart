
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_widgets/app_image.dart';
import 'package:seller_management/_widgets/flex/separated_flex.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/check_out/controller/checkout_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/view/local/address_card.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/settings/config_model.dart';
import 'package:seller_management/features/product/view/settings/controller/settings_ctrl.dart';
import 'package:seller_management/features/product/view/settings/payment_model.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

class CheckoutPaymentView extends HookConsumerWidget {
  const CheckoutPaymentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutCtrl = ref.read(checkoutCtrlProvider.notifier);
    final checkout = ref.watch(checkoutCtrlProvider);
    final config = ref.watch(settingsProvider);
    final isLoggedIn = ref.watch(authCtrlProvider);
    if (config == null) return ErrorView1.withScaffold('Settings not found');

    final ConfigModel(:settings, :paymentMethods, :offlinePaymentMethods) =
        config;

    final inputs = checkout.payment?.manualInputs ?? [];

    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final enabled = settings.digitalPayment ||
        settings.offlinePayment ||
        settings.cashOnDelivery;

    final isCarrierSpecific =
        config.settings.shippingConfig.type.isCarrierSpecific;

    return Scaffold(
      appBar: KAppBar(
        title: Text(TR.checkout(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(settingsCtrlProvider.notifier).reload(),
        child: SingleChildScrollView(
          padding: defaultPadding,
          physics: defaultScrollPhysics,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              if (!isLoggedIn) ...[
                Text(
                  TR.shippingAddress(context),
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                AddressCard(
                  checkout: checkout,
                  onChangeTap: () =>
                      RouteNames.shippingDetails.goNamed(context),
                ),
              ],
              if (!settings.digitalPayment && settings.cashOnDelivery) ...[
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: defaultRadius,
                    color: context.colors.secondaryContainer.withOpacity(.05),
                    border: (checkout.payment?.isCOD ?? false)
                        ? Border.all(
                            color: context.colors.secondaryContainer,
                            width: 1,
                          )
                        : null,
                  ),
                  padding: defaultPaddingAll,
                  child: ListTile(
                    leading: Assets.logo.cod.image(height: 50, width: 50),
                    title: Text(PaymentData.codPayment.name),
                    onTap: () => checkoutCtrl.setCodPayment(),
                  ),
                ),
              ],
              if (settings.digitalPayment) ...[
                const SizedBox(height: 20),
                Text(
                  TR.paymentMethod(context),
                  style: context.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _PaymentSelectionGrid(
                  methods: [
                    if (settings.cashOnDelivery) PaymentData.codPayment,
                    ...paymentMethods,
                  ],
                  onChange: () => formKey.currentState?.reset(),
                ),
              ],
              if (settings.offlinePayment) ...[
                const SizedBox(height: 20),
                Text(
                  TR.offlinePayment(context),
                  style: context.textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                _PaymentSelectionGrid(
                  methods: offlinePaymentMethods,
                  onChange: () => formKey.currentState?.reset(),
                ),
                if (inputs.isNotEmpty)
                  FormBuilder(
                    key: formKey,
                    child: _OfflinePayInputs(
                      inputs: inputs,
                      key: ValueKey(checkout.payment?.id),
                    ),
                  ),
              ],
              if (!enabled)
                const Center(
                  child: NoItemsAnimation(),
                ),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: defaultPaddingAll,
        height: 50,
        width: context.width - 40,
        child: FilledButton(
          onPressed: !enabled
              ? null
              : () {
                  final state = formKey.currentState;

                  if (checkout.payment == null) {
                    Toaster.showError(TR.selectPaymentMethod(context));
                    return;
                  }
                  if (isCarrierSpecific && checkout.shipping == null) {
                    Toaster.showError(TR.selectShippingMethod(context));
                    return;
                  }

                  if (state != null) {
                    if (!state.saveAndValidate()) return;

                    final inputKeys = checkout.payment?.inputKeys ?? [];

                    final data = state.value
                        .filterWithKey((k, _) => inputKeys.contains(k));

                    checkoutCtrl.setCustomInputData(data);
                  }

                  RouteNames.checkoutSummary.pushNamed(context);
                },
          child: Text(TR.submitOrder(context)),
        ),
      ),
    );
  }
}

class _OfflinePayInputs extends StatelessWidget {
  const _OfflinePayInputs({required this.inputs, super.key});

  final List<CustomInput> inputs;

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      separatorBuilder: () => const SizedBox(height: 15),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('Inputs', style: context.textTheme.headlineSmall),
        for (var input in inputs)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: input.name),
                    if (input.isRequired)
                      TextSpan(
                        text: ' *',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: context.colors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                  style: context.textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 5),
              FormBuilderTextField(
                name: input.name,
                decoration: InputDecoration(
                  hintText: input.name,
                ),
                maxLines: input.isTextArea ? null : 1,
                keyboardType: input.keyboardType,
                textInputAction: input.textInputAction,
                validator:
                    input.isRequired ? FormBuilderValidators.required() : null,
              ),
            ],
          ),
      ],
    );
  }
}

class _PaymentSelectionGrid extends ConsumerWidget {
  const _PaymentSelectionGrid({required this.methods, this.onChange});

  final List<PaymentData> methods;

  final Function()? onChange;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutCtrl = ref.read(checkoutCtrlProvider.notifier);
    final checkout = ref.watch(checkoutCtrlProvider);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: context.onMobile ? 3 : 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: methods.length,
      itemBuilder: (context, index) {
        return _MethodSelectorCard(
          method: methods[index],
          isSelected: checkout.payment?.id == methods[index].id,
          onTap: (data) {
            onChange?.call();
            checkoutCtrl.setPayment(data);
          },
        );
      },
    );
  }
}

class _MethodSelectorCard extends StatelessWidget {
  const _MethodSelectorCard({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentData method;
  final bool isSelected;
  final Function(PaymentData data) onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableCheckCard(
      header: ClipRRect(
        borderRadius: defaultRadius,
        child: method.isCOD
            ? Container(
                margin: const EdgeInsets.only(top: 5),
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.onErrorContainer,
                ),
                height: 60,
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    Assets.logo.cod.path,
                  ),
                ),
              )
            : HostedImage.square(method.image, dimension: 60),
      ),
      title: Text(
        method.name,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      isSelected: isSelected,
      onTap: () => onTap(method),
    );
  }
}

class SelectableCheckCard extends StatelessWidget {
  const SelectableCheckCard({
    super.key,
    this.onTap,
    required this.isSelected,
    this.header,
    required this.title,
    this.subTitle,
  });

  final Function()? onTap;
  final bool isSelected;
  final Widget? header;
  final Widget? title;
  final Widget? subTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: defaultRadius,
              color: context.colors.secondaryContainer.withOpacity(.05),
              border: isSelected
                  ? Border.all(
                      color: context.colors.secondaryContainer,
                      width: 1,
                    )
                  : null,
            ),
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (header != null) header!,
                    const SizedBox(height: 10),
                    if (title != null) title!,
                    const SizedBox(height: 5),
                    if (subTitle != null) subTitle!,
                  ],
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              top: 5,
              right: 15,
              child: CircleAvatar(
                radius: 12,
                child: Icon(
                  Icons.done,
                  size: 15,
                  color: context.colors.onError,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
