import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class SubmitButton extends HookWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.height,
    this.width,
    this.padding,
    this.style,
    this.dense = false,
  });
  const SubmitButton.dense({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.height,
    this.width,
    this.padding,
    this.style,
  }) : dense = true;

  final Function(ValueNotifier<bool> isLoading)? onPressed;

  final Widget child;
  final Widget? icon;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;
  final bool dense;

  FilledButton _button(
    BuildContext context,
    ButtonStyle style,
    ValueNotifier<bool> isLoading,
  ) =>
      icon != null
          ? FilledButton.icon(
              style: style,
              onPressed:
                  onPressed == null ? null : () => onPressed?.call(isLoading),
              label: child,
              icon: isLoading.value ? _loading(context) : icon!,
            )
          : FilledButton(
              style: style,
              onPressed:
                  onPressed == null ? null : () => onPressed?.call(isLoading),
              child: isLoading.value ? _loading(context) : child,
            );

  Widget _loading(BuildContext context) => SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: context.colorTheme.onPrimary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    ButtonStyle buttonStyle = FilledButton.styleFrom();

    if (style != null) {
      buttonStyle = style!.copyWith();
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: height ?? (dense ? 40 : 50),
        width: width ?? (dense ? null : double.infinity),
        child: _button(context, buttonStyle, isLoading),
      ),
    );
  }
}
