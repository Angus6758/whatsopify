

import 'package:package_info_plus/package_info_plus.dart';
import 'package:seller_management/features/product/view/common/local_storage.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/settings/region_model.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

class LocalDB1 extends LocalStorageBase {
  Future<void> resetIfNecessary([bool doNow = false]) async {
    if (doNow) {
      Logger('Cleared LocalDB');
      await clear();
    }
    final pack = await PackageInfo.fromPlatform();
    final current = pack.version;
    final saved = getString('app_version');
    if (saved == null) {
      await save('app_version', current);
    } else if (saved != current) {
      await clear();
      await save('app_version', current);
    }
  }

  //! Token
  Future<bool> setToken(String? token) async {
    if (token == null) return delete(PrefKeys.accessToken);
    return await save(PrefKeys.accessToken, token);
  }

  String? getToken() => getString(PrefKeys.accessToken);

  //! Language
  Future<bool> setLanguage(String? langCode) async {
    if (langCode == null) return delete(PrefKeys.language);
    return await save(PrefKeys.language, langCode);
  }

  String? getLanguage() => getString(PrefKeys.language);

  //! Currency
  Future<bool> setCurrency(Currency? currency) async {
    if (currency == null) return delete(PrefKeys.currency);
    return await save(PrefKeys.currency, currency.toMap());
  }

  Currency? getCurrency() {
    var map = getMap(PrefKeys.currency);
    if (map == null) return null;
    return Currency.fromMap(map);
  }

  //! Default Currency
  Future<bool> setDefCurrency(Currency? currency) async {
    if (currency == null) return delete(PrefKeys.defCurrency);
    return await save(PrefKeys.defCurrency, currency.toMap());
  }

  Currency? getDefCurrency() {
    var map = getMap(PrefKeys.defCurrency);
    if (map == null) return null;
    return Currency.fromMap(map);
  }

  //! Default Language
  Future<bool> setDefLanguage(String? langCode) async {
    if (langCode == null) return delete(PrefKeys.defLanguage);
    return await save(PrefKeys.defLanguage, langCode);
  }

  String? getDefLanguage() => getString(PrefKeys.defLanguage);

  //! Theme
  Future<bool> setTheme(bool? themeMode) async {
    if (themeMode == null) return delete(PrefKeys.isLight);
    return await save(PrefKeys.isLight, themeMode);
  }

  String? getTheme() => getString(PrefKeys.isLight);
}
