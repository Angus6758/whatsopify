import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class CircleImage extends StatelessWidget {
  const CircleImage(
    this.url, {
    super.key,
    this.padding,
    this.borderColor,
    this.radius = 30,
    this.useBorder = false,
  });

  final EdgeInsets? padding;
  final String url;
  final Color? borderColor;
  final double? radius;
  final bool useBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: DecoratedContainer(
        height: (radius ?? 0) * 2,
        width: (radius ?? 0) * 2,
        clipChild: true,
        borderColor: borderColor ?? context.colorTheme.primary,
        borderWidth: useBorder ? 2 : 0,
        borderRadius: 99,
        child: AspectRatio(
          aspectRatio: 1,
          child: HostedImage.square(url),
        ),
      ),
    );
  }
}
