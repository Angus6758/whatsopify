import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class SectorButton extends StatelessWidget {
  const SectorButton({
    super.key,
    required this.title,
    required this.onEditSheetWidget,
    required this.isComplete,
  });

  final String title;
  final Widget onEditSheetWidget;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        ...[
          ActionIconButton(
            onTap: () {
              showModalBottomSheet<void>(
                showDragHandle: true,
                context: context,
                isScrollControlled: true,
                builder: (context) => onEditSheetWidget,
              );
            },
            icon: Icons.edit,
            iconColor: context.colorTheme.tertiary,
            bgColor: context.colorTheme.tertiary.withOpacity(.2),
          ),
          const Gap(Insets.sm),
          if (isComplete)
            ActionIconButton(
              onTap: () {},
              icon: Icons.done,
              iconColor: context.colorTheme.errorContainer,
              bgColor: context.colorTheme.errorContainer.withOpacity(.2),
            ),
        ]
      ],
    );
  }
}
