
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

class SelectableCard extends StatelessWidget {
  const SelectableCard({
    super.key,
    this.onTap,
    required this.isSelected,
    this.header,
    required this.title,
    this.subTitle,
  });

  final Function()? onTap;
  final bool isSelected;
  final Widget? header;
  final Widget? title;
  final Widget? subTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        borderRadius: defaultRadius,
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              height: 150,
              width: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: defaultRadius,
                color: context.colors.secondaryContainer.withOpacity(0.05),
                border: isSelected
                    ? Border.all(
                        color: context.colors.secondaryContainer,
                        width: 1,
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (header != null) header!,
                    const SizedBox(height: 10),
                    if (title != null) title!,
                    const SizedBox(height: 5),
                    if (subTitle != null) subTitle!,
                  ],
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  radius: 12,
                  child: Icon(
                    Icons.done,
                    size: 15,
                    color: context.colors.onError,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
