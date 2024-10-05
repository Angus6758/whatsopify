import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../seller_info/controller/seller_info_ctrl.dart';

class TicketListCard extends ConsumerWidget {
  const TicketListCard({
    super.key,
    required this.ticket,
  });
  final SupportTicket ticket;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellerData = ref.watch(sellerCtrlProvider);
    return Padding(
      padding: Insets.padH,
      child: Column(
        children: [
          const Gap(Insets.med),
          GestureDetector(
            onTap: () => RouteNames.ticket
                .goNamed(context, pathParams: {'id': ticket.ticketNumber}),
            child: ShadowContainer(
              child: Padding(
                padding: Insets.padAll,
                child: Column(
                  children: [
                    Row(
                      children: [
                        sellerData.when(
                          loading: Loader.new,
                          error: ErrorView.new,
                          data: (seller) => ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: HostedImage(
                              seller.image,
                              height: 50,
                              width: 50,
                            ),
                          ),
                        ),
                        const Gap(Insets.lg),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: context.width / 1.5,
                              child: Text(
                                ticket.subject,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textTheme.bodyLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            sellerData.maybeWhen(
                              orElse: () => const SizedBox(),
                              data: (data) => Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '#${ticket.ticketNumber}',
                                      style: context.textTheme.bodyLarge!
                                          .copyWith(
                                              color:
                                                  context.colorTheme.primary),
                                    ),
                                    TextSpan(
                                      text: ' by ${data.name}',
                                      style: context.textTheme.bodyMedium!
                                          .copyWith(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Gap(Insets.sm),
                            Text(
                              ticket.createdAt,
                              style: context.textTheme.labelMedium,
                            )
                          ],
                        )
                      ],
                    ),
                    const Gap(Insets.med),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: Corners.smBorder,
                            color: ticket.status.color.withOpacity(.1),
                            border: Border.all(
                              width: 0,
                              color: ticket.status.color,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              ticket.status.title,
                              style: context.textTheme.labelMedium!.copyWith(
                                color: ticket.status.color,
                              ),
                            ),
                          ),
                        ),
                        const Gap(Insets.med),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: Corners.smBorder,
                            color: ticket.priority.color.withOpacity(.1),
                            border: Border.all(
                              width: 0,
                              color: ticket.priority.color,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: Text(
                              ticket.priority.title,
                              style: context.textTheme.labelMedium!.copyWith(
                                color: ticket.priority.color,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
