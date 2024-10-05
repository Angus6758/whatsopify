import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';

import '../controller/seller_info_ctrl.dart';

class StoreInfoUpdateView extends HookConsumerWidget {
  const StoreInfoUpdateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellerData = ref.watch(sellerCtrlProvider);
    final sellerCtrl = useCallback(() => ref.read(sellerCtrlProvider.notifier));
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.store_info.tr()),
      ),
      body: sellerData.when(
        loading: Loader.new,
        error: ErrorView.new,
        data: (store) {
          return RefreshIndicator(
            onRefresh: () async => sellerCtrl().reload(),
            child: SingleChildScrollView(
              padding: Insets.padH,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(Insets.lg),
                  Text(
                    LocaleKeys.store_info.tr(),
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(Insets.med),
                  ShadowContainer(
                    child: Padding(
                      padding: Insets.padAll,
                      child: FormBuilder(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ImageInputField(
                              title: LocaleKeys.shop_logo.tr(),
                              name: '~shop_logo',
                              height: 40,
                              width: 40,
                              isCircler: true,
                              initialValue: store.shop.shopLogo.url,
                              imgDimension: store.shop.shopLogo.sizeGuide,
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            ImageInputField(
                              title: LocaleKeys.site_logo.tr(),
                              name: '~site_logo',
                              height: 50,
                              width: 100,
                              initialValue: store.shop.siteLogo.url,
                              imgDimension: store.shop.siteLogo.sizeGuide,
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            ImageInputField(
                              title: LocaleKeys.site_logo_icon.tr(),
                              name: '~site_logo_icon',
                              height: 50,
                              width: 100,
                              initialValue: store.shop.siteLogoIcon.url,
                              imgDimension: store.shop.siteLogoIcon.sizeGuide,
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            ImageInputField(
                              title: LocaleKeys.feature_image.tr(),
                              name: '~shop_feature_image',
                              height: 50,
                              width: 100,
                              initialValue: store.shop.shopFeatureImage.url,
                              imgDimension:
                                  store.shop.shopFeatureImage.sizeGuide,
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Text(
                              LocaleKeys.store_name.tr(),
                              style: context.textTheme.bodyLarge,
                            ),
                            const Gap(Insets.med),
                            FormBuilderTextField(
                              name: 'name',
                              initialValue: store.shop.name,
                              validator: FormBuilderValidators.required(),
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Text(
                              LocaleKeys.shop_phone.tr(),
                              style: context.textTheme.bodyLarge,
                            ),
                            const Gap(Insets.med),
                            FormBuilderTextField(
                              name: 'phone',
                              initialValue: store.shop.phone,
                              validator: FormBuilderValidators.required(),
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Text(
                              LocaleKeys.shop_email.tr(),
                              style: context.textTheme.bodyLarge,
                            ),
                            const Gap(Insets.med),
                            FormBuilderTextField(
                              name: 'email',
                              initialValue: store.shop.email,
                              decoration: InputDecoration(
                                hintText: LocaleKeys.enter_email.tr(),
                              ),
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Row(
                              children: [
                                Text(
                                  LocaleKeys.whatsapp_order.tr(),
                                  style: context.textTheme.bodyLarge,
                                ),
                                const Gap(Insets.sm),
                              ],
                            ),
                            const Gap(Insets.med),
                            FormBuilderField<int>(
                              name: 'whatsapp_order',
                              initialValue: store.shop.whatsAppActive.code,
                              builder: (state) => DropdownButtonFormField2<int>(
                                value: state.value,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onChanged: (value) => state.didChange(value),
                                items: [
                                  ...ActivationEnum.values.map(
                                    (e) => DropdownMenuItem(
                                      value: e.code,
                                      child: Text(e.name.toTitleCase),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Row(
                              children: [
                                Text(
                                  LocaleKeys.whatsapp_number.tr(),
                                  style: context.textTheme.bodyLarge,
                                ),
                                const Gap(Insets.sm),
                                Tooltip(
                                  triggerMode: TooltipTriggerMode.tap,
                                  message: LocaleKeys.whatsapp_tooltip.tr(),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: context.colorTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Gap(Insets.med),
                            FormBuilderTextField(
                              name: 'whatsapp_number',
                              initialValue: store.shop.whatsAppNumber,
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Text(
                              LocaleKeys.shop_address.tr(),
                              style: context.textTheme.bodyLarge,
                            ),
                            const Gap(Insets.med),
                            FormBuilderTextField(
                              name: 'address',
                              initialValue: store.shop.address,
                              decoration: const InputDecoration(),
                            ),
                            const Gap(Insets.med),
                            const Divider(),
                            const Gap(Insets.med),
                            Text(
                              LocaleKeys.shop_short_des.tr(),
                              style: context.textTheme.bodyLarge,
                            ),
                            const Gap(Insets.med),
                            SizedBox(
                              height: 100,
                              child: FormBuilderTextField(
                                maxLines: null,
                                expands: true,
                                keyboardType: TextInputType.multiline,
                                name: 'short_details',
                                initialValue: store.shop.shortDetails,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Gap(Insets.lg),
                  SubmitButton(
                    onPressed: (l) async {
                      final state = formKey.currentState!;
                      if (!state.saveAndValidate()) return;
                      l.value = true;
                      final data = state.value;

                      await sellerCtrl().updateStoreInfo(data);
                      l.value = false;
                    },
                    child: Text(
                      LocaleKeys.update.tr(),
                    ),
                  ),
                  const Gap(Insets.lg),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ImageInputField extends StatelessWidget {
  const ImageInputField({
    super.key,
    required this.name,
    required this.title,
    this.initialValue,
    this.height,
    this.width,
    this.isCircler = false,
    this.imgDimension,
  });

  final String name;
  final String title;

  final String? initialValue;
  final double? height;
  final double? width;
  final String? imgDimension;
  final bool isCircler;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: context.textTheme.bodyLarge,
            ),
            const Spacer(),
            FormBuilderField<Either<String, File>>(
              name: name,
              initialValue: initialValue == null ? null : left(initialValue!),
              builder: (state) => GestureDetector(
                onTap: () async {
                  final file =
                      await locate<FilePickerRepo>().pickImageFromGallery();
                  file.fold(
                    (l) => null,
                    (r) => state.didChange(right(r)),
                  );
                },
                child: SizedBox(
                  height: height,
                  width: width,
                  child: state.value?.fold(
                        (l) => isCircler ? CircleImage(l) : HostedImage(l),
                        (r) => isCircler
                            ? CircleAvatar(backgroundImage: FileImage(r))
                            : Image.file(r),
                      ) ??
                      const Icon(
                        Icons.add_photo_alternate_rounded,
                      ),
                ),
              ),
            ),
          ],
        ),
        if (imgDimension != null)
          Text(
            '${LocaleKeys.image_size_should_be.tr()} $imgDimension',
            style: context.textTheme.labelMedium
                ?.copyWith(color: context.colorTheme.error),
          ),
      ],
    );
  }
}
