import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class ShadowContainer extends ConsumerWidget {
  const ShadowContainer({
    required this.child,
    this.blurRadius,
    this.color,
    this.shadowColors,
    this.height,
    this.width,
    this.offset,
    this.padding,
    this.margin,
    super.key,
  });
  final double? blurRadius;
  final Color? color;
  final Color? shadowColors;
  final Offset? offset;
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? context.colorTheme.onPrimary,
        borderRadius: Corners.smBorder,
        boxShadow: [
          BoxShadow(
            blurRadius: blurRadius ?? 5,
            color: shadowColors ??
                context.colorTheme.secondaryContainer.withOpacity(0.1),
            offset: offset ?? const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
