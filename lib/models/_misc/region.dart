import 'package:seller_management/main.export.dart';

class Region {
  Region({
    required this.currency,
    required this.baseCurrency,
    required this.langCode,
  });

  static Region def =
      Region(langCode: 'en', currency: null, baseCurrency: null);

  final Currency? currency;
  final Currency? baseCurrency;
  final String langCode;

  Region setLanguage(String? langCode) {
    return Region(
      currency: currency,
      baseCurrency: baseCurrency,
      langCode: langCode ?? this.langCode,
    );
  }

  Region setCurrency(Currency? currencyUid) {
    return Region(
      currency: currencyUid ?? currency,
      baseCurrency: baseCurrency,
      langCode: langCode,
    );
  }

  Region setBaseCurrency(Currency? baseCurrency) {
    return Region(
      currency: currency,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      langCode: langCode,
    );
  }

  Region copyWith({
    Currency? currency,
    String? langCode,
    Currency? baseCurrency,
  }) {
    return Region(
      currency: currency ?? this.currency,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      langCode: langCode ?? this.langCode,
    );
  }
}
