import 'package:flutter/material.dart';

class AppLang {
  static const String en = 'en';
  static const Locale enLocale = Locale(en);
  static const String bn = 'bn';
  static const Locale bnLocale = Locale(bn);
  static const String hi = 'hi';
  static const Locale hiLocale = Locale(hi);
  static const String id = 'id';
  static const Locale idLocale = Locale(id);
  static const String fr = 'fr';
  static const Locale frLocale = Locale(fr);
  static const String ar = 'ar';
  static const Locale arLocale = Locale(ar);
  static const String zh = 'zh';
  static const Locale zhLocale = Locale(zh);
  static const String ur = 'ur';
  static const Locale urLocale = Locale(ur);
  static const String vi = 'vi';
  static const Locale viLocale = Locale(vi);
  static const String az = 'az';
  static const Locale azLocale = Locale(az);

  static Map<Locale, AppLanguage> supportedLanguages = {
    enLocale: AppLanguage(
      key: en,
      name: 'English',
      flag: '🇺🇸',
    ),
    bnLocale: AppLanguage(
      key: bn,
      name: 'বাংলা',
      flag: '🇧🇩',
    ),
    hiLocale: AppLanguage(
      key: hi,
      name: 'Hindi',
      flag: '🇮🇳',
    ),
    idLocale: AppLanguage(
      key: id,
      name: 'Indonesian',
      flag: '🇮🇩',
    ),
    frLocale: AppLanguage(
      key: fr,
      name: 'French',
      flag: '🇫🇷',
    ),
    arLocale: AppLanguage(
      key: ar,
      name: 'Arabic',
      flag: 'ar',
    ),
    zhLocale: AppLanguage(
      key: zh,
      name: 'Chinese',
      flag: '🇨🇳',
    ),
    urLocale: AppLanguage(
      key: ur,
      name: 'Urdu',
      flag: '🇵🇰',
    ),
    viLocale: AppLanguage(
      key: vi,
      name: 'Vietnamese',
      flag: 'VI',
    ),
    azLocale: AppLanguage(
      key: az,
      name: 'Azerbaijani',
      flag: 'AZ',
    ),
  };

  static const List<Locale> supportedLocales = [
    enLocale,
    bnLocale,
    hiLocale,
    idLocale,
    frLocale,
    arLocale,
    zhLocale,
    urLocale,
    viLocale,
    azLocale
  ];

  static const String translationPath = 'assets/lang';

  static AppLanguage? currentLanguage(Locale local) =>
      supportedLanguages[local];
}

class AppLanguage {
  AppLanguage({
    required this.key,
    required this.name,
    required this.flag,
  });

  final String flag;
  final String key;
  final String name;
}
