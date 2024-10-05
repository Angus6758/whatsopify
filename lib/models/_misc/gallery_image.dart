import 'package:seller_management/main.export.dart';

class GalleryImage {
  GalleryImage({required this.id, required this.url});

  factory GalleryImage.fromMap(Map<String, dynamic> map) {
    return GalleryImage(
     id: map.parseInt('id'),
      url: map['image'] ?? '',
    );
  }

  static List<GalleryImage> mapToList(Map<String, dynamic> map) {
    return List<GalleryImage>.from(
        map['gallery_image']?.map((e) => GalleryImage.fromMap(e)) ?? []);
  }

  final int id;
  final String url;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
    };
  }
}
