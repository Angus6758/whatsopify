import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton(
      {required this.title,
      required this.icon,
      required this.onTap,
      this.color,
      super.key});
  final String title;
  final IconData icon;
  final Function() onTap;
  final Color? color;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color ?? context.colorTheme.shadow,
          borderRadius: Corners.medBorder,
        ),
        child: Padding(
          padding: Insets.padH,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: context.textTheme.bodyLarge,
              ),
              Icon(icon)
            ],
          ),
        ),
      ),
    );
  }
}
