import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

enum WarningBoxType { warning, info }

class WarningBox extends StatelessWidget {
  const WarningBox(this.message, {super.key, this.type});

  final String message;
  final WarningBoxType? type;

  @override
  Widget build(BuildContext context) {
    final color = switch ((type ?? WarningBoxType.warning)) {
      WarningBoxType.warning => context.colorTheme.error,
      WarningBoxType.info => Colors.blue,
    };
    return DecoratedContainer(
      borderColor: color,
      borderRadius: Corners.med,
      borderWidth: .3,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      alignment: Alignment.center,
      color: color.withOpacity(.1),
      child: Text(
        message,
        style: context.textTheme.titleMedium?.copyWith(color: color),
      ),
    );
  }
}
