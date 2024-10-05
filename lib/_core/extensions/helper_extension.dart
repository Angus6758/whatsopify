import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seller_management/features/region/repository/region_repo.dart';
import 'package:seller_management/main.export.dart';

extension StringEx on String {
  int get asInt => isEmpty ? 0 : int.tryParse(this) ?? 0;

  double get asDouble => double.tryParse(this) ?? 0.0;

  String showUntil(int end, [int start = 0]) {
    return length >= end ? '${substring(start, end)}...' : this;
  }

  String ifEmpty([String onEmpty = 'EMPTY']) {
    return isEmpty ? onEmpty : this;
  }

  bool get isValidEmail {
    final reg = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return reg.hasMatch(this);
  }

  bool get isValidPhone {
    final reg = RegExp(r"^[\+]?([0-9]{2})?[0-9]{11}$");
    return reg.hasMatch(this);
  }

  String get titleCaseSingle => '${this[0].toUpperCase()}${substring(1)}';
  String get toTitleCase => split(' ').map((e) => e.titleCaseSingle).join(' ');

  Color? toColorK([Color? fallbackColor]) {
    String hexColor = replaceAll("#", "");
    final color = int.tryParse("0xFF$hexColor");
    if (color == null) return fallbackColor;
    return Color(color);
  }
}

extension ConvertInt on num {
  String formate({
    Currency? currency,
    bool useBase = false,
    bool useSymbol = true,
    bool rateCheck = false,
  }) {
    final dbCur = useBase
        ? locate<RegionRepo>().getBaseCurrency()
        : locate<RegionRepo>().getCurrency();

    final cur = currency ?? dbCur;

    var value = this;

    if (cur != null && rateCheck) value = value * cur.rate;
    final sym = (cur?.symbol ?? '')
        .replaceAll(RegExp('[,.]+', caseSensitive: false), '');

    final name = ' ${cur?.name ?? ''}';

    final pattern = useSymbol ? '$sym##,##,##,##,##0' : '##,##,##,##,##0$name';

    return NumberFormat.currency(
      decimalDigits: this is int ? 0 : 2,
      customPattern: pattern,
    ).format(value);
  }

  num formateSelf({
    Currency? currency,
    bool useBase = false,
    bool rateCheck = false,
  }) {
    final dbCur = useBase
        ? locate<RegionRepo>().getBaseCurrency()
        : locate<RegionRepo>().getCurrency();

    final cur = currency ?? dbCur;
    num value = this;

    if (cur != null && rateCheck) value = value * cur.rate;

    return value;
  }
}

extension DateTimeFormat on DateTime {
  String formatDate([String pattern = 'dd-MM-yyyy']) {
    /// final locale = Localizations.localeOf(context);
    return DateFormat(pattern).format(this);
  }

  String welcomeMassage(BuildContext context) {
    final hour = this.hour;
    String massage = '';

    if (hour >= 0 && hour < 6) {
      massage = 'Night';
    } else if (hour >= 6 && hour < 11) {
      massage = 'Morning';
    } else if (hour >= 11 && hour < 16) {
      massage = 'Good After Noon';
    } else if (hour >= 16 && hour < 18) {
      massage = 'Good Evening';
    } else if (hour >= 18 && hour < 24) {
      massage = 'Good Night';
    }

    return massage;
  }
}

/// Extension methods for Map
extension MapEx<K, V> on Map<K, V> {
  V? firstNoneNull() =>
      isEmpty ? null : values.firstWhereOrNull((e) => e != null);

  V? valueOrFirst(String? key, String? defKey, [V? defaultValue]) {
    return this[key] ?? this[defKey] ?? defaultValue;
  }

  Map<K, V> nonNull() {
    return {...this}..removeWhere((key, value) => value == null);
  }

  Map<K, V> removeNullAndEmpty() {
    return {...this}
      ..removeWhere((k, v) => v == null || (v is String && v.isEmpty));
  }

  int parseInt(String key, [int fallBack = 0]) {
    final it = this[key];
    if (it == null) return fallBack;
    if (it is num) return it.toInt();
    if (it is String) return int.tryParse(it) ?? fallBack;
    return fallBack;
  }


