import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';

import '../controller/seller_info_ctrl.dart';

class SellerProfileView extends HookConsumerWidget {
  const SellerProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellerData = ref.watch(sellerCtrlProvider);
    final sellerCtrl = useCallback(() => ref.read(sellerCtrlProvider.notifier));
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final file = useState<Either<File?, String>>(left(null));

    useEffect(() {
      sellerData.maybeWhen(
        orElse: () => null,
        data: (data) => file.value = right(data.image),
      );
      return null;
    }, [sellerData]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.seller_profile.tr(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => sellerCtrl().reload(),
        child: SingleChildScrollView(
          child: sellerData.when(
            loading: Loader.new,
            error: ErrorView.new,
            data: (seller) {
              return Padding(
                padding: Insets.padAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShadowContainer(
                      child: Padding(
                        padding: Insets.padAll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Column(
                                  children: [
                                    file.value.fold(
                                      (l) => CircleAvatar(
                                        radius: 55,
                                        backgroundImage:
                                            l == null ? null : FileImage(l),
                                        child: l != null
                                            ? null
                                            : const Icon(Icons.image),
                                      ),
                                      (r) => CircleImage(r, radius: 55),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      final files =
                                          await locate<FilePickerRepo>()
                                              .pickImage();
                                      files.fold(
                                        (l) => Toaster.showError(l),
                                        (r) => file.value = left(r),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          context.colorTheme.primary,
                                      child: SvgPicture.asset(
                                        AssetsConst.edit,
                                        height: 20,
                                        // color: context.colorTheme.onPrimary,
                                        colorFilter: ColorFilter.mode(
                                          context.colorTheme.onPrimary,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Gap(Insets.med),
                            Text(
                              seller.name,
                              style: context.textTheme.titleLarge,
                            ),
                            Text(
                              seller.balance.formate(),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorTheme.onSurface
                                    .withOpacity(.5),
                              ),
                            ),
                            const Gap(Insets.lg),
                            SellerProfileRow(
                              title: LocaleKeys.user_name.tr(),
                              data: seller.username,
                            ),
                            const Divider(),
                            SellerProfileRow(
                              title: LocaleKeys.phone.tr(),
                              data: seller.phone,
                            ),
                            const Divider(),
                            SellerProfileRow(
                              title: LocaleKeys.email.tr(),
                              data: seller.email,
                            ),
                            const Gap(Insets.lg),
                          ],
                        ),
                      ),
                    ),
                    const Gap(Insets.lg),
                    ShadowContainer(
                      child: Padding(
                        padding: Insets.padAll,
                        child: FormBuilder(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.name.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'name',
                                initialValue: seller.name,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_your_name.tr(),
                                ),
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.email.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'email',
                                initialValue: seller.email,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_email.tr(),
                                ),
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.phone.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'phone',
                                initialValue: seller.phone,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_phone_number.tr(),
                                ),
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.address.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'address',
                                initialValue: seller.address?.address,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_address.tr(),
                                ),
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.city.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'city',
                                initialValue: seller.address?.city,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_city.tr(),
                                ),
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.state.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'state',
                                initialValue: seller.address?.state,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_state.tr(),
                                ),
                              ),
                              const Gap(Insets.med),
                              Text(
                                LocaleKeys.zip_code.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              const Gap(Insets.sm),
                              FormBuilderTextField(
                                name: 'zip',
                                initialValue: seller.address?.zip,
                                decoration: InputDecoration(
                                  hintText: LocaleKeys.enter_zip_code.tr(),
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
                        l.value = true;
                        final state = formKey.currentState!;
                        if (!state.saveAndValidate()) return;

                        final data = state.value;

                        await sellerCtrl().updateSellerInfo(
                          data,
                          file.value.fold((l) => l, (r) => null),
                        );
                        l.value = false;
                      },
                      child: Text(LocaleKeys.update.tr()),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SellerProfileRow extends StatelessWidget {
  const SellerProfileRow({
    super.key,
    required this.title,
    required this.data,
  });
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          data,
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
