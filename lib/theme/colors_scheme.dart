import 'package:flutter/material.dart';

class IGenColorScheme {
  const IGenColorScheme._();

  static ColorScheme scheme(bool isLight) {
    return ColorScheme(
      brightness: isLight ? Brightness.light : Brightness.dark,
      primary: const Color(0xffece2e2),
      onPrimary: isLight ? Colors.white : const Color(0xff0E1A24),
      primaryContainer: const Color(0xFF84D285),
      onPrimaryContainer: isLight ? Colors.white : const Color(0xff121F2A),
      secondary: const Color(0xff9400ff),
      onSecondary: isLight
          ? const Color(0xffffffff)
          : const Color.fromARGB(255, 0, 0, 0),
      secondaryContainer: const Color(0xff1f7f7b),
      onSecondaryContainer: isLight ? const Color(0xffe9e9e9) : Colors.black,
      tertiary: Colors.amber,
      onTertiary: isLight ? const Color(0xffffffff) : const Color(0xff0f120f),
      tertiaryContainer:
          isLight ? const Color(0xff94b291) : const Color(0xff394337),
      onTertiaryContainer:
          isLight ? const Color(0xff0d0f0c) : const Color(0xffe8eae8),
      error: const Color(0xffb00020),
      onError:
          isLight ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
      errorContainer: const Color.fromARGB(255, 0, 151, 33),
      onErrorContainer:
          isLight ? const Color(0xff141213) : const Color(0xfffbe8ec),
      background: isLight
          ? const Color.fromARGB(255, 255, 255, 255)
          : const Color.fromARGB(255, 0, 15, 15),
      onBackground: isLight ? const Color(0xff090909) : const Color(0xffececec),
      surface: isLight ? const Color(0xFFF7F8FA) : const Color(0xff090808),
      onSurface: isLight ? const Color(0xff090909) : const Color(0xffececec),
      surfaceVariant:
          isLight ? const Color(0xff000000) : const Color(0xFFffffff),
      onSurfaceVariant:
          isLight ? const Color(0xff121212) : const Color(0xffe0dfdf),
      outline: isLight ? const Color(0xFFBDBDBD) : const Color(0xff797979),
      outlineVariant: isLight
          ? const Color.fromARGB(255, 122, 122, 122)
          : const Color(0xff2d2d2d),
      shadow: const Color(0xffA0A0A0),
      scrim: const Color(0xff000000),
      inverseSurface:
          isLight ? const Color(0xFF1F7F7B) : const Color(0xfffea34c),
      onInverseSurface: isLight
          ? const Color.fromARGB(68, 254, 162, 76)
          : const Color(0xff131313),
      inversePrimary: isLight
          ? const Color.fromARGB(57, 31, 127, 124)
          : const Color(0xff6b4740),
      surfaceTint: const Color(0xffffffff),
    );
  }
}
