import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

class CustomerChatCard extends HookConsumerWidget {
  const CustomerChatCard({
    super.key,
    required this.customer,
  });
  final Customer customer;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => RouteNames.customerChat
          .pushNamed(context, pathParams: {'id': '${customer.id}'}),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: Corners.smBorder,
          border: Border.all(
            width: 0,
            color: context.colorTheme.primary,
          ),
          color: context.colorTheme.primary.withOpacity(0.01),
        ),
        padding: Insets.padAll,
        child: Stack(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: HostedImage.provider(customer.image),
                ),
                const Gap(Insets.med),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(Insets.med),
                      Text(
                        customer.name,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        customer.lastMessage?.message ?? '',
                        maxLines: 1,
                        style: context.textTheme.bodyLarge,
                      ),
                      const Gap(Insets.med),
                    ],
                  ),
                ),
              ],
            ),
            if (customer.lastMessage != null)
              Positioned(
                bottom: 0,
                right: 0,
                child: Text(
                  customer.lastMessage!.readableTime,
                ),
              ),
            if (!customer.lastMessage!.isMine)
              if (!customer.lastMessage!.isSeen)
                Positioned(
                  right: 0,
                  child: DecoratedContainer(
                    color: context.colorTheme.primary.withOpacity(.1),
                    padding: Insets.padSym(5, 8),
                    borderRadius: Corners.med,
                    child: Text(
                      'NEW',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorTheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
