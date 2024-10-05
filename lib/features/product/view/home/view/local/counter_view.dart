
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/settings/ui_section_model.dart';

import '../../../../../../_widgets/time_countdown.dart';

class FlashTimeCounter extends ConsumerWidget {
  const FlashTimeCounter({
    required this.duration,
    required this.onlyTimer,
    this.section,
    super.key,
  });

  final Duration duration;
  final bool onlyTimer;
  final UiSectionModel? section;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (onlyTimer) return _timer(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: context.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section?.heading ?? '',
                    style: context.textTheme.titleLarge,
                  ),
                  Text(
                    section?.subHeading ?? '',
                    style: context.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _timer(context),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  TimerCountdown _timer(BuildContext context) {
    return TimerCountdown(
      color: context.colors.surface,
      duration: duration,
    );
  }
}
