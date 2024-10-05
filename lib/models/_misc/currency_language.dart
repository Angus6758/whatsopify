import 'package:seller_management/main.export.dart';

class Currency {
  Currency({
    required this.uid,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      uid: map['uid'],
      name: map['name'],
      symbol: map['symbol'],
      rate: map.parseNum('rate'),
    );
  }

  final String name;
  final num rate;
  final String symbol;
  final String uid;

  static List<Currency> listFromConfig(Map<String, dynamic> map) {
    return List<Currency>.from(
      map['data']?.map((x) => Currency.fromMap(x)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'symbol': symbol,
      'rate': rate,
    };
  }
}

class Language {
  Language({
    required this.code,
    required this.name,
    required this.image,
  });

  factory Language.fromMap(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
      image: json['image'] as String,
    );
  }

  static List<Language> listFromConfig(Map<String, dynamic> map) {
    return List<Language>.from(
      map['data']?.map((x) => Language.fromMap(x)).toList(),
    );
  }

  final String code;
  final String image;
  final String name;

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'image': image,
    };
  }
}
