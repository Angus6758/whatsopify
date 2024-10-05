import 'package:flutter/material.dart';

extension TextEx on Text {
  Widget removeIfEmpty() {
    if (data != null && data!.isNotEmpty) return this;
    return const SizedBox.shrink();
  }

  Widget flexible([flex = 1]) => Flexible(flex: flex, child: this);
}
