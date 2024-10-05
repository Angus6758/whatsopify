
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';

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
  ThemeData get theme => Theme.of(this);

  double get height => mq.size.height;

  double get width => mq.size.width;

  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;

  Brightness get bright => theme.brightness;
  bool get onMobile => width < AppLayout.maxMobile;
  bool get onTab => width > AppLayout.maxMobile;

  bool get isDark => bright == Brightness.dark;
  bool get isLight => bright == Brightness.light;
}
