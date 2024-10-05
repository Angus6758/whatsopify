import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seller_management/_core/lang/locale_keys.g.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/dashboard/view/local/local.dart';
import 'package:seller_management/features/seller_info/controller/seller_info_ctrl.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

import 'local/profile_button.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sellerData = ref.watch(sellerCtrlProvider);

    // Logic to determine which theme is being used
    bool useTheme1 = true; // Adjust this logic as needed

    // Watch the appropriate theme mode provider based on the theme being used
    final themeModeNotifier = useTheme1
        ? ref.read(themeModeProvider1.notifier)
        : ref.read(themeModeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.profile.tr()),
        actions: [
          IconButton(
            onPressed: () {
              themeModeNotifier.toggleTheme(); // Toggle theme based on the selected theme provider
            },
            icon: Icon(context.isDark ? Icons.light_mode : Icons.dark_mode),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.read(sellerCtrlProvider.notifier).reload(),
        child: SingleChildScrollView(
          padding: Insets.padH,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const Gap(Insets.med),
              sellerData.when(
                loading: () => Loader.shimmer(200, context.width),
                error: ErrorView.new,
                data: (seller) => ShadowContainer(
                  child: Padding(
                    padding: Insets.padAll,
                    child: Column(
                      children: [
                        const SizedBox(width: double.infinity),
                        const Gap(30),
                        Stack(
                          children: [
                            CircleImage(
                              seller.image,
                              radius: 60,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => RouteNames.accountSettings
                                    .pushNamed(context),
                                child: CircleAvatar(
                                  backgroundColor: context.colorTheme.primary,
                                  child: SvgPicture.asset(
                                    AssetsConst.edit,
                                    height: 20,
                                    // color: context.colorTheme.onPrimary,
                                    colorFilter: ColorFilter.mode(
                                      context.colorTheme.onPrimary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const Gap(Insets.med),
                        Text(
                          seller.name.ifEmpty('N/A'),
                          style: context.textTheme.titleLarge,
                        ),
                        Text(
                          seller.phone.ifEmpty('N/A'),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Gap(Insets.lg),
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(Insets.lg),
              ShadowContainer(
                child: Padding(
                  padding: Insets.padAll,
                  child: Column(
                    children: [
                      ProfileButton(
                        title: LocaleKeys.seller_profile.tr(),
                        onTap: () =>
                            RouteNames.accountSettings.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.store_info.tr(),
                        onTap: () =>
                            RouteNames.storeInformation.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.withdraw.tr(),
                        onTap: () => RouteNames.withdraw.pushNamed(context),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(Insets.lg),
              ShadowContainer(
                child: Padding(
                  padding: Insets.padAll,
                  child: Column(
                    children: [
                      ProfileButton(
                        title: LocaleKeys.add_product.tr(),
                        onTap: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: Get.context!,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return const ProductAddSheet();
                            },
                          );
                        },
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.subscription_plan.tr(),
                        onTap: () => RouteNames.subscription.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.all_product.tr(),
                        onTap: () => RouteNames.product.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.order.tr(),
                        onTap: () => RouteNames.order.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.account_settlement.tr(),
                        onTap: () => RouteNames.totalBalance.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.ticket.tr(),
                        onTap: () => RouteNames.messages.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.language.tr(),
                        onTap: () => RouteNames.language.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.currency.tr(),
                        onTap: () => RouteNames.currency.pushNamed(context),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(Insets.lg),
              ShadowContainer(
                child: Padding(
                  padding: Insets.padAll,
                  child: Column(
                    children: [
                      ProfileButton(
                        title: LocaleKeys.change_password.tr(),
                        onTap: () => RouteNames.updatePass.pushNamed(context),
                      ),
                      Gap(context.onMobile ? Insets.lg : Insets.xl),
                      ProfileButton(
                        title: LocaleKeys.logout.tr(),
                        onTap: () {
                          ref.read(authCtrlProvider.notifier).logout();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(100),
            ],
          ),
        ),
      ),
    );
  }
}