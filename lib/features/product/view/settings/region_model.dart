import 'dart:convert';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';

class RegionModel {
  RegionModel({
    required this.currency,
    required this.defCurrency,
    required this.langCode,
    required this.defLanguage,
  });

  static RegionModel def = RegionModel(
    langCode: AppLanguages.fallback().languageCode,
    defLanguage: AppLanguages.fallback().languageCode,
    currency: null,
    defCurrency: null,
  );

  final Currency? currency;
  final Currency? defCurrency;
  final String langCode;
  final String defLanguage;

  RegionModel setLanguage(String? langCode) {
    return RegionModel(
      currency: currency,
      defCurrency: defCurrency,
      defLanguage: defLanguage,
      langCode: langCode ?? this.langCode,
    );
  }

  RegionModel setCurrency(Currency? currency) {
    return RegionModel(
      currency: currency ?? this.currency,
      defCurrency: defCurrency,
      langCode: langCode,
      defLanguage: defLanguage,
    );
  }

  RegionModel setBaseCurrency(Currency? defCurrency) {
    return RegionModel(
      currency: currency,
      defCurrency: defCurrency ?? this.defCurrency,
      langCode: langCode,
      defLanguage: defLanguage,
    );
  }

  RegionModel copyWith({
    Currency? currency,
    String? langCode,
    String? defLangCode,
    Currency? defCurrency,
  }) {
    return RegionModel(
      currency: currency ?? this.currency,
      defCurrency: defCurrency ?? this.defCurrency,
      langCode: langCode ?? this.langCode,
      defLanguage: defLangCode ?? defLanguage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'currency': currency?.toMap(),
      // 'defCurrency': defCurrency?.toMap(),
      'langCode': langCode,
      'defLanguage': defLanguage,
    };
  }
}

class LocalCurrency {
  LocalCurrency({
    required this.langCode,
    required this.currency,
  });

  factory LocalCurrency.fromMap(Map<String, dynamic> map) {
    return LocalCurrency(
      currency: Currency.fromMap(map['currency']),
      langCode: map['locale'],
    );
  }

  static LocalCurrency nulled = LocalCurrency(
    langCode: AppLanguages.fallback().countryCode,
    currency: null,
  );

  final Currency? currency;
  final String? langCode;
}

class LanguagesData {
  LanguagesData({
    required this.name,
    required this.code,
    required this.image,
  });

  factory LanguagesData.fromJson(String source) =>
      LanguagesData.fromMap(json.decode(source));

  factory LanguagesData.fromMap(Map<String, dynamic> map) {
    return LanguagesData(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      image: map['image'] ?? '',
    );
  }

  final String code;
  final String image;
  final String name;

  Map<String, dynamic> toMap() => {
        'name': name,
        'code': code,
        'image': image,
      };

  String toJson() => json.encode(toMap());
}

class Currency {
  Currency({
    required this.uid,
    required this.name,
    required this.symbol,
    required this.rate,
  });

  factory Currency.fromJson(String source) =>
      Currency.fromMap(json.decode(source));

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      rate: map.parseNum('rate'),
    );
  }

  final String name;
  final num rate;
  final String symbol;
  final String uid;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'name': name,
        'symbol': symbol,
        'rate': rate,
      };

  String toJson() => json.encode(toMap());
}

///
///

