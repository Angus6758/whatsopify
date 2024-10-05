import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';
import '../../controller/withdraw_ctrl.dart';

class AllWithdrawTable extends StatelessWidget {
  const AllWithdrawTable({
    super.key,
    required this.searchCtrl,
    required this.withdrawCtrl,
    required this.withdrawList,
  });

  final TextEditingController searchCtrl;
  final WithdrawListCtrlNotifier Function() withdrawCtrl;
  final AsyncValue<PagedItem<WithdrawData>> withdrawList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: Insets.padH,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              LocaleKeys.all_withdraw.tr(),
              style: context.textTheme.titleLarge,
            ),
          ),
        ),
        const Gap(Insets.lg),
        Padding(
          padding: Insets.padH,
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  searchCtrl.clear();
                  withdrawCtrl().reload();
                },
                icon: const Icon(Icons.clear),
              ),
              hintText: LocaleKeys.search_by_trx_id.tr(),
              border: const OutlineInputBorder(),
            ),
            onChanged: (value) => withdrawCtrl().search(value),
          ),
        ),
        const Gap(Insets.sm),
        Padding(
          padding: Insets.padH,
          child: Container(
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
                    flex: 3,
                    child: Center(
                      child: Text(
                        LocaleKeys.date.tr(),
                        style: context.onTab
                            ? context.textTheme.bodyLarge!
                                .copyWith(color: context.colorTheme.onPrimary)
                            : context.textTheme.labelMedium!.copyWith(
                                color: context.colorTheme.onPrimary,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        LocaleKeys.transId.tr(),
                        style: context.onTab
                            ? context.textTheme.bodyLarge!
                                .copyWith(color: context.colorTheme.onPrimary)
                            : context.textTheme.labelMedium!.copyWith(
                                color: context.colorTheme.onPrimary,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      LocaleKeys.receivable.tr(),
                      style: context.onTab
                          ? context.textTheme.bodyLarge!
                              .copyWith(color: context.colorTheme.onPrimary)
                          : context.textTheme.labelMedium!.copyWith(
                              color: context.colorTheme.onPrimary,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Gap(Insets.sm),
        withdrawList.when(
          loading: Loader.list,
          error: ErrorView.new,
          data: (data) => ListViewWithFooter(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            pagination: data.pagination,
            onNext: (url) => withdrawCtrl().listByUrl(url),
            onPrevious: (url) => withdrawCtrl().listByUrl(url),
            itemCount: data.length,
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
                                data[index].readableTime,
                                style: context.onTab
                                    ? context.textTheme.bodyLarge
                                    : context.textTheme.labelMedium,
                              ),
                              Text(
                                data[index].date,
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
                              data[index].trxNo,
                              style: context.onTab
                                  ? context.textTheme.bodyLarge
                                  : context.textTheme.labelMedium,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Text(
                              data[index]
                                  .finalAmount
                                  .formate(currency: data[index].currency),
                              style: context.onTab
                                  ? context.textTheme.bodyLarge
                                  : context.textTheme.labelMedium,
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
                                  '${LocaleKeys.method.tr()}:',
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
                                  data[index].method.name,
                                  style: context.onTab
                                      ? context.textTheme.bodyLarge
                                      : context.textTheme.labelMedium,
                                )
                              ],
                            ),
                            const Gap(Insets.sm),
                            Row(
                              children: [
                                Text(
                                  '${LocaleKeys.amount.tr()}:',
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
                                  data[index].amount.formate(useBase: true),
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
                            const Gap(Insets.sm),
                            Row(
                              children: [
                                Text(
                                  '${LocaleKeys.charge.tr()}:',
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
                                  data[index].charge.formate(useBase: true),
                                  style: context.onTab
                                      ? context.textTheme.bodyLarge!.copyWith(
                                          color: context.colorTheme.error,
                                        )
                                      : context.textTheme.labelMedium!.copyWith(
                                          color: context.colorTheme.error,
                                        ),
                                )
                              ],
                            ),
                            const Gap(Insets.sm),
                            Row(
                              children: [
                                Text(
                                  '${LocaleKeys.status.tr()}:',
                                  style: context.onTab
                                      ? context.textTheme.bodyLarge!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        )
                                      : context.textTheme.labelMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                ),
                                const Gap(Insets.sm),
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        data[index].statusColor.withOpacity(.1),
                                    borderRadius: Corners.smBorder,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5),
                                    child: Text(
                                      data[index].status,
                                      style: context.onTab
                                          ? context.textTheme.bodyLarge!
                                              .copyWith(
                                              color: data[index].statusColor,
                                            )
                                          : context.textTheme.labelMedium!
                                              .copyWith(
                                              color: data[index].statusColor,
                                            ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Gap(Insets.sm),
                            if (data[index].feedback.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    '${LocaleKeys.note.tr()}:',
                                    style: context.onTab
                                        ? context.textTheme.bodyLarge!.copyWith(
                                            fontWeight: FontWeight.bold,
                                          )
                                        : context.textTheme.labelMedium!
                                            .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                  ),
                                  const Gap(Insets.sm),
                                  Text(
                                    data[index].feedback,
                                    style: context.onTab
                                        ? context.textTheme.bodyLarge!.copyWith(
                                            color: context.colorTheme.error,
                                          )
                                        : context.textTheme.labelMedium!
                                            .copyWith(
                                            color: context.colorTheme.error,
                                          ),
                                  )
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
