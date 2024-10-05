import 'package:seller_management/main.export.dart';

class AppSettings {
  AppSettings({
    required this.config,
    required this.languages,
    required this.currencies,
    required this.defaultLanguage,
    required this.currency,
    required this.imageFormate,
    required this.fileFormate,
  });

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      config: Config.fromMap(map['config']),
      languages: Language.listFromConfig(map['languages']),
      currencies: Currency.listFromConfig(map['currency']),
      defaultLanguage: Language.fromMap(map['default_language']),
      currency: Currency.fromMap(map['default_currency']),
      imageFormate: List<String>.from(map['image_format']),
      fileFormate: List<String>.from(map['file_format']),
    );
  }

  final Config config;
  final List<Currency> currencies;
  final Currency currency;
  final Language defaultLanguage;
  final List<Language> languages;
  final List<String> imageFormate;
  final List<String> fileFormate;
  List<String> get allFormate => [...imageFormate, ...fileFormate];

  Map<String, dynamic> toJson() {
    return {
      'config': config.toMap(),
      'languages': {'data': languages.map((e) => e.toMap()).toList()},
      'currency': {'data': currencies.map((e) => e.toMap()).toList()},
      'default_language': defaultLanguage.toMap(),
      'default_currency': currency.toMap(),
      'image_format': imageFormate,
      'file_format': fileFormate,
    };
  }
}
