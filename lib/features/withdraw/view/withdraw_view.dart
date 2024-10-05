import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/withdraw/controller/withdraw_ctrl.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';
import 'local/local.dart';

class WithdrawView extends HookConsumerWidget {
  const WithdrawView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawList = ref.watch(withdrawListCtrlProvider);
    final withdrawCtrl =
        useCallback(() => ref.read(withdrawListCtrlProvider.notifier));

    final searchCtrl = useTextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.withdraw.tr()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => withdrawCtrl().reload(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              ShadowContainer(
                margin: Insets.padH,
                width: double.infinity,
                height: 240,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DecoratedContainer(
                      color: context.colorTheme.errorContainer.withOpacity(.05),
                      padding: Insets.padAll,
                      borderRadius: Corners.med,
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            AssetsConst.idea,
                            height: 25,
                          ),
                          const Gap(Insets.med),
                          Expanded(
                            child: Text(
                              LocaleKeys.withdraw_title.tr(),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorTheme.errorContainer,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(Insets.med),
                    SvgPicture.asset(AssetsConst.withdraw, height: 80),
                    const Gap(Insets.lg),
                    FilledButton(
                      onPressed: () => RouteNames.withdrawNow.goNamed(context),
                      child: Text(LocaleKeys.withdraw_now.tr()),
                    ),
                  ],
                ),
              ),
              const Gap(Insets.lg),
              AllWithdrawTable(
                searchCtrl: searchCtrl,
                withdrawCtrl: withdrawCtrl,
                withdrawList: withdrawList,
              ),
              const Gap(Insets.sm),
            ],
          ),
        ),
      ),
    );
  }
}
