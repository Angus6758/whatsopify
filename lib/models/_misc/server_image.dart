import 'package:flutter/material.dart';

class ServerImage {
  const ServerImage({required this.url, required this.sizeGuide});

  factory ServerImage.fromMap(Map<String, dynamic> map) {
    return ServerImage(
      url: map['url'] ?? '',
      sizeGuide: map['size_guide'] ?? '',
    );
  }

  final String sizeGuide;
  final String url;

  Size get size {
    final h = double.tryParse(sizeGuide.split('x')[0]) ?? 0;
    final w = double.tryParse(sizeGuide.split('x')[1]) ?? 0;
    return Size(w, h);
  }

  Map<String, dynamic> toMap() {
    return {'url': url, 'size_guide': sizeGuide};
  }
}
