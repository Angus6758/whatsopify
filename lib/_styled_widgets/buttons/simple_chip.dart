import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class SimpleChip extends StatelessWidget {
  const SimpleChip({
    super.key,
    required this.label,
    this.onDeleteTap,
    this.color,
  });

  final String label;
  final void Function()? onDeleteTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final defColor = color ?? context.colorTheme.primary;
    return DecoratedContainer(
      color: defColor.withOpacity(.1),
      borderRadius: Corners.sm,
      borderWidth: .5,
      borderColor: defColor,
      clipChild: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(label),
          ),
          const Gap(8),
          InkWell(
            onTap: onDeleteTap,
            child: DecoratedContainer(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 8,
              ),
              color: context.colorTheme.error.withOpacity(.2),
              child: Icon(
                Icons.close,
                size: 18,
                color: context.colorTheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
