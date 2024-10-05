import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/_core/strings/app_const.dart';

extension RouteEx on BuildContext {
  GoRouter get route => GoRouter.of(this);
  GoRouterState get routeState => GoRouterState.of(this);

  Map<String, String> get pathParams => routeState.pathParameters;
  String? param(String key) => pathParams[key];
  Map<String, String> get queryParams => routeState.uri.queryParameters;
  String? query(String key) => queryParams[key];
  void nPop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

extension ContextEx on BuildContext {
  MediaQueryData get mq => MediaQuery.of(this);

  Size get size => MediaQuery.sizeOf(this);
  double get height => size.height;
  double get width => size.width;

  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorTheme => theme.colorScheme;

  Brightness get bright => theme.brightness;

  bool get onMobile => width < AppLayout.maxMobile;
  bool get onTab => width > AppLayout.maxMobile;
  bool get onDesktop => width > AppLayout.maxTab;
  // bool get isTabActive =>
  //     width > AppLayout.maxMobile && width < AppLayout.maxTab;

  bool get isDark => bright == Brightness.dark;
  bool get isLight => bright == Brightness.light;
}
