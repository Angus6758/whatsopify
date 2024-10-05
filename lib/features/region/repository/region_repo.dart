import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@Singleton(order: 6)
class RegionRepo extends Repo {
  Future<void> setLanguage(String langCode) async {
    await ldb.setLanguage(langCode);
  }

  Future<void> setCurrency(Currency currency) async {
    await ldb.setCurrency(currency);
  }

  Future<void> setBaseCurrency(Currency currency) async {
    await ldb.setBaseCurrency(currency);
  }

  Future<void> set({
    Currency? currency,
    Currency? baseCurrency,
    String? langCode,
  }) async {
    if (currency != null) await ldb.setCurrency(currency);
    if (langCode != null) await ldb.setLanguage(langCode);
    if (baseCurrency != null) await ldb.setBaseCurrency(baseCurrency);
  }

  Future<void> setFromResponse(Response response) async {
    if (response.data == null) return;

    final {"locale": l, "currency": c, "default_currency": b} = response.data;

    await set(
      langCode: l,
      currency: c == null ? null : Currency.fromMap(c),
      baseCurrency: b == null ? null : Currency.fromMap(b),
    );
  }

  Currency? getCurrency() {
    final currency = ldb.getCurrency();
    return currency;
  }

  Currency? getBaseCurrency() {
    final currency = ldb.getBaseCurrency();
    return currency;
  }

  String? getLanguage() {
    final langCode = ldb.getLanguage();
    return langCode;
  }

  Region getRegion() {
    return Region.def.copyWith(
      langCode: ldb.getLanguage(),
      currency: ldb.getCurrency(),
      baseCurrency: ldb.getBaseCurrency(),
    );
  }
}
