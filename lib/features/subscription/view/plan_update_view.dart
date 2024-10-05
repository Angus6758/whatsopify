import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/settings/controller/auth_config_ctrl.dart';
import 'package:seller_management/features/subscription/view/local/plan_point.dart';
import 'package:seller_management/main.export.dart';

import '../controller/subscription_ctrl.dart';
import 'local/plan_loder.dart';

class PlanUpdateView extends HookConsumerWidget {
  const PlanUpdateView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planList = ref.watch(subscriptionPlanProvider);
    final config = ref.watch(localAuthConfigProvider);
    final firstTime = useState(false);
    final reload = useState(false);

    Future<void> checkIfFirst() async {
      final data = await ref.read(isFirstSubscriptionProvider.future);
      firstTime.value = data;
    }

    useEffect(() {
      checkIfFirst();
      return null;
    }, [reload.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.plan_update.tr()),
      ),
      body: planList.when(
        error: ErrorView.new,
        loading: () => const PlanUpdateLoader(),
        data: (plans) {
          if (config == null) return const ErrorView('No Config', null);
          return RefreshIndicator(
            onRefresh: () async {
              reload.value = !reload.value;
              ref.invalidate(subscriptionListCtrlProvider);
              ref.invalidate(subscriptionPlanProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: Insets.padAll,
              child: SeparatedColumn(
                separatorBuilder: () => const Gap(Insets.lg),
                children: [
                  MasonryGridView.builder(
                    shrinkWrap: true,
                    itemCount: plans.length,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) => PlanCard(
                      plan: plans[index],
                      uid: config.subscription?.uid,
                      firstTime: firstTime.value,
                      isRenewable:
                          config.subscription?.plan.id == plans[index].id,
                      afterSubmit: () {
                        reload.value = !reload.value;
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlanCard extends HookConsumerWidget {
  const PlanCard({
    super.key,
    required this.plan,
    required this.uid,
    required this.firstTime,
    required this.isRenewable,
    this.afterSubmit,
  });

  final SubscriptionPlan plan;
  final String? uid;
  final bool firstTime;
  final bool isRenewable;
  final Function()? afterSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disableTap = plan.name.toLowerCase() == 'free' && !firstTime;
    final planCtrl =
        useCallback(() => ref.read(subscriptionPlanProvider.notifier));

    return ShadowContainer(
      child: Padding(
        padding: Insets.padAll,
        child: SeparatedColumn(
          separatorBuilder: () => const Gap(Insets.med),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name,
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: plan.amount.formate(),
                    style: context.textTheme.titleLarge!.copyWith(
                      color: context.colorTheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: '/${plan.duration} ${plan.durationUnit}',
                    style: context.textTheme.labelMedium!.copyWith(
                      color: context.colorTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            PlanPoint(
                title:
                    '${LocaleKeys.total_product.tr()} : ${plan.totalProduct}'),
            PlanPoint(
              title:
                  '${LocaleKeys.duration.tr()} : ${plan.duration} ${plan.durationUnit}',
            ),
            SubmitButton(
              style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)))),
              height: 35,
              onPressed: disableTap
                  ? null
                  : (l) async {
                      final action = firstTime ? 3 : (isRenewable ? 1 : 2);
                      final actionText = firstTime
                          ? 'Subscribe to'
                          : (isRenewable ? 'renew this' : 'upgrade this');

                      await showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          displayMessage:
                              '${LocaleKeys.are_you_want_to.tr()} $actionText ${LocaleKeys.plan.tr()} ?',
                          onConfirm: () async => await planCtrl()
                              .planAction(uid ?? '', plan.id, action),
                        ),
                      );
                      afterSubmit?.call();
                      // if (context.mounted) context.nPop();
                    },
              child: firstTime
                  ? Text(LocaleKeys.subscribe.tr())
                  : (isRenewable
                      ? Text(LocaleKeys.renew.tr())
                      : Text(LocaleKeys.upgrade.tr())),
            )
          ],
        ),
      ),
    );
  }
}
