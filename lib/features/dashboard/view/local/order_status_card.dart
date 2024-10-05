import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    super.key,
    required this.count,
    required this.status,
    this.width,
    this.height,
  });

  final String count;
  final String status;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 5),
      child: ShadowContainer(
        width: width,
        height: height,
        shadowColors: context.colorTheme.secondaryContainer.withOpacity(0.1),
        child: Padding(
          padding: Insets.padAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                status,
                style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colorTheme.onSurface.withOpacity(.7)),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
