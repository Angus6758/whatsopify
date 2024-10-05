import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_widgets/app_image.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/check_out/controller/checkout_ctrl.dart';
import 'package:seller_management/features/product/view/check_out/view/checkout_payment_view.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/content/custom_info.dart';
import 'package:seller_management/features/product/view/content/digital_product_models.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/products/view/local/digital_product_card_animated.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

class DigitalProductShowcase extends HookConsumerWidget {
  const DigitalProductShowcase({super.key, required this.data});
  final List<DigitalProduct> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0);
    final autoScroll = useState(true);
    return CarouselSlider.builder(
      options: CarouselOptions(
        autoPlayCurve: Curves.easeOutQuart,
        viewportFraction: context.onMobile ? 0.75 : 0.4,
        onPageChanged: (index, reason) => currentIndex.value = index,
        clipBehavior: Clip.none,
        autoPlay: autoScroll.value,
        height: 400,
      ),
      itemCount: data.length,
      itemBuilder: (context, index, _) {
        return DigitalProductCardAnimated(
          product: data[index],
          height: 200,
          isExpanded: index == currentIndex.value,
          onButtonTap: () async {
            autoScroll.value = false;
            await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => DigitalBuySheet(product: data[index]),
            );
            autoScroll.value = true;
          },
        );
      },
    );
  }
}

class DigitalBuySheet extends HookConsumerWidget {
  const DigitalBuySheet({
    super.key,
    required this.product,
  });

  final DigitalProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useAnimationController();
    final paymentMethods =
    ref.watch(settingsProvider.select((value) => value?.paymentMethods));

    final digitalUid = useState<String?>(null);
    final paymentUid = useState<int?>(null);
    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    return SizedBox(
      height: context.height * 0.7,
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(10),
          child: SubmitButton(
            onPressed: product.attribute.isEmpty
                ? null
                : () async {
              // Form validation
              final formValid = formKey.currentState!.saveAndValidate();
              if (!formValid) return;

              // Further checks for digitalUid and paymentUid
              if (digitalUid.value == null) {
                Toaster.showError(TR.selectItemDigital(context));
                return;
              }
              if (paymentUid.value == null) {
                Toaster.showError(TR.selectPaymentMethod(context));
                return;
              }

              final formData = formKey.currentState!.value;

              await ref.read(checkoutCtrlProvider.notifier).buyNow(
                productUid: product.uid,
                digitalUid: digitalUid.value!,
                paymentUid: paymentUid.value!,
                email: formData['email'] ?? '',
                formData: formData,
                onSuccess: () =>
                    RouteNames.orderPlaced.goNamed(context),
                onUrlLaunch: (id) => RouteNames.afterPayment.goNamed(
                  context,
                  query: {'status': 'w', 'id': id},
                ),
              );
            },
            child: Text(TR.buyNow(context)),
          ),
        ),
        body: BottomSheet(
          animationController: ctrl,
          onClosing: () {},
          builder: (context) => SingleChildScrollView(
            padding: defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: HostedImage.square(
                        product.featuredImage,
                        dimension: 60,
                        enablePreviewing: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(product.name, style: context.textTheme.titleLarge),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  TR.attributes(context),
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                  product.attribute.isEmpty ? 1 : product.attribute.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                  itemBuilder: (context, index) {
                    if (product.attribute.isEmpty) {
                      return Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.colors.error.withOpacity(.05),
                          borderRadius: defaultRadius,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          TR.noAttribute(context),
                          style: context.textTheme.titleMedium,
                        ),
                      );
                    }
                    final attribute =
                    product.attribute.entries.toList()[index];
                    final selected = digitalUid.value == attribute.value.uid;
                    return ListTile(
                      onTap: () {
                        selected
                            ? digitalUid.value = null
                            : digitalUid.value = attribute.value.uid;
                      },
                      title: Text(attribute.key),
                      subtitle: Text(attribute.value.price.formate()),
                      leading: selected
                          ? const Icon(Icons.check_circle_rounded)
                          : const Icon(Icons.circle_outlined),
                      shape: RoundedRectangleBorder(
                        side: selected
                            ? BorderSide(
                          width: 1,
                          color: context.colors.secondary,
                        )
                            : BorderSide.none,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      tileColor:
                      context.colors.secondaryContainer.withOpacity(0.05),
                      iconColor: context.colors.secondaryContainer,
                    );
                  },
                ),
                const SizedBox(height: 10),
                FormBuilder(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ref.watch(authCtrlProvider)) ...[
                        Text(
                          TR.email(context),
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        FormBuilderTextField(
                          name: 'email',
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            hintText: TR.email(context),
                          ),
                          validator: FormBuilderValidators.compose(
                            [
                              FormBuilderValidators.required(),
                              FormBuilderValidators.email(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      CustomFieldsWidget(customFields: product.customInfo),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  TR.paymentMethod(context),
                  style: context.textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: context.onMobile ? 3 : 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: paymentMethods?.length ?? 1,
                  itemBuilder: (context, index) {
                    if (paymentMethods == null) {
                      return const Text('No Payment Method');
                    }
                    return SelectableCheckCard(
                      header: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: HostedImage(
                          paymentMethods[index].image,
                          height: 60,
                          width: 60,
                        ),
                      ),
                      title: Text(
                        paymentMethods[index].name,
                        textAlign: TextAlign.center,
                      ),
                      isSelected: paymentUid.value == paymentMethods[index].id,
                      onTap: () {
                        if (paymentUid.value == paymentMethods[index].id) {
                          return paymentUid.value = null;
                        }
                        paymentUid.value = paymentMethods[index].id;
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CustomFieldsWidget extends ConsumerWidget {
  const CustomFieldsWidget({super.key, required this.customFields});

  final Map<String, CustomInfo> customFields;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (customFields.isEmpty) return const SizedBox.shrink();

    TextInputType? textInputType(KFieldType type) => switch (type) {
      KFieldType.number => TextInputType.number,
      KFieldType.textarea => TextInputType.multiline,
      KFieldType.text => null,
      KFieldType.select => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Custom Fields',
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        for (final value in customFields.values)
          if (value.type == KFieldType.select)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FormBuilderCheckboxGroup<String>(
                name: value.name,
                options: [
                  ...value.optionsList.map(
                        (e) => FormBuilderFieldOption(
                      value: e,
                      child: Text(e),
                    ),
                  ),
                ],
                validator:
                value.isRequired ? FormBuilderValidators.required() : null,
                decoration: InputDecoration(
                  label: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: value.label),
                        if (value.isRequired)
                          TextSpan(
                            text: ' *',
                            style: context.textTheme.titleMedium?.copyWith(
                             color: context.colors.primary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FormBuilderTextField(
                name: value.name,
                validator:
                value.isRequired ? FormBuilderValidators.required() : null,
                inputFormatters: [
                  if (value.type == KFieldType.number)
                    FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: textInputType(value.type),
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  label: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: value.label),
                        // if (value.isRequired)
                        TextSpan(
                          text: ' *',
                          style: context.textTheme.titleMedium?.copyWith(
                           color: context.colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                maxLines: value.type == KFieldType.textarea ? 4 : 1,
              ),
            ),
        const SizedBox(height: 10),
      ],
    );
  }
}
