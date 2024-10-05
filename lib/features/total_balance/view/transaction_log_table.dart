import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/total_balance/controller/total_balance_ctrl.dart';
import 'package:seller_management/main.export.dart';

class TransactionLogTable extends HookConsumerWidget {
  const TransactionLogTable({
    super.key,
    required this.transactions,
    this.pagination,
  });

  final List<TransactionData> transactions;
  final PaginationInfo? pagination;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionCtrl =
        useCallback(() => ref.read(transactionCtrlProvider.notifier));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.all_transaction_log.tr(),
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(Insets.def),
        Container(
          decoration: BoxDecoration(
            color: context.colorTheme.primary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            child: Row(
              children: [
                Expanded(
                  flex: context.onMobile ? 3 : 4,
                  child: Center(
                    child: Text(
                      LocaleKeys.date.tr(),
                      style: context.onTab
                          ? context.textTheme.bodyLarge!
                              .copyWith(color: context.colorTheme.surfaceTint)
                          : context.textTheme.labelMedium!.copyWith(
                              color: context.colorTheme.surfaceTint,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      LocaleKeys.transId.tr(),
                      style: context.onTab
                          ? context.textTheme.bodyLarge!
                              .copyWith(color: context.colorTheme.surfaceTint)
                          : context.textTheme.labelMedium!.copyWith(
                              color: context.colorTheme.surfaceTint,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      LocaleKeys.amount.tr(),
                      style: context.onTab
                          ? context.textTheme.bodyLarge!
                              .copyWith(color: context.colorTheme.surfaceTint)
                          : context.textTheme.labelMedium!.copyWith(
                              color: context.colorTheme.surfaceTint,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(Insets.sm),
        Container(
          decoration: BoxDecoration(
            color: context.colorTheme.primary.withOpacity(.025),
            borderRadius: Corners.medBorder,
          ),
          child: ListViewWithFooter(
            pagination: pagination,
            onNext: (url) => transactionCtrl().listByUrl(url),
            onPrevious: (url) => transactionCtrl().listByUrl(url),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: transactions.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                children: [
                  ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transactions[index].readableTime,
                                style: context.onTab
                                    ? context.textTheme.bodyLarge
                                    : context.textTheme.labelMedium,
                              ),
                              Text(
                                transactions[index].date,
                                style: context.onTab
                                    ? context.textTheme.bodyLarge
                                    : context.textTheme.labelMedium,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: SelectableText(
                              transactions[index].trxId,
                              style: context.onTab
                                  ? context.textTheme.bodyLarge
                                  : context.textTheme.labelMedium,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              transactions[index].formattedAmount,
                              style: context.onTab
                                  ? context.textTheme.bodyLarge!.copyWith(
                                      color: transactions[index].amountColor,
                                    )
                                  : context.textTheme.labelMedium!.copyWith(
                                      color: transactions[index].amountColor,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: context.colorTheme.primary,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  LocaleKeys.post_balance.tr(),
                                  style: context.onTab
                                      ? context.textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )
                                      : context.textTheme.labelMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                ),
                                const Gap(Insets.sm),
                                Text(
                                  transactions[index].postBalance.formate(),
                                  style: context.onTab
                                      ? context.textTheme.bodyLarge!.copyWith(
                                          color:
                                              context.colorTheme.errorContainer,
                                        )
                                      : context.textTheme.labelMedium!.copyWith(
                                          color:
                                              context.colorTheme.errorContainer,
                                        ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.details.tr(),
                                  style: context.onTab
                                      ? context.textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )
                                      : context.textTheme.labelMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                ),
                                const Gap(Insets.sm),
                                SizedBox(
                                  width: context.width / 1.3,
                                  child: Text(
                                    transactions[index].details,
                                    style: context.onTab
                                        ? context.textTheme.bodyLarge
                                        : context.textTheme.labelMedium,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
