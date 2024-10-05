import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/region/controller/region_ctrl.dart';
import 'package:seller_management/features/settings/controller/settings_ctrl.dart';
import 'package:seller_management/main.export.dart';

class CurrencyView extends HookConsumerWidget {
  const CurrencyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(regionCtrlProvider.select((v) => v.currency));
    final currencies =
        ref.watch(localSettingsProvider.select((v) => v?.currencies ?? []));

    final animationController = useAnimationController(duration: Times.def);
    final animation = useAnimation(animationController);

    useEffect(() {
      animationController.forward(from: 0.0);
      return null;
    }, [currency]);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.currency.tr()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.read(settingsCtrlProvider.notifier).reload(),
        child: SingleChildScrollView(
          padding: Insets.padAll,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.selected_currency.tr(),
                style: context.textTheme.titleLarge,
              ),
              const Gap(16),
              Center(
                child: Opacity(
                  opacity: animation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorTheme.primary.withOpacity(.05),
                      borderRadius: Corners.medBorder,
                      border: Border.all(
                        width: 0,
                        color: context.colorTheme.primary,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      child: Text(
                        currency?.name ?? 'N/A',
                        style: context.textTheme.titleLarge!.copyWith(
                          color: context.colorTheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Gap(Insets.lg),
              const Divider(),
              const Gap(Insets.med),
              Text(
                LocaleKeys.all_currency.tr(),
                style: context.textTheme.titleLarge,
              ),
              const Gap(Insets.sm),
              Container(
                height: 2,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: context.colorTheme.primary,
                ),
              ),
              const Gap(Insets.lg),
              ListView.builder(
                shrinkWrap: true,
                itemCount: currencies.length,
                itemBuilder: (context, index) {
                  final cur = currencies[index];
                  return RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text(
                      cur.name,
                      style: context.textTheme.titleLarge,
                    ),
                    value: cur.uid,
                    groupValue: currency?.uid,
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(regionCtrlProvider.notifier).setCurrency(cur);
                        animationController.forward(from: 0.0);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
