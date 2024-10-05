import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/go_route_name.dart';
import 'package:share_plus/share_plus.dart';

class DashboardPreferredSize extends StatelessWidget {
  const DashboardPreferredSize({
    super.key,
    required this.dash,
  });
  final Dashboard dash;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorTheme.onPrimary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(Corners.lg),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: context.colorTheme.secondaryContainer.withOpacity(0.1),
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: Insets.padH,
            child: Row(
              children: [
                if (context.onTab)
                  GestureDetector(
                    onTap: () => RouteNames.storeInformation.pushNamed(context),
                    child: CircleImage(
                      dash.seller.shop.shopLogo.url,
                      radius: 20,
                      useBorder: false,
                    ),
                  ),
                if (context.onMobile)
                  MenuAnchor(
                    builder: (context, controller, child) {
                      return GestureDetector(
                        onTap: () {
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        child: CircleImage(
                          dash.seller.shop.shopLogo.url,
                          radius: 20,
                          useBorder: false,
                        ),
                      );
                    },
                    menuChildren: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  RouteNames.accountSettings.pushNamed(context),
                              child: Text(
                                LocaleKeys.profile.tr(),
                              ),
                            ),
                            TextButton(
                              onPressed: () => RouteNames.storeInformation
                                  .pushNamed(context),
                              child: Text(
                                LocaleKeys.store_info.tr(),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  RouteNames.withdraw.goNamed(context),
                              child: Text(
                                LocaleKeys.withdraw.tr(),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  RouteNames.updatePass.goNamed(context),
                              child: Text(
                                LocaleKeys.change_password.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const Gap(Insets.med),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dash.seller.shop.name.ifEmpty('N/A'),
                      style: context.textTheme.titleLarge,
                    ),
                    SizedBox(
                      width:
                          context.onTab ? context.width / 3 : context.width / 2,
                      child: Text(
                        dash.seller.phone.ifEmpty('N/A'),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (context.onTab) ...[
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          context.colorTheme.primary.withOpacity(.05),
                    ),
                    onPressed: () => RouteNames.withdraw.pushNamed(context),
                    child: Text(
                      'Withdraw',
                      style: TextStyle(
                        color: context.colorTheme.primary,
                      ),
                    ),
                  ),
                  const Gap(Insets.sm),
                ],
                if (context.onTab) ...[
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          context.colorTheme.primary.withOpacity(.05),
                    ),
                    onPressed: () => RouteNames.messages.pushNamed(context),
                    child: Text(
                      'Ticket',
                      style: TextStyle(
                        color: context.colorTheme.primary,
                      ),
                    ),
                  ),
                  const Gap(Insets.offset),
                ],
                if (dash.seller.shop.url.isNotEmpty)
                  IconButton.outlined(
                    onPressed: () => Share.shareUri(
                      Uri.parse(dash.seller.shop.url),
                    ),
                    icon: Icon(
                      Icons.share,
                      color: context.colorTheme.primary,
                    ),
                  ),
                if (context.onTab) ...[
                  const Gap(Insets.sm),
                  IconButton.outlined(
                    onPressed: () => RouteNames.profile.pushNamed(context),
                    icon: Icon(
                      Icons.settings_outlined,
                      color: context.colorTheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Gap(Insets.lg),
        ],
      ),
    );
  }
}
