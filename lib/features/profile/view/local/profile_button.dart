import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.title,
    required this.onTap,
  });
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.onMobile
                ? context.textTheme.bodyLarge
                : context.textTheme.titleLarge,
          ),
          const Icon(Icons.keyboard_arrow_right_rounded)
        ],
      ),
    );
  }
}
