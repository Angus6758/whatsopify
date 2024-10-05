import 'package:flutter/material.dart';
import 'package:seller_management/features/dashboard/view/local/order_status_card.dart';
import 'package:seller_management/main.export.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShadowContainer(
      child: Padding(
        padding: Insets.padAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OrderStatusCard(
                    width: 80,
                    count: '0',
                    status: 'Pending',
                  ),
                  OrderStatusCard(
                    width: 80,
                    count: '0',
                    status: 'Picked',
                  ),
                  OrderStatusCard(
                    width: 80,
                    count: '0',
                    status: 'Shipped',
                  ),
                  OrderStatusCard(
                    width: 80,
                    count: '0',
                    status: 'Delivered',
                  ),
                  OrderStatusCard(
                    width: 80,
                    count: '0',
                    status: 'Cancel',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
