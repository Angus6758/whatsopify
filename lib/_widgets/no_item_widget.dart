import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seller_management/main.export.dart';

class NoItemWidget extends StatelessWidget {
  const NoItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          height: 80,
          AssetsConst.noItem,
        ),
        const Gap(Insets.med),
        Text(
          'No Item Found',
          style: context.textTheme.titleLarge,
        ),
        const Gap(Insets.lg),
      ],
    );
  }
}
