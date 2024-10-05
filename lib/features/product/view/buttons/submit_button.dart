
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.icon,
    this.height,
    this.width,
    this.padding,
    this.style,
  });

  final Function()? onPressed;

  final Widget child;
  final Widget? icon;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final ButtonStyle? style;
  final bool isLoading;

  FilledButton _button(BuildContext context, ButtonStyle style) => icon != null
      ? FilledButton.icon(
          style: style,
          onPressed: onPressed == null ? null : () => onPressed?.call(),
          label: child,
          icon: isLoading ? _loading(context) : icon!,
        )
      : FilledButton(
          style: style,
          onPressed: onPressed == null ? null : () => onPressed?.call(),
          child: isLoading ? _loading(context) : child,
        );

  Widget _loading(BuildContext context) => SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: context.colors.onPrimary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = FilledButton.styleFrom(
      fixedSize: Size(width ?? context.width, height ?? 40),
    );

    if (style != null) {
      buttonStyle = style!.copyWith(
        fixedSize: WidgetStatePropertyAll(
          Size(width ?? context.width, height ?? 40),
        ),
      );
    }
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: _button(context, buttonStyle),
    );
  }
}

class SubmitLoadButton extends HookWidget {
  const SubmitLoadButton({
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
  const SubmitLoadButton.dense({
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
              icon: isLoading.value
                  ? _loading(style.foregroundColor!.resolve({}))
                  : icon!,
            )
          : FilledButton(
              style: style,
              onPressed:
                  onPressed == null ? null : () => onPressed?.call(isLoading),
              child: isLoading.value
                  ? _loading(style.foregroundColor!.resolve({}))
                  : child,
            );

  Widget _loading(Color? color) => SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: color,
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
        height: 40,
        width: width ?? (dense ? null : double.infinity),
        child: _button(context, buttonStyle, isLoading),
      ),
    );
  }
}
