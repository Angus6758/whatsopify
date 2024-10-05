import 'package:seller_management/features/region/repository/region_repo.dart';
import 'package:seller_management/main.export.dart';

class Brand {
  Brand({
    required this.id,
    required this.names,
  });

  factory Brand.fromMap(Map<String, dynamic> map) {
    return Brand(
      id: map['id'],
      names: Map<String, String?>.from(map['name']),
    );
  }
  static List<Brand> mapToList(String key, Map<String, dynamic> map) {
    final data = map[key]?['data'];
    if (data == null) return [];
    return List<Brand>.from(data.map((e) => Brand.fromMap(e)));
  }

  final int id;
  final Map<String, String?> names;

  String get name {
    final local = locate<RegionRepo>().getLanguage();

    return names[local] ?? names.firstNoneNull() ?? 'N/A';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': names,
    };
  }
}
