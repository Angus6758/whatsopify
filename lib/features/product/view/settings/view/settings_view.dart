
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:seller_management/features/product/view/buttons/square_button.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/settings/controller/settings_ctrl.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/routes/go_route_name.dart';

import '../../../../../_widgets/_widgets.dart';


class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsCtrlProvider);
    final settingsCtrl = ref.read(settingsCtrlProvider.notifier);
    return Scaffold(
      appBar: KAppBar(
        title: Text(TR.settings(context)),
        leading: SquareButton.backButton(
          onPressed: () => context.pop(),
        ),
      ),
      body: settings.when(
          error: (e, s) => ErrorView1.reload(e, s, () => settingsCtrl.reload()),
          loading: () => const LoadingList(),
          data: (config) {
            return settings.isLoading
                ? const Loader()
                : RefreshIndicator(
                    onRefresh: () =>
                        ref.read(settingsCtrlProvider.notifier).reload(),
                    child: ListView(
                      physics: defaultScrollPhysics,
                      children: [
                        ListTile(
                          onTap: () {
                         //   RouteNames.region.goNamed(context);
                          },
                          leading: Icon(MdiIcons.translate),
                          title: Text(TR.languageCurrency(context)),
                        ),
                        ...config.extraPages.map(
                          (page) => ListTile(
                            onTap: () {
                              // RouteNames.extraPage.goNamed(
                              //   context,
                              //   pathParams: {'pageId': page.uid},
                              // );
                            },
                            leading: const Icon(Icons.description_outlined),
                            title: Text(page.name),
                          ),
                        )
                      ],
                    ),
                  );
          }),
    );
  }
}
