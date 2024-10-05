import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seller_management/main.export.dart';

import 'nav_destination.dart';

class NavButton extends HookWidget {
  const NavButton({
    super.key,
    required this.destination,
    required this.index,
    required this.onPressed,
    required this.selectedIndex,
    required this.count,
  });

  final KNavDestination destination;
  final int index;
  final int selectedIndex;
  final void Function()? onPressed;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 56,
              alignment: Alignment.center,
              height: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  destination.isHighlight == true
                      ? CircleAvatar(
                          backgroundColor: destination.isHighlight == true
                              ? context.colorTheme.primary
                              : Colors.transparent,
                          radius: 25,
                          child: SvgPicture.asset(
                            height: destination.isHighlight == true ? 30 : 34,
                            destination.icon,
                            colorFilter: ColorFilter.mode(
                              destination.isHighlight == true
                                  ? context.colorTheme.onPrimary
                                  : context.colorTheme.shadow,
                              BlendMode.srcIn,
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            SvgPicture.asset(
                              height: 29,
                              destination.icon,
                              colorFilter: ColorFilter.mode(
                                selectedIndex == index
                                    ? context.colorTheme.primary
                                    : context.colorTheme.shadow,
                                BlendMode.srcIn,
                              ),
                            ),
                            const Gap(Insets.sm),
                            if (selectedIndex == index)
                              Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: context.colorTheme.primary,
                                ),
                              ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
