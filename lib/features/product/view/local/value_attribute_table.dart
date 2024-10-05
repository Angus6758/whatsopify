import 'package:flutter/material.dart';

class ValueAttributeTable extends StatelessWidget {
  const ValueAttributeTable({
    super.key,
    required this.value,
    required this.status,
    required this.action,
  });
  final String value;
  final String status;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(child: Text(value)),
        ),
        Expanded(
          child: Center(child: Text(status)),
        ),
        Expanded(
          child: Center(child: action),
        ),
      ],
    );
  }
}
