
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.onTrailingTap,
    this.trailing,
  });

  final String title;
  final String? trailing;
  final Function()? onTrailingTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge,
        ),
        TextButton(
          onPressed: onTrailingTap,
          child: Text(
            trailing ?? TR.all(context),
            style: TextStyle(
              decorationColor: context.colors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
