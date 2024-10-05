import 'package:badges/badges.dart' as badges;


import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/animation/no_items_animation.dart';
import 'package:seller_management/features/product/view/brands/view/brands_showcase.dart';
import 'package:seller_management/features/product/view/cart/controller/carts_ctrl.dart';
import 'package:seller_management/features/product/view/categories/view/category_showcase.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/extensions/context_extension.dart';
import 'package:seller_management/features/product/view/extensions/helper_extension.dart';
import 'package:seller_management/features/product/view/flash_deals/view/flash_view.dart';
import 'package:seller_management/features/product/view/home/controller/home_page_ctrl.dart';
import 'package:seller_management/features/product/view/home/view/home_init_page.dart';
import 'package:seller_management/features/product/view/home/view/local/campaign_slider.dart';
import 'package:seller_management/features/product/view/home/view/local/counter_view.dart';
import 'package:seller_management/features/product/view/home/view/local/home_loading.dart';
import 'package:seller_management/features/product/view/home/view/local/product_showcase.dart';
import 'package:seller_management/features/product/view/home/view/local/section_header.dart';
import 'package:seller_management/features/product/view/home/view/local/slider.dart';
import 'package:seller_management/features/product/view/home/view/local/suggest_product.dart';
import 'package:seller_management/features/product/view/localization/localization_const.dart';
import 'package:seller_management/features/product/view/products/view/all_product_showcase.dart';
import 'package:seller_management/features/product/view/products/view/local/digital_product_showcase.dart';
import 'package:seller_management/features/product/view/search/view/search_dialog.dart';
import 'package:seller_management/features/product/view/settings/provider/settings_provider.dart';
import 'package:seller_management/features/product/view/store/view/local/store_showcase.dart';
import 'package:seller_management/features/product/view/strings/app_const.dart';
import 'package:seller_management/features/product/view/strings/hero_tags.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:seller_management/features/seller_info/controller/seller_info_ctrl.dart';
import 'package:seller_management/routes/go_route_name.dart';
import 'package:seller_management/routes/route_list.dart';

import '../../../_widgets/_widgets.dart';
import '../../auth/controller/auth_ctrl.dart';
import 'user_dash/provider/user_dash_provider.dart';


