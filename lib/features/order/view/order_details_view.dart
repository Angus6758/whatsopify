import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/settings/controller/settings_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../controller/order_ctrl.dart';
import 'local/product_package_card.dart';
import 'local/status_note_card.dart';

class OrderDetailsView extends HookConsumerWidget {
  const OrderDetailsView(this.id, {super.key});
  final String id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderDetails = ref.watch(orderDetailsCtrlNotifier(id));
    final orderCtrl =
        useCallback(() => ref.read(orderDetailsCtrlNotifier(id).notifier));

    final selectedValue = useState<int?>(null);
    final statusList =
        ref.watch(localSettingsProvider.select((v) => v?.config.validStatus));

    final noteCtrl = useTextEditingController();

    return orderDetails.when(
      loading: () => Loader.fullScreen(true),
      error: (e, s) => Scaffold(body: ErrorView(e, s)),
      data: (order) => Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.order_details.tr()),
          actions: [
            if (order.isPhysical)
              IconButton(
                onPressed: () {
                  orderCtrl().downloadInvoice();
                },
                icon: const Icon(Icons.print),
              ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(orderDetailsCtrlNotifier);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: Insets.padH,
              child: Column(
                children: [
                  const Gap(Insets.med),
                  if (order.billing != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: Corners.smBorder,
                        border: Border.all(
                          width: 0,
                          color: context.colorTheme.primary,
                        ),
                      ),
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: Insets.padAll,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocaleKeys.ship_and_bill_to.tr(),
                            style: context.textTheme.bodyLarge!.copyWith(
                              color:
                                  context.colorTheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                          ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${LocaleKeys.order.tr()}: ${order.orderId}',
                                  style: context.textTheme.bodyLarge!.copyWith(
                                    color: context.colorTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(
                                      ClipboardData(text: order.orderId),
                                    );
                                    Toaster.showInfo(
                                        LocaleKeys.order_id_copied.tr());
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    color: context.colorTheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            if (!order.billing!.isNamesEmpty)
                              Text(
                                'Name: ${order.billing!.fullName}',
                                style: context.textTheme.titleMedium,
                              ),
                            if (order.billing?.phone != null)
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${LocaleKeys.phone.tr()}: ${order.billing!.phone}',
                                        style: context.textTheme.titleMedium,
                                      ),
                                      const Gap(Insets.med),
                                      GestureDetector(
                                        onTap: () => URLHelper.call(
                                            order.billing!.phone!),
                                        child: CircleAvatar(
                                          backgroundColor: context
                                              .colorTheme.primary
                                              .withOpacity(.1),
                                          radius: 13,
                                          child: Icon(
                                            size: 18,
                                            Icons.arrow_outward_rounded,
                                            color: context.colorTheme.primary,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            if (order.billing!.email.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    '${LocaleKeys.email.tr()}: ${order.billing!.email}',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Gap(Insets.sm),
                                  GestureDetector(
                                    onTap: () =>
                                        URLHelper.mail(order.billing!.email),
                                    child: CircleAvatar(
                                      backgroundColor: context
                                          .colorTheme.primary
                                          .withOpacity(.1),
                                      radius: 13,
                                      child: Icon(
                                        Icons.arrow_outward_rounded,
                                        size: 18,
                                        color: context.colorTheme.primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            if (order.billing!.address.isNotEmpty)
                              Text(
                                '${LocaleKeys.street_name.tr()} : ${order.billing!.address}',
                                style: context.textTheme.titleMedium,
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${LocaleKeys.order_placement.tr()}: ',
                                  style:
                                      context.textTheme.titleMedium!.copyWith(
                                    color: context.colorTheme.onSurface
                                        .withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  order.date,
                                  style:
                                      context.textTheme.titleMedium!.copyWith(
                                    color: context.colorTheme.onSurface
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),

                  const Gap(Insets.med),
                  if (order.customer != null)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: Corners.smBorder,
                        border: Border.all(
                          width: 0,
                          color: context.colorTheme.primary,
                        ),
                      ),
                      child: Padding(
                        padding: Insets.padAll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.customer_info.tr(),
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colorTheme.onSurface
                                    .withOpacity(0.8),
                              ),
                            ),
                            if (order.customer!.name.isNotEmpty)
                              Text(
                                '${LocaleKeys.customer_name.tr()}: ${order.customer!.name}',
                                style: context.textTheme.titleMedium,
                              ),
                            if (order.customer!.phone != null)
                              Row(
                                children: [
                                  Text(
                                    '${LocaleKeys.phone.tr()}: ${order.customer!.phone}',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Gap(Insets.med),
                                  GestureDetector(
                                    onTap: () =>
                                        URLHelper.call(order.customer!.phone!),
                                    child: CircleAvatar(
                                      backgroundColor: context
                                          .colorTheme.primary
                                          .withOpacity(.1),
                                      radius: 13,
                                      child: Icon(
                                        size: 18,
                                        Icons.arrow_outward_rounded,
                                        color: context.colorTheme.primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            if (order.customer!.email.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    '${LocaleKeys.email.tr()}: ${order.customer!.email}',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Gap(Insets.sm),
                                  GestureDetector(
                                    onTap: () =>
                                        URLHelper.mail(order.customer!.email),
                                    child: CircleAvatar(
                                      backgroundColor: context
                                          .colorTheme.primary
                                          .withOpacity(.1),
                                      radius: 13,
                                      child: Icon(
                                        Icons.arrow_outward_rounded,
                                        size: 18,
                                        color: context.colorTheme.primary,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),

                  const Gap(Insets.def),
                  //! Product Package Section ---------------------------------------------

                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: order.details.length,
                    itemBuilder: (context, index) => ProductPackageCard(
                      product: order.details[index],
                      orderInfo: order,
                    ),
                  ),

                  const Gap(Insets.sm),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: Corners.smBorder,
                      border: Border.all(
                        width: 0,
                        color: context.colorTheme.primary,
                      ),
                    ),
                    padding: Insets.padAll,
                    child: Column(
                      children: [
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: LocaleKeys.payment_method.tr(),
                          right: order.paymentVia,
                        ),
                        const Gap(Insets.med),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          styleBuilder: (left, right) => (
                            left,
                            right?.copyWith(
                              color: order.paymentStatus == 'Unpaid'
                                  ? context.colorTheme.error
                                  : context.colorTheme.errorContainer,
                            ),
                          ),
                          left: LocaleKeys.payment_status.tr(),
                          right: order.paymentStatus,
                        ),
                        const Divider(height: 10),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: LocaleKeys.sub_total.tr(),
                          right: order.orderAmount.formate(),
                        ),
                        const Gap(Insets.med),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: LocaleKeys.shipping_charge.tr(),
                          right: order.shippingCharge.formate(),
                        ),
                        const Gap(Insets.med),
                        SpacedText(
                          style: context.textTheme.titleMedium,
                          left: LocaleKeys.total.tr(),
                          right: order.finalAmount.formate(),
                        ),
                        if (order.isPhysical) ...[
                          const Gap(Insets.med),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.download_invoice.tr(),
                                style: context.textTheme.bodyLarge,
                              ),
                              GestureDetector(
                                onTap: () {
                                  orderCtrl().downloadInvoice();
                                },
                                child: Icon(
                                  Icons.print_outlined,
                                  color: context.colorTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Gap(Insets.med),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    clipBehavior: Clip.none,
                    shrinkWrap: true,
                    itemCount: order.orderStatus.length,
                    itemBuilder: (context, index) {
                      final orderStatus = order.orderStatus[index];
                      return StatusNoteCard(orderStatus: orderStatus);
                    },
                  ),
                  const Gap(Insets.sm),
                  ShadowContainer(
                    padding: Insets.padAll,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.delivery_status.tr(),
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(Insets.med),
                        DropDownField<int>(
                          hintText: LocaleKeys.select_item.tr(),
                          itemCount: statusList?.length,
                          value: selectedValue.value,
                          itemBuilder: (context, index) {
                            final item = statusList![index];
                            return DropdownMenuItem<int>(
                              value: item.value,
                              child: Text(
                                item.key.toTitleCase,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          },
                          onChanged: (value) => selectedValue.value = value,
                        ),
                        const Gap(Insets.med),
                        TextFormField(
                          controller: noteCtrl,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: LocaleKeys.write_short_note.tr(),
                          ),
                        ),
                        const Gap(Insets.med),
                        SubmitButton(
                          onPressed: (l) async {
                            if (selectedValue.value == null) {
                              Toaster.showError(
                                LocaleKeys.please_select_status_first.tr(),
                              );
                              return;
                            }
                            l.value = true;
                            await orderCtrl().orderStatusUpdate(
                              status: selectedValue.value.toString(),
                              note: noteCtrl.text,
                            );

                            l.value = false;
                            selectedValue.value = null;
                            noteCtrl.clear();
                          },
                          child: Text(LocaleKeys.submit.tr()),
                        ),
                      ],
                    ),
                  ),
                  const Gap(Insets.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
