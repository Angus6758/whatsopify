import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:seller_management/main.export.dart';

class AppTheme1 {
  const AppTheme1._();

  static ThemeData theme(bool isLight) => _mainTheme(isLight).copyWith(
        popupMenuTheme: PopupMenuThemeData(iconColor: _color(isLight).onError),
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: _color(isLight).outline,
          labelColor: _color(isLight).surfaceTint,
          indicatorColor: _color(isLight).surfaceTint,
          dividerColor: Colors.transparent,
        ),
        appBarTheme: _appBarTheme(isLight),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.withOpacity(.1),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          border: const OutlineInputBorder(),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: _color(isLight).error, width: .5),
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.isDisabled) {
                return _color(isLight).onSurface.withOpacity(0.2);
              }
              return null;
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.isDisabled) {
                return _color(isLight).onSurface.withOpacity(0.5);
              }
              return null;
            }),
          ),
        ),
      );

  static AppBarTheme _appBarTheme(bool isLight) {
    return AppBarTheme(
      backgroundColor: _color(isLight).primary,
      iconTheme: IconThemeData(color: _color(isLight).onPrimary),
      titleTextStyle: TextStyle(
        color: _color(isLight).onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
    );
  }

  static ThemeData _mainTheme(bool isLight) =>
      isLight ? _ThemeFlex.light : _ThemeFlex.dark;

  static ColorScheme _color(bool isLight) => IGenColorScheme.scheme(isLight);
}

class _ThemeFlex {
  const _ThemeFlex._();
  static ThemeData light = _lightTheme;
  static ThemeData dark = _darkTheme;

  static int _blendLvl(bool isLight) => isLight ? 4 : 7;
  static String? _fontFamily() => GoogleFonts.notoSans().fontFamily;

  static const FlexSchemeColor _colors = FlexSchemeColor(
    primary: Color(0xff2E5434),
    primaryContainer: Color(0xFF84D285),
    secondary: Color(0xFF090909),
    secondaryContainer: Color(0xFF124C49),
    tertiary: Color(0xff343e32),
    tertiaryContainer: Color(0x391F7F7C),
    appBarColor: Color(0xFFF8F8F8),
    error: Color(0xffb00020),
    errorContainer: Color(0xFF009721),
  );

  static FlexSubThemesData _subTheme(bool isLight) {
    return FlexSubThemesData(
      blendOnLevel: isLight ? 10 : 20,
      blendOnColors: isLight ? false : true,
      useTextTheme: true,
      useM2StyleDividerInM3: true,
      thinBorderWidth: 0.5,
      splashType: FlexSplashType.inkSparkle,
      defaultRadius: Corners.lg,
      sliderValueTinted: true,
      sliderTrackHeight: 3,
      inputDecoratorIsFilled: false,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      chipRadius: Corners.med,
      popupMenuElevation: 2.0,
      alignedDropdown: true,
      useInputDecoratorThemeInDialogs: true,
      tabBarIndicatorWeight: 2,
      tabBarDividerColor: const Color(0x00000000),
      drawerIndicatorSchemeColor: SchemeColor.primary,
      drawerIndicatorOpacity: 0.2,
      drawerSelectedItemSchemeColor: SchemeColor.primary,
      bottomNavigationBarElevation: 2.0,
      bottomNavigationBarShowUnselectedLabels: false,
      navigationBarLabelBehavior:
          NavigationDestinationLabelBehavior.onlyShowSelected,
    );
  }

  static final ThemeData _lightTheme = FlexThemeData.light(
    colors: _colors,
    colorScheme: IGenColorScheme.scheme(true),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: _blendLvl(false),
    bottomAppBarElevation: 1.0,
    tooltipsMatchBackground: true,
    subThemesData: _subTheme(false),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: _fontFamily(),
    textTheme: textTheme,
  );

  static final ThemeData _darkTheme = FlexThemeData.dark(
    colors: _colors.defaultError.toDark(3, true),
    colorScheme: IGenColorScheme.scheme(false),
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: _blendLvl(true),
    bottomAppBarElevation: 1.0,
    // darkIsTrueBlack: true,
    tooltipsMatchBackground: true,
    subThemesData: _subTheme(true),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    textTheme: textTheme,
  );
  static TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.rubik(
      fontSize: 98,
      fontWeight: FontWeight.w300,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.rubik(
      fontSize: 61,
      fontWeight: FontWeight.w300,
      letterSpacing: -0.5,
    ),
    displaySmall: GoogleFonts.rubik(
      fontSize: 49,
      fontWeight: FontWeight.w400,
    ),
    headlineMedium: GoogleFonts.rubik(
      fontSize: 35,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    headlineSmall: GoogleFonts.rubik(
      fontSize: 24,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: GoogleFonts.rubik(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
    ),
    titleMedium: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
    ),
    titleSmall: GoogleFonts.rubik(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    ),
    labelLarge: GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 1.25,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    ),
    labelSmall: GoogleFonts.roboto(
      fontSize: 10,
      fontWeight: FontWeight.w400,
      letterSpacing: 1.5,
    ),
  );
}
