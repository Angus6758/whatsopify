import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seller_management/main.export.dart';

class StatusNoteCard extends StatelessWidget {
  const StatusNoteCard({
    super.key,
    required this.orderStatus,
  });

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: ShadowContainer(
              child: Padding(
                padding: Insets.padAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: Corners.smBorder,
                          color: orderStatus.paymentStatus == 'Unpaid'
                              ? context.colorTheme.error.withOpacity(.1)
                              : context.colorTheme.errorContainer
                                  .withOpacity(.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 2,
                          ),
                          child: Text(
                            orderStatus.paymentStatus.ifEmpty('N/A'),
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: orderStatus.paymentStatus == 'Unpaid'
                                  ? context.colorTheme.error
                                  : context.colorTheme.errorContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(Insets.med),
                    Text(
                      'Payment Note: ${orderStatus.paymentNote.ifEmpty('N/A')}',
                      style: context.textTheme.bodyMedium,
                    ),
                    const Gap(Insets.sm),
                    Text(
                      orderStatus.createdAt,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorTheme.onSurface.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(Insets.med),
          Expanded(
            flex: 5,
            child: ShadowContainer(
              child: Padding(
                padding: Insets.padAll,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: Corners.smBorder,
                            color: context.colorTheme.primary),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5.0,
                            vertical: 2,
                          ),
                          child: Text(
                            orderStatus.deliveryStatus.ifEmpty('N/A'),
                            style: context.textTheme.bodyMedium!.copyWith(
                              color: context.colorTheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(Insets.med),
                    Text(
                      'Delivery Note: ${orderStatus.deliveryNote.ifEmpty('N/A')}',
                      style: context.textTheme.bodyMedium,
                    ),
                    const Gap(Insets.sm),
                    Text(
                      orderStatus.createdAt,
                      style: context.textTheme.bodyMedium!.copyWith(
                        color: context.colorTheme.onSurface.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
