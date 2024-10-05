import 'package:dio/dio.dart';
import 'package:seller_management/features/product/view/network/local_db.dart';
import 'package:seller_management/features/product/view/settings/region_model.dart';


import '../../../../../locator.dart';

// final regionRepoProvider = Provider<RegionRepo>((ref) {
//   return RegionRepo();
// });

// class RegionRepo {
//   final pref = locate<SharedPreferences>();

//   Future<void> setLanguage(String langCode) async {
//     await pref.setString(PrefKeys.language, langCode);
//   }

//   Future<void> setCurrency(String currencyCode) async {
//     await pref.setString(PrefKeys.currency, currencyCode);
//   }

//   String? getCurrency() {
//     final currencyCode = pref.getString(PrefKeys.currency);
//     return currencyCode;
//   }

//   String? getLanguage() {
//     final langCode = pref.getString(PrefKeys.language);
//     return langCode;
//   }
// }

///
///

class RegionRepoEx1 {
  final ldb = locate<LocalDB1>();

  Future<bool> setLanguage(String langCode) async {
    return await ldb.setLanguage(langCode);
  }

  Future<void> setDefLanguage(String langCode) async {
    await ldb.setDefLanguage(langCode);
  }

  Future<void> setCurrency(Currency currency) async {
    await ldb.setCurrency(currency);
  }

  Future<void> setDefCurrency(Currency currency) async {
    await ldb.setDefCurrency(currency);
  }

  Future<void> set({
    Currency? currency,
    Currency? defCurrency,
    String? langCode,
    String? defLangCode,
  }) async {
    await Future.wait([
      if (currency != null) ldb.setCurrency(currency),
      if (langCode != null) ldb.setLanguage(langCode),
      if (defCurrency != null) ldb.setDefCurrency(defCurrency),
      if (defLangCode != null) ldb.setDefLanguage(defLangCode),
    ]);
  }

  Future<void> setFromResponse(Response response) async {
    final {"currency": c, "default_currency": b} = response.data;

    await set(
      currency: c == null ? null : Currency.fromMap(c),
      defCurrency: b == null ? null : Currency.fromMap(b),
    );
  }

  Currency? getCurrency() {
    final currency = ldb.getCurrency();
    return currency;
  }

  Currency? getBaseCurrency() {
    return ldb.getDefCurrency() ?? ldb.getDefCurrency();
  }

  String? getLanguage() {
    final lang = ldb.getLanguage() ?? ldb.getDefLanguage();
    return lang;
  }

  RegionModel getRegion() {
    final data = RegionModel.def.copyWith(
      langCode: ldb.getLanguage(),
      currency: ldb.getCurrency(),
      defCurrency: ldb.getDefCurrency(),
      defLangCode: ldb.getDefLanguage(),
    );
    return data;
  }
}