class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final cartList = ref.watch(cartCtrlProvider);
    final frontendSection =
    ref.watch(settingsProvider.select((v) => v?.frontendSection));

    final isLoggedIn = ref.watch(authCtrlProvider);
    final homePageData = ref.watch(homeCtrlProvider);
    final promotionBanners = ref
        .watch(settingsProvider.select((value) => value?.promotionalBanners));

    final [pb1, pb2, ..._] = promotionBanners ?? [null, null];

    // final user1 = ref.watch(userDashProvider.select((value) => value?.user));
    final user = ref.watch(sellerCtrlProvider);

    final homeReload = useCallback(() async {
      await ref.read(homeCtrlProvider.notifier).reload();
    });

    return HomeInitPage(
      child: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          if (didPop) {
            return;
          }
          showExitDialog(context);
        },
        child: Scaffold(
          appBar: KAppBar(
            leadingWidth: 50,
            leading: Row(
              children: [
                const SizedBox(width: 10),
                if (isLoggedIn)
                  user.maybeWhen(
                    data: (user) => InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: user == null
                          ? null
                          : () => RouteNames.profile.pushNamed(context),
                      child: HeroWidget(
                        tag: user.image ?? 'user',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: HostedImage.square(
                            user.image ?? 'user',
                            dimension: 40,
                            errorIcon: Icons.person,
                          ),
                        ),
                      ),
                    ),
                    orElse: () => const SizedBox.shrink(), // Handle other states like loading or error
                  )
                else
                  SizedBox.square(
                    dimension: 40,
                    child: IconButton.filled(
                      onPressed: () {
                        RouteNames.login.goNamed(context);
                      },
                      icon: Icon(
                        Icons.login,
                        color: context.colors.onPrimary,
                      ),
                      tooltip: TR.login(context),
                    ),
                  ),
              ],
            ),
            title: user.maybeWhen(
              data: (user) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoggedIn
                        ? '${TR.hello(context)} ${user.username ?? 'user'},'
                        : '${TR.helloGuest(context)},',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateTime.now().welcomeMassage(context),
                    style: context.textTheme.bodyLarge,
                  ),
                ],
              ),
              orElse: () => Text( // Default case for loading, error, or null data
                isLoggedIn
                    ? '${TR.hello(context)} user,'
                    : '${TR.helloGuest(context)},',
                style: context.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          body: SafeArea(
            bottom: false,
            child: Center(
              child: RefreshIndicator(
                onRefresh: homeReload,
                child: SingleChildScrollView(
                  physics: defaultScrollPhysics,
                  child: homePageData.when(
                    error: (err, s) =>
                        ErrorView1.reload(err, s, () => homeReload()),
                    loading: () => const HomePageLoading(),
                    data: (homeData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),

                          //! image slider :-------------------------------
                          if (homeData.isSliderNotEmpty)
                            ImageSlider(banners: homeData.banners.bannersData),
                          const SizedBox(height: 5),

                          //! Categories :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title: TR.category(context),
                                  onTrailingTap: () {
                                    RouteNames.categories.goNamed(context);
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData.isCategoriesNotEmpty)
                                  CategoryShowcase(
                                    categories: homeData
                                        .categories.categoriesData
                                        .takeFirst(context.onMobile ? 8 : 16),
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          //! Flash Sale :----------------------------------
                          if (homeData.flash != null) ...[
                            Container(
                              decoration: BoxDecoration(
                                color: context.colors.secondaryContainer
                                    .withOpacity(0.1),
                              ),
                              padding:
                              defaultPadding.copyWith(bottom: 20, top: 5),
                              child: Column(
                                children: [
                                  FlashTimeCounter(
                                    onlyTimer: false,
                                    duration: homeData.flash!.endDate
                                        .difference(DateTime.now()),
                                    section: frontendSection?.flashSale,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RouteNames.flashDeals.pushNamed(context);
                                    },
                                    child: FlashDealView(
                                      products: homeData.flash!.products,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],

                          //! Campaign :-----------------------------------------
                          if (homeData.isCampaignsNotEmpty) ...[
                            Padding(
                              padding: defaultPadding,
                              child: SectionHeader(
                                title: frontendSection?.campaign?.heading ?? '',
                                onTrailingTap: () {
                                  RouteNames.campaigns.goNamed(context);
                                },
                              ),
                            ),
                            const SizedBox(height: 5),
                            CampaignSlider(
                              campaigns: homeData.campaigns.listData,
                            ),
                            const SizedBox(height: 15),
                          ],

                          //! Suggest Product :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title: TR.suggestProduct(context),
                                  onTrailingTap: () {
                                    RouteNames.productsView.goNamed(
                                      context,
                                      query: {
                                        't': CachedKeys.suggestedProducts
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData.isSuggestedProductsNotEmpty)
                                  SuggestProductView(
                                    products:
                                    homeData.suggestedProducts.listData,
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),

                          //! TOdays deals :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title: frontendSection?.todaysDeal?.heading ??
                                      '',
                                  onTrailingTap: () {
                                    RouteNames.productsView.goNamed(
                                      context,
                                      query: {'t': CachedKeys.todaysProducts},
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData.isTodaysDealNotEmpty)
                                  ProductShowcase(
                                    products: homeData.todayDeals.listData
                                        .takeFirst(),
                                    type: CachedKeys.todaysProducts,
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),

                          //! Best selling Products :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title:
                                  frontendSection?.bestSelling?.heading ??
                                      '',
                                  onTrailingTap: () {
                                    RouteNames.productsView.goNamed(
                                      context,
                                      query: {'t': CachedKeys.bestSaleProducts},
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData.isBestSellingNotEmpty)
                                  ProductShowcase(
                                    products: homeData.bestSelling.listData,
                                    type: CachedKeys.bestSaleProducts,
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),

                          //! promotional banner 1nst :----------------------------------
                          if (pb1 != null)
                            InkWell(
                              child: HostedImage(
                                pb1,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 15),

                          //! New Arrival :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title:
                                  frontendSection?.newArrivals?.heading ??
                                      '',
                                  onTrailingTap: () {
                                    RouteNames.productsView.goNamed(
                                      context,
                                      query: {'t': CachedKeys.newProducts},
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData.newArrival.listData.isNotEmpty)
                                  ProductShowcase(
                                    products: homeData.newArrival.listData,
                                    type: CachedKeys.newProducts,
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),

                          //! Brands :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title: TR.brands(context),
                                  onTrailingTap: () =>
                                      RouteNames.brands.goNamed(context),
                                ),
                                const SizedBox(height: 5),
                                if (homeData.brands.brandsData.isNotEmpty)
                                  BrandShowcase(
                                    brands: homeData.brands.brandsData
                                        .takeFirst(context.onMobile ? 6 : 10),
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 15),
                              ],
                            ),
                          ),

                          //! Digital Products :----------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title: frontendSection
                                      ?.digitalProducts?.heading ??
                                      '',
                                  onTrailingTap: () {
                                    RouteNames.productsView.goNamed(
                                      context,
                                      query: {'t': CachedKeys.digitalProducts},
                                    );
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData
                                    .digitalProducts.listData.isNotEmpty)
                                  DigitalProductShowcase(
                                    data: homeData.digitalProducts.listData,
                                  )
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          //! Store :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: Column(
                              children: [
                                SectionHeader(
                                  title: TR.store(context),
                                  onTrailingTap: () {
                                    RouteNames.allStore.pushNamed(context);
                                  },
                                ),
                                const SizedBox(height: 5),
                                if (homeData.isStoresNotEmpty)
                                  StoreShowcase(homeData.stores.listData)
                                else
                                  Center(
                                    child: NoItemsAnimation(
                                      hight: 100,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                const SizedBox(height: 25),
                              ],
                            ),
                          ),

                          //! promotional banner 2nd :----------------------------------
                          if (pb2 != null)
                            InkWell(
                              child: HostedImage(
                                pb2,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          const SizedBox(height: 15),

                          //! Dynamic Category :----------------------------------
                          for (final category in homeData.dynamicCategory)
                            if (category.products.isNotEmpty)
                              Padding(
                                padding: defaultPadding,
                                child: Column(
                                  children: [
                                    SectionHeader(
                                      title: category.homeTitle ?? '',
                                      onTrailingTap: () {
                                        RouteNames.categoryProducts1.pushNamed(
                                          context,
                                          pathParams: {
                                            'id': category.category.uid
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    ProductShowcase(
                                      products: category.products.listData,
                                      type:
                                      category.homeTitle ?? HeroTags.random,
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),

                          //! All products :----------------------------------
                          Padding(
                            padding: defaultPadding,
                            child: SectionHeader(
                              title: TR.allProduct(context),
                              onTrailingTap: () {
                                RouteNames.productsView.pushNamed(
                                  context,
                                  query: {'t': CachedKeys.allProducts},
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 5),

                          const Padding(
                            padding: defaultPadding,
                            child: AllProductShowcase(),
                          ),
                          const SizedBox(height: 30),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}