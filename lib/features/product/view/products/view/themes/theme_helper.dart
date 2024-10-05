
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';

WidgetStateProperty<T> materialStateProp<T>({
  required T def,
  required T hovered,
  T? disabled,
}) {
  return WidgetStateProperty.resolveWith<T>(
    (states) {
      if (states.isHovered) return hovered;
      if (states.isFocused) return hovered;
      if (disabled != null && states.isDisabled) return disabled;

      return def;
    },
  );
}