  double parseDouble(String key, [double fallBack = 0.0]) {
    final it = this[key];
    if (it == null) return fallBack;
    if (it is num) return it.toDouble();
    if (it is String) return double.tryParse(it) ?? fallBack;
    return fallBack;
  }

  num parseNum(String key, [num fallBack = 0]) {
    final it = this[key];
    if (it == null) return fallBack;
    if (it is num) return it;
    if (it is String) return num.tryParse(it) ?? fallBack;
    return fallBack;
  }

  bool parseBool<T>(String key, [bool onNull = false]) {
    final it = this[key];
    if (it is bool) return it;
    if (it == null) return onNull;
    if (it is String) return bool.tryParse(it) ?? onNull;

    if (it == '1' || it == 1) return true;
    if (it == '0' || it == 0) return false;
    return onNull;
  }

  V? converter(K key, V Function(V value) converter, [V? defaultValue]) {
    final it = this[key];
    if (it == null) return defaultValue;
    if (it is Map && it.isEmpty) return defaultValue;
    if (it is List && it.isEmpty) return defaultValue;
    return converter(it);
  }

  V? notNullOrEmpty(K key) {
    final it = this[key];
    if (it == null) return null;
    if (it is String && it.isEmpty) return null;

    return it;
  }
}

extension IterableEx<T> on Iterable<T> {
  List<T> takeFirst([int listLength = 10]) {
    final itemCount = length;
    final takeCount = itemCount > listLength ? listLength : itemCount;
    return take(takeCount).toList();
  }

  List<String> combineWith(List<String> list) {
    if (T is String) {
      List<String> result = [];

      for (String value1 in this as List<String>) {
        for (String value2 in list) {
          result.add('$value1-$value2');
        }
      }
      return result;
    }
    return [];
  }
}

extension MaterialStateSet on Set<WidgetState> {
  bool get isHovered => contains(WidgetState.hovered);
  bool get isFocused => contains(WidgetState.focused);
  bool get isPressed => contains(WidgetState.pressed);
  bool get isDragged => contains(WidgetState.dragged);
  bool get isSelected => contains(WidgetState.selected);
  bool get isScrolledUnder => contains(WidgetState.scrolledUnder);
  bool get isDisabled => contains(WidgetState.disabled);
  bool get isError => contains(WidgetState.error);
}

extension WidgetEx on Widget {
  Widget conditionalExpanded(bool condition, [int flex = 1]) =>
      condition ? Expanded(flex: flex, child: this) : this;
}

extension AnimationEx on Animation<double> {
  Animation<double> withCurve(Curve curve) =>
      CurvedAnimation(parent: this, curve: curve);
}

extension DateRangeEx on DateTimeRange? {
  String toQuery() {
    if (this == null) return '';
    final start = this?.start.formatDate('yyyy-MM-dd');
    final end = this?.end.formatDate('yyyy-MM-dd');
    return '$start+to+$end';
  }
}

extension ObjEX on Object? {
  bool isNullOrEmpty() {
    if (this == null) return true;
    if (this is String && (this as String).isEmpty) return true;
    if (this is Iterable && (this as Iterable).isEmpty) return true;
    if (this is Map && (this as Map).isEmpty) return true;

    return false;
  }

  bool isNotNullOrEmpty() => !isNullOrEmpty();
}

extension FutureResEx<T> on Future<Response<T>> {
  Future<Response<T>> logData() {
    return doAndReturn(
      (r) {
        Logger.json(r.data, r.requestOptions.uri.path);

        final data = r.requestOptions.data;
        final body = {};

        if (data is FormData) {
          for (var field in data.fields) {
            body.addAll({field.key: field.value});
          }
          Logger.json(body, 'body of ${r.requestOptions.uri.path}');
        }
      },
    );
  }
}

extension FutureEx<T> on Future<T> {
  /// Do some task and return the value of the future
  Future<T> doAndReturn(void Function(T data) task) => then(
        (r) {
          task(r);
          return r;
        },
      );
}
