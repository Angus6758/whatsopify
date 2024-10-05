import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/total_balance/controller/total_balance_ctrl.dart';
import 'package:seller_management/main.export.dart';

import 'transaction_log_table.dart';

class TotalBalanceView extends HookConsumerWidget {
  const TotalBalanceView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionData = ref.watch(transactionCtrlProvider);
    final transactionCtrl =
        useCallback(() => ref.read(transactionCtrlProvider.notifier));
    final picked = useState<DateTimeRange?>(null);
    final searchCtrl = useTextEditingController();

    Future<DateTimeRange?> dateTimeRangePicker() async {
      final selectedRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(DateTime.now().year + 2),
        builder: (_, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 350, maxHeight: 500),
              child: child!,
            ),
          );
        },
      );

      return selectedRange;
    }

    Future<void> filterList() async {
      await transactionCtrl()
          .filter(dateRange: picked.value, search: searchCtrl.text);
    }

    return Scaffold(
      appBar: KAppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(LocaleKeys.total_balance.tr()),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 20),
          child: Padding(
            padding: Insets.padH,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchCtrl,
                        onChanged: (value) async {
                          await filterList();
                        },
                        decoration: InputDecoration(
                          hintText: LocaleKeys.search_by_trx_id.tr(),
                          fillColor: context.colorTheme.onPrimary,
                        ),
                      ),
                    ),
                    const Gap(Insets.med),
                    Expanded(
                      child: TextField(
                        onTap: () async {
                          final date = await dateTimeRangePicker();
                          picked.value = date;
                          await filterList();
                        },
                        readOnly: true,
                        decoration: InputDecoration(
                          fillColor: context.colorTheme.onPrimary,
                          hintText: picked.value != null
                              ? '${picked.value!.start} - ${picked.value!.end}'
                              : LocaleKeys.search_by_date.tr(),
                        ),
                      ),
                    ),
                    if (searchCtrl.text.isNotEmpty || picked.value != null) ...[
                      const Gap(Insets.sm),
                      IconButton.filled(
                        onPressed: () {
                          searchCtrl.clear();
                          picked.value = null;
                          filterList();
                        },
                        icon: const Icon(Icons.clear_rounded),
                      )
                    ],
                  ],
                ),
                const Gap(Insets.lg),
              ],
            ),
          ),
        ),
      ),
      body: transactionData.when(
        loading: Loader.list,
        error: ErrorView.new,
        data: (data) {
          return RefreshIndicator(
            onRefresh: () async => transactionCtrl().reload(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: Insets.padAll,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TransactionLogTable(
                    transactions: data.listData,
                    pagination: data.pagination,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
