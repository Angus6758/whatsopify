import 'package:flutter/cupertino.dart';
import 'package:seller_management/main.export.dart';

class TopButton extends StatelessWidget {
  const TopButton(
      {super.key,
      required this.count,
      required this.title,
      required this.color,
      required this.onTap});

  final String count;
  final String title;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
          decoration: BoxDecoration(
            borderRadius: Corners.smBorder,
            border: Border.all(
              width: 0,
              color: color,
            ),
            color: color.withOpacity(.03),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(Insets.sm),
              Text(
                title,
                style: context.textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
