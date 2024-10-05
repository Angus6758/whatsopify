import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seller_management/_core/extensions/context_extension.dart';
import 'package:seller_management/_core/lang/app_lang.dart';
import 'package:seller_management/_core/lang/codegen_loader.g.dart';
import 'package:seller_management/features/product/view/localization/app_localization.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/products/view/themes/app_theme.dart';
import 'package:seller_management/features/product/view/region_settings/controller/region_ctrl.dart';
import 'package:seller_management/features/product/view/settings/controller/settings_ctrl.dart';
import 'package:seller_management/locatorApp.dart';
import 'package:seller_management/routes/go_route_config.dart';
import 'package:seller_management/theme/app_theme.dart';
import 'package:seller_management/features/product/view/products/view/themes/theme_config.dart' as product_theme;
import 'package:seller_management/theme/theme_config.dart' as global_theme;
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  //await Firebase.initializeApp();
  await locatorSetUp();
  await configureDependencies();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: [
          ...AppLang.supportedLocales, // First localization setup
          ...AppLanguages.locales, // Second localization setup
        ],
        path: AppLang.translationPath, // Path for first localization
        fallbackLocale: AppLang.enLocale, // Fallback for first localization
        assetLoader: const CodegenLoader(),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(goRoutesProvider);
    ref.watch(settingsCtrlProvider);

    // First theme mode (used for specific screens)
    //  final mode1 = ref.watch(themeModeProvider1);
    // Second theme mode (used for other screens)
    // final mode2 = ref.watch(themeModeProvider);
    final mode1 = ref.watch(product_theme.themeModeProvider);
    final mode2 = ref.watch(global_theme.themeModeProvider);

    // Second theme
    final theme2 = ref.watch(appThemeProvider);
    final region = ref.watch(regionCtrlProvider);
    bool useTheme1 = true;

    return RefreshConfiguration(
      headerBuilder: () => WaterDropHeader(
        waterDropColor: context.colorTheme.primary,
      ),
      footerBuilder: () => const ClassicFooter(
        loadStyle: LoadStyle.ShowWhenLoading,
        loadingText: '',
        noDataText: 'No more messages',
      ),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Whatsopify',
        themeMode: useTheme1 ? mode2 : mode1, // Apply theme mode based on condition
        theme: useTheme1 ?theme2.theme(true) :  AppTheme1.theme(true), // Apply light theme based on condition
        darkTheme: useTheme1 ? AppTheme1.theme(false) : theme2.theme(false), // Apply dark theme based on condition
        localizationsDelegates: [
          ...context.localizationDelegates, // Delegates for first localization
          FormBuilderLocalizations.delegate,
          AppLocalization.delegate, // Delegate for second localization
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          ...context.supportedLocales, // Locales for first localization
          ...AppLanguages.locales, // Locales for second localization
        ],
        locale: context.locale, // Set the locale for your app
        routerConfig: routes,
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return AppLanguages.fallback();
        },
      ),
    );
  }
}