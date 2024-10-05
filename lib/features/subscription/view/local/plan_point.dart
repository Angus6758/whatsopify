import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class PlanPoint extends StatelessWidget {
  const PlanPoint({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: context.colorTheme.errorContainer.withOpacity(.2),
          radius: 10,
          child: Icon(
            Icons.done,
            size: 15,
            color: context.colorTheme.errorContainer,
          ),
        ),
        const Gap(Insets.lg),
        Text(
          title,
          style: context.textTheme.labelMedium,
        )
      ],
    );
  }
}
