import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:seller_management/features/product/view/gen/assets.gen.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';

import 'nav_button.dart';
import 'nav_destination.dart';

class NavigationRoot extends HookConsumerWidget {
  const NavigationRoot(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rootPath = GoRouterState.of(context).uri.pathSegments.first;
    final int getIndex =
        RouteNames.nestedRoutes.map((e) => e.name).toList().indexOf(rootPath);

    final index = useState(0);

    useEffect(() {
      index.value = getIndex;
      return null;
    }, [rootPath]);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: context.onTab
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 10, left: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: context.colorTheme.onPrimary,
                  border: Border.all(
                    width: 2,
                    color: context.colorTheme.surface.withOpacity(.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: context.colorTheme.secondaryContainer
                          .withOpacity(0.1),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: NavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  selectedIndex: index.value,
                  height: 70,
                  destinations: [
                    for (var i = 0; i < _destinations(context).length; i++)
                      NavButton(
                        count: 1,
                        destination: _destinations(context)[i],
                        index: i,
                        selectedIndex: index.value,
                        onPressed: () {
                          index.value = i;
                          RouteNames.nestedRoutes[i].push(context);
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  List<KNavDestination> _destinations(BuildContext ctx) => [
        KNavDestination(
          icon: AssetsConst.home,
          title: 'Home',
        ),
        KNavDestination(
          icon: AssetsConst.order,
          title: 'Order',
        ),
        KNavDestination(
          isHighlight: true,
          icon: AssetsConst.product,
          title: 'Product',
        ),
        KNavDestination(
          icon: AssetsConst.sms,
          title: 'Massage',
        ),
        KNavDestination(
          icon: AssetsConst.profile,
          title: 'Me',
        ),
      ];
}

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 5,
      shadowColor: Colors.white,
      icon: SizedBox(
        height: 100,
        child: Assets.lottie.warning.lottie(),
      ),
      title: const Text('Hey'),
      content: const Text(
        'Want to exit',
        textAlign: TextAlign.center,
      ),
      actions: [
        SizedBox(
          width: 120,
          child: OutlinedButton(
            style: const ButtonStyle(
              shape: MaterialStatePropertyAll(
                StadiumBorder(),
              ),
            ),
            onPressed: () {
              exit(0);
            },
            child: const Text('Yes'),
          ),
        ),
        SizedBox(
          width: 120,
          child: FilledButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              context.pop();
            },
            child: const Text(
              'No',
            ),
          ),
        ),
      ],
    );
  }
}
