import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_styled_widgets/decorated_container.dart';
import 'package:seller_management/features/add_product/view/app_bar.dart';
import 'package:seller_management/features/product/view/address/controller/address_ctrl.dart';
import 'package:seller_management/features/product/view/address_textfield.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/buttons/submit_button.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/strings/auto_fill.dart';
import 'package:seller_management/features/product/view/user_content/billing_address.dart';

import 'map_view.dart';

class AddAddressView1 extends HookConsumerWidget {
  const AddAddressView1({this.address, super.key});

  final BillingAddress? address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billAddress = ref.watch(addressCtrlProvider(address));
    final billAddressCtrl =
        useCallback(() => ref.read(addressCtrlProvider(address).notifier));

    final countries =
        ref.watch(settingsProvider.select((v) => v?.countries ?? []));

    final formKey = useMemoized(GlobalKey<FormBuilderState>.new);

    final isLoading = useState(false);

    onAddressSubmit() async {
      final state = formKey.currentState;

      final isValid =
          state!.saveAndValidate(autoScrollWhenFocusOnInvalid: true);

      final data = state.value;
      if (data['longitude'] == null || data['latitude'] == null) {
        Toaster.showError('Please select address on map');
        return;
      }
      if (isValid) {
        isLoading.value = true;

        await billAddressCtrl().submitAddress(data);

        isLoading.value = false;
        state.reset();
        if (context.mounted) context.pop();
      }
    }

    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: address == null
            ? Text(TR.createBilling(context))
            : Text(TR.update(context)),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        padding: defaultPaddingAll,
        child: FormBuilder(
          key: formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: context.colors.primaryContainer
                          .withOpacity(context.isDark ? 0.3 : 0.06),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: defaultPadding,
                child: Column(
                  children: [
                    KTextField(
                      name: 'first_name',
                      initialValue: billAddress.firstName,
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.firstName,
                      keyboardType: TextInputType.name,
                      title: TR.firstName(context),
                      hinText: TR.firstName(context),
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'last_name',
                      initialValue: billAddress.lastName,
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.lastName,
                      keyboardType: TextInputType.name,
                      title: TR.lastName(context),
                      hinText: TR.lastName(context),
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'phone',
                      initialValue: billAddress.phone,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.phone,
                      autofillHints: AutoFillHintList.phone,
                      isPhone: true,
                      title: TR.phone(context),
                      hinText: TR.phone(context),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(11),
                          FormBuilderValidators.maxLength(14),
                        ],
                      ),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'email',
                      initialValue: billAddress.email,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: AutoFillHintList.email,
                      title: TR.email(context),
                      hinText: TR.email(context),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.email(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: defaultRadius,
                  color: context.colors.surface,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      color: context.colors.primaryContainer
                          .withOpacity(context.isDark ? 0.3 : 0.06),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                padding: defaultPaddingAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KTextField(
                      name: 'address',
                      initialValue: billAddress.address,
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.address,
                      keyboardType: TextInputType.streetAddress,
                      title: TR.street(context),
                      hinText: TR.street(context),
                      validator: FormBuilderValidators.required(),
                      suffix: IconButton(
                        style: IconButton.styleFrom(
                          fixedSize: const Size.square(63),
                          backgroundColor:
                              context.colors.primary.withOpacity(.1),
                          foregroundColor: context.colors.primary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: Corners.medBorder,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddressMapView(
                              onLocationSelect: (latLng, address, code) {
                                final state = formKey.currentState!;
                                state.patchValue({
                                  'address': address,
                                  if (latLng != null) ...{
                                    'latitude': '${latLng.latitude}',
                                    'longitude': '${latLng.longitude}',
                                  },
                                  if (code != null) ...{
                                    'country_id': countries
                                        .firstWhereOrNull((e) => e.code == code)
                                        ?.id,
                                  },
                                });
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.location_on_rounded),
                      ),
                    ),
                    const Gap(5),
                    Row(
                      children: [
                        const Icon(Icons.my_location_rounded, size: 20),
                        const Gap(10),
                        Flexible(
                          child: FormBuilderField<String>(
                            name: 'latitude',
                            initialValue: billAddress.lat,
                            builder: (state) => Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'Lat: '),
                                  TextSpan(text: state.value ?? '--'),
                                ],
                              ),
                              style: context.textTheme.bodySmall,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        DecoratedContainer(
                          height: 15,
                          width: 1,
                          color: context.colors.primary,
                          margin: defaultPadding,
                        ),
                        Flexible(
                          child: FormBuilderField<String>(
                            name: 'longitude',
                            initialValue: billAddress.lng,
                            builder: (state) => Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: 'Lng: '),
                                  TextSpan(text: state.value ?? '--'),
                                ],
                              ),
                              style: context.textTheme.bodySmall,
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(15),
                    FormBuilderDropdown<int>(
                      name: 'country_id',
                      initialValue: billAddress.country?.id,
                      decoration: const InputDecoration(
                        hintText: 'Select Country',
                      ),
                      onChanged: (value) {
                        final state = formKey.currentState!;
                        state.patchValue({'state_id': null, 'city_id': null});
                        billAddressCtrl().setCountry(
                          countries.firstWhereOrNull((e) => e.id == value),
                        );
                      },
                      items: [
                        ...countries.map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ),
                        ),
                      ],
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    FormBuilderDropdown<int>(
                      name: 'state_id',
                      initialValue: billAddress.state?.id,
                      decoration: const InputDecoration(
                        hintText: 'Select State',
                      ),
                      onChanged: (value) {
                        final state = formKey.currentState!;
                        state.patchValue({'city_id': null});

                        billAddressCtrl().setState(
                          billAddress.country?.states
                              .firstWhereOrNull((e) => e.id == value),
                        );
                      },
                      items: [
                        ...?billAddress.country?.states.map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ),
                        ),
                      ],
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    FormBuilderDropdown<int>(
                      name: 'city_id',
                      initialValue: billAddress.city?.id,
                      decoration: const InputDecoration(
                        hintText: 'Select City',
                      ),
                      onChanged: (value) {
                        billAddressCtrl().setCity(
                          billAddress.state?.cities
                              .firstWhereOrNull((e) => e.id == value),
                        );
                      },
                      items: [
                        ...?billAddress.state?.cities.map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          ),
                        ),
                      ],
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                    KTextField(
                      name: 'zip',
                      initialValue: billAddress.zipCode,
                      textInputAction: TextInputAction.next,
                      autofillHints: AutoFillHintList.zip,
                      keyboardType: TextInputType.streetAddress,
                      title: TR.zipCode(context),
                      hinText: TR.zipCode(context),
                      validator: FormBuilderValidators.required(),
                    ),
                    const Gap(15),
                  ],
                ),
              ),
              const Gap(20),
              Container(
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
                    Text(
                      TR.addressName(context),
                    ),
                    const Gap(10),
                    FormBuilderTextField(
                      name: 'address_name',
                      initialValue: billAddress.addressName,
                      validator: FormBuilderValidators.required(),
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        hintText: 'e.g home, office',
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: defaultPaddingAll,
        child: SubmitButton(
          width: context.width,
          onPressed: onAddressSubmit,
          isLoading: isLoading.value,
          child: address != null
              ? Text(TR.update(context))
              : Text(TR.addAddress(context)),
        ),
      ),
    );
  }
}
