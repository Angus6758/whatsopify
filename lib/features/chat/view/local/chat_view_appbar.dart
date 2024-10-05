import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

import '../../../seller_info/controller/seller_info_ctrl.dart';

class ChatViewAppbar extends HookConsumerWidget {
  const ChatViewAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellerData = ref.watch(sellerCtrlProvider);

    return DecoratedContainer(
      child: Padding(
        padding: Insets.padH,
        child: Column(
          children: [
            Gap(context.mq.viewPadding.top),
            sellerData.maybeWhen(
              orElse: () => const Row(),
              data: (self) => Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: HostedImage.provider(self.image),
                  ),
                  const Gap(Insets.med),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        self.username,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorTheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(Insets.sm),
          ],
        ),
      ),
    );
  }
}
