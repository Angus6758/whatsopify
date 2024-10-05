import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class VDivider extends StatelessWidget {
  const VDivider({
    super.key,
    this.thickness = 1,
    this.width = Insets.lg,
    this.height,
    this.verticalIndent = (start: 0, end: 0),
    this.color,
  });
  final double thickness;
  final double width;
  final double? height;
  final ({double start, double end}) verticalIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: verticalIndent.start,
        bottom: verticalIndent.end,
        left: width / 2,
        right: width / 2,
      ),
      height: height ?? double.infinity,
      width: thickness,
      color: color ?? context.colorTheme.outline,
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({
    super.key,
    this.text = 'or',
    this.thickness = 1,
    this.height = 20,
  });

  final String text;
  final double thickness;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: thickness,
              color: context.colorTheme.outline,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          const Text('or'),
          Expanded(
            child: Container(
              height: thickness,
              color: context.colorTheme.outline,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          )
        ],
      ),
    );
  }
}
