import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderInfo,
  });

  final OrderModel orderInfo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => RouteNames.orderDetails.pushNamed(context, pathParams: {
        'id': orderInfo.orderId,
      }),
      child: Padding(
        padding: Insets.padH,
        child: ShadowContainer(
          child: Padding(
            padding: Insets.padAll,
            child: Row(
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${LocaleKeys.order.tr()}: ${orderInfo.orderId}',
                            style: context.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: context.colorTheme.primary,
                            ),
                          ),
                          const Gap(Insets.sm),
                          GestureDetector(
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(text: orderInfo.orderId),
                              );
                              Toaster.showInfo(LocaleKeys.order_id_copied.tr());
                            },
                            child: Icon(
                              Icons.copy,
                              size: 18,
                              color: context.colorTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Gap(Insets.med),
                      Text(LocaleKeys.customer_info.tr()),
                      Text(
                        '${LocaleKeys.name.tr()}: ${orderInfo.billing?.fullName}',
                      ),
                      Row(
                        children: [
                          Text(
                            '${LocaleKeys.phone.tr()}: ${orderInfo.billing?.phone}',
                          ),
                          const Gap(Insets.sm),
                          if (orderInfo.billing?.phone != null)
                            GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: orderInfo.billing!.phone!,
                                  ),
                                );
                                Toaster.showInfo(
                                    LocaleKeys.phone_number_copied.tr());
                              },
                              child: Icon(
                                Icons.copy,
                                size: 18,
                                color: context.colorTheme.primary,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        '${LocaleKeys.email.tr()}: ${orderInfo.billing?.email}',
                      ),
                      Text(
                        '${LocaleKeys.order_placement.tr()}: ${orderInfo.date}',
                        style: TextStyle(
                          color: context.colorTheme.onSurface.withOpacity(.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        orderInfo.paymentStatus,
                        style: TextStyle(
                          color: orderInfo.paymentStatus == 'Unpaid'
                              ? context.colorTheme.error
                              : context.colorTheme.errorContainer,
                        ),
                      ),
                      if (orderInfo.shipping != null)
                        Text(
                          orderInfo.shipping!.method,
                          textAlign: TextAlign.end,
                        ),
                      Text(
                        orderInfo.deliveryStatus,
                      ),
                      Text(
                        '${LocaleKeys.total.tr()}: ${orderInfo.orderAmount.formate()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
