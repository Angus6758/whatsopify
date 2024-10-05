
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/region_settings/controller/region_ctrl.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/settings/region_model.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

import '../../../../../_widgets/_widgets.dart';

class RegionView extends ConsumerWidget {
  const RegionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(settingsProvider);
    final region = ref.watch(regionCtrlProvider);
    final regionCtrl = ref.read(regionCtrlProvider.notifier);
    return Scaffold(
      appBar: KAppBar(
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
        title: Text(TR.languageCurrency(context)),
      ),
      body: config == null
          ? const EmptyWidget.onError()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: defaultScrollPhysics,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      TR.language(context),
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ...config.languages.map(
                      (language) => LanguageTile(
                        language: language,
                        region: region,
                      ),
                    ),
                    const Divider(height: 40),
                    Text(
                      TR.currency(context),
                      style: context.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10),
                    ...config.currency.map(
                      (currency) => RadioListTile(
                        groupValue: region.currency?.uid,
                        value: currency.uid,
                        onChanged: (value) {
                          regionCtrl.setCurrencyCode(currency);
                         // AppRestart.restartApp(context);
                        },
                        secondary: Text.rich(
                          TextSpan(
                            text: currency.name,
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: ' (${currency.symbol})',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class LanguageTile extends ConsumerWidget {
  const LanguageTile({
    super.key,
    required this.language,
    required this.region,
  });

  final LanguagesData language;
  final RegionModel region;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionCtrl = ref.read(regionCtrlProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.secondary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
        ),
        child: RadioListTile(
          groupValue: region.langCode,
          value: language.code,
          onChanged: (value) {
            regionCtrl.setLangCode(language.code);
          //  AppRestart.restartApp(context);
          },
          secondary: Text(
            language.code.toUpperCase(),
            style: context.textTheme.titleLarge,
          ),
          title: Text(
            language.name,
            style: context.textTheme.bodyLarge,
          ),
          controlAffinity: ListTileControlAffinity.trailing,
        ),
      ),
    );
  }
}
