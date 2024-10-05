import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class WithdrawMethodCard extends StatelessWidget {
  const WithdrawMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onSelected,
  });

  final bool isSelected;
  final WithdrawMethod method;
  final Function(WithdrawMethod method) onSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelected(method),
      child: Stack(
        children: [
          DecoratedContainer(
            padding: Insets.padAll,
            borderColor: isSelected
                ? context.colorTheme.primary
                : context.colorTheme.outline,
            borderWidth: isSelected ? 1 : .3,
            borderRadius: Corners.med,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HostedImage.square(method.image),
                const Gap(Insets.sm),
                Text(method.name),
                Text(
                  '${method.durationString} - ${method.currency.name}',
                ),
              ],
            ),
          ),
          if (isSelected)
            Positioned(
              right: 5,
              top: 5,
              child: Icon(
                Icons.check_circle_outline_rounded,
                color: context.colorTheme.primary,
              ),
            ),
        ],
      ),
    );
  }
}
