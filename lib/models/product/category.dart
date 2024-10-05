import 'package:seller_management/features/region/repository/region_repo.dart';
import 'package:seller_management/main.export.dart';

class Category {
  Category({
    required this.id,
    required this.names,
    required this.subCategory,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      names: Map<String, String?>.from(map['name']),
      subCategory: mapToList('subcategories', map),
    );
  }

  static List<Category> mapToList(String key, Map<String, dynamic> map) {
    final data = map[key]?['data'];
    if (data == null) return [];
    return List<Category>.from(data.map((e) => Category.fromMap(e)));
  }

  static Category empty = Category(id: 0, names: {}, subCategory: []);

  final int id;
  final Map<String, String?> names;
  final List<Category> subCategory;

  String get name {
    final local = locate<RegionRepo>().getLanguage();

    return names[local] ?? names.firstNoneNull() ?? 'N/A';
  }

  Map<String, dynamic> toMap() {
    final data = {
      'id': id,
      'name': names,
      'subcategories': {
        'data': subCategory.isEmpty
            ? []
            : subCategory.map((e) => e.toMap()).toList()
      },
    };
    return data;
  }
}
