import 'package:collection/collection.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';


extension type JEnum(Map<String, int> enumData) {
  String operator [](int code) {
    return enumData.entries.firstWhereOrNull((e) => e.value == code)?.key ??
        'Unknown';
  }

  factory JEnum.fromMap(Map<String, dynamic> map) {
    final data = map..forEach((key, value) => map[key] = map.parseInt(key));

    return JEnum(Map<String, int>.from(data));
  }
}
