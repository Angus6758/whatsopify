import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/dashboard/view/home_init_page.dart';
import 'package:seller_management/main.export.dart';
import '../features/auth/controller/auth_ctrl.dart';
import 'go_route_name.dart';
import 'page/error_route_page.dart';
import 'route_list.dart';

final goRoutesProvider = Provider.autoDispose<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  Get._key = rootKey;
  Toaster.navigator = rootKey;

  final routeList = ref.watch(routeListProvider(rootKey));
  final isLoggedIn = ref.watch(authCtrlProvider);
  final serverStatus = ref.watch(serverStatusProvider);

  final router = GoRouter(
    navigatorKey: rootKey,
   //initialLocation: RouteNames.home.path,
    initialLocation: RouteNames.product.path,
    routes: routeList,
    redirect: (context, state) {
      final current = state.uri.toString();
      final query = state.uri.queryParameters;
      DashInitPage.route = current;
      Logger(current, 'ROUTE');

      final statusResult = serverStatus.paths;

      if (statusResult != null) return statusResult;

      if (current.contains(RouteNames.login.path)) return null;

      if (!isLoggedIn) {
        Logger('Redirecting to login');
        return state.namedLocation(
          RouteNames.login.name,
          queryParameters: query,
        );
      }

      return null;
    },
    errorBuilder: (context, state) => ErrorRoutePage(error: state.error),
  );

  return router;
});
class Get {
  static GlobalKey<NavigatorState>? _key;

  static GlobalKey<NavigatorState>? get key => _key; // Adding a getter for the key

  static BuildContext? get context => _key?.currentContext;
}

// class Get {
//   static GlobalKey<NavigatorState>? _key;
//   static GlobalKey<NavigatorState>? get key => _key;
//   static BuildContext? get context => _key?.currentContext;
// }

class RouteOBS extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    DashInitPage.route = '';
  }
}
