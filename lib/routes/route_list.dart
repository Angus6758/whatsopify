import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_management/features/add_product/view/add_digital_product.dart';
import 'package:seller_management/features/add_product/view/add_product_view.dart';
import 'package:seller_management/features/auth/view/change_password.dart';
import 'package:seller_management/features/auth/view/login_view.dart';
import 'package:seller_management/features/auth/view/sign_up.dart';
import 'package:seller_management/features/campaign/view/campaign_view.dart';
import 'package:seller_management/features/chat/view/customer_chat_list_view.dart';
import 'package:seller_management/features/chat/view/customer_chat_view.dart';
import 'package:seller_management/features/dashboard/view/dash_view.dart';
import 'package:seller_management/features/dashboard/view/home_init_page.dart';
import 'package:seller_management/features/language/view/currency_view.dart';
import 'package:seller_management/features/order/view/order_details_view.dart';
import 'package:seller_management/features/order/view/order_view.dart';
import 'package:seller_management/features/password_reset/view/new_password.dart';
import 'package:seller_management/features/password_reset/view/password_reset.dart';
import 'package:seller_management/features/product/view/address/view/add_address.dart';
import 'package:seller_management/features/product/view/address/view/address_view.dart';
import 'package:seller_management/features/product/view/brands/view/brand_products.dart';
import 'package:seller_management/features/product/view/brands/view/brand_view.dart';
import 'package:seller_management/features/product/view/campaign/view/campaign_details_view.dart';
import 'package:seller_management/features/product/view/campaign/view/campaigns_view.dart';
import 'package:seller_management/features/product/view/cart/view/carts_view.dart';
import 'package:seller_management/features/product/view/categories/view/categories_products_view.dart';
import 'package:seller_management/features/product/view/categories/view/categories_view.dart';
import 'package:seller_management/features/product/view/check_out/view/checkout_payment_view.dart';
import 'package:seller_management/features/product/view/check_out/view/checkout_shipping_view.dart';
import 'package:seller_management/features/product/view/check_out/view/checkout_summery.dart';
import 'package:seller_management/features/product/view/check_out/view/order_placed_page.dart';
import 'package:seller_management/features/product/view/error_loading.dart';
import 'package:seller_management/features/product/view/flash_deals/view/flash_details.dart';
import 'package:seller_management/features/product/view/home/view/home_init_page.dart';
import 'package:seller_management/features/product/view/home_page.dart';
import 'package:seller_management/features/product/view/orders/view/track_order_view.dart';
import 'package:seller_management/features/product/view/payment/view/after_payment_page.dart';
import 'package:seller_management/features/product/view/payment/view/payment_pages/bkash_webview_page.dart';
import 'package:seller_management/features/product/view/payment/view/payment_pages/nagad_webview_page.dart';
import 'package:seller_management/features/product/view/payment/view/payment_pages/payment_pages.dart';
import 'package:seller_management/features/product/view/products/view/product_details_view.dart';
import 'package:seller_management/features/product/view/products/view/product_view.dart';
import 'package:seller_management/features/product/view/route_animation.dart';
import 'package:seller_management/features/product/view/store/view/all_store.dart';
import 'package:seller_management/features/product/view/store/view/store_view.dart';
import 'package:seller_management/features/product/view/wishlist/view/wishlist_view.dart';
import 'package:seller_management/features/profile/view/profile_view.dart';
import 'package:seller_management/features/seller_info/view/seller_profile_view.dart';
import 'package:seller_management/features/settings/controller/settings_ctrl.dart';
import 'package:seller_management/features/settings/view/change_account_info.dart';
import 'package:seller_management/features/subscription/view/plan_update_view.dart';
import 'package:seller_management/features/subscription/view/subscription_view.dart';
import 'package:seller_management/features/support_ticket/view/ticket_list.dart';
import 'package:seller_management/features/support_ticket/view/tocket_view.dart';
import 'package:seller_management/features/total_balance/view/total_balance_view.dart';
import 'package:seller_management/features/voucher/view/voucher_view.dart';
import 'package:seller_management/features/withdraw/view/withdraw_now.dart';
import 'package:seller_management/features/withdraw/view/withdraw_view.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/navigation/navigation_root.dart';
import 'package:seller_management/routes/page/no_sub.dart';
import 'package:seller_management/routes/page/seller_banned.dart';
import 'package:seller_management/routes/routes.dart';
import '../features/chat/view/messages_tab_view.dart';
import '../features/language/view/language_view.dart';
import '../features/password_reset/view/otp_alert.dart';
import '../features/seller_info/view/store_info_update_view.dart';
import '../features/support_ticket/view/create_ticket.dart';

final routeListProvider = Provider.family
    .autoDispose<List<RouteBase>, GlobalKey<NavigatorState>>((ref, rootKey) {
  final GlobalKey<NavigatorState> shellNavigator =
  GlobalKey(debugLabel: 'shell');

  // final dash = ref.watch(dashBoardCtrlProvider);
  // .selectAsync((data) => data.seller.shop.isShopActive));

  final canRegister = ref.watch(
    settingsCtrlProvider.selectAsync((data) => data.config.registration),
  );

  final routeList = [
    GoRoute(
      path: RouteNames.splash.path,
      name: RouteNames.splash.name,
      pageBuilder: (context, state) =>
          NoTransitionPage(key: state.pageKey, child: const SplashView()),
    ),
    GoRoute(
      path: RouteNames.error.path,
      name: RouteNames.error.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: ErrorRoutePage(
          error: state.uri.queryParameters['e'],
        ),
      ),
    ),
    GoRoute(
      path: RouteNames.noInternet.path,
      name: RouteNames.noInternet.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const NoInternetPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.noSUbscription.path,
      name: RouteNames.noSUbscription.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        name: state.name,
        child: const NoSubPage(),
      ),
    ),
    GoRoute(
      path: RouteNames.maintenance.path,
      name: RouteNames.maintenance.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const MaintenancePage(),
      ),
    ),
    GoRoute(
      path: RouteNames.invalidPurchase.path,
      name: RouteNames.invalidPurchase.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const InvalidPurchasePage(),
      ),
    ),
    GoRoute(
      path: RouteNames.sellerBanned.path,
      name: RouteNames.sellerBanned.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const SellerBanned(),
      ),
    ),
    GoRoute(
      path: RouteNames.panelNotActive.path,
      name: RouteNames.panelNotActive.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const PanelInactive(),
      ),
    ),
    GoRoute(
      path: RouteNames.shopNotActive.path,
      name: RouteNames.shopNotActive.name,
      pageBuilder: (context, state) => NoTransitionPage(
        name: state.name,
        key: state.pageKey,
        child: const NotActiveStore(),
      ),
    ),
    GoRoute(
      path: RouteNames.login.path,
      name: RouteNames.login.name,
      pageBuilder: (context, state) => NoTransitionPage(
        key: state.pageKey,
        child: const LoginView(),
      ),
      routes: [
        GoRoute(
          path: RouteNames.signUp.path,
          name: RouteNames.signUp.name,
          redirect: (context, state) async {
            if (await canRegister) return null;
            return state.namedLocation(RouteNames.login.name);
          },
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const SignUpView(),
          ),
        ),
        GoRoute(
          parentNavigatorKey: rootKey,
          path: RouteNames.passwordReset.path,
          name: RouteNames.passwordReset.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PasswordResetView(),
          ),
        ),
        GoRoute(
          parentNavigatorKey: rootKey,
          path: RouteNames.otpScreen.path,
          name: RouteNames.otpScreen.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: OTPScreenView(),
          ),
        ),
        GoRoute(
          parentNavigatorKey: rootKey,
          path: RouteNames.newPassword.path,
          name: RouteNames.newPassword.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: NewPasswordView(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: RouteNames.afterPayment.path,
      name: RouteNames.afterPayment.name,
      pageBuilder: (context, state) {
        return AnimatePageRoute(
          name: state.name,
          key: state.pageKey,
          child: (animation) => const AfterPaymentView(),
        );
      },
    ),
    GoRoute(
      path: RouteNames.photoView.path,
      name: RouteNames.photoView.name,
      parentNavigatorKey: rootKey,
      pageBuilder: (context, state) => AnimatePageRoute(
        name: state.name,
        key: state.pageKey,
        fullscreen: true,
        child: (animation) {
          final extra = state.extra;
          if (extra is File) {
            return PhotoView.file(extra);
          }
          if (extra is String) {
            return extra.startsWith('assets')
                ? PhotoView.asset(extra)
                : PhotoView.network(extra);
          }
          return const ErrorView1(error: 'Invalid Image');
        },
      ),
    ),
    ShellRoute(
      navigatorKey: shellNavigator,
      builder: (context, state, child) =>
          NavigationRoot(child, key: state.pageKey),
      routes: [
        //! Home section
        GoRoute(
          path: RouteNames.home.path,
          name: RouteNames.home.name,
          pageBuilder: (context, state) => NoTransitionPage(
            key: state.pageKey,
            child: const DashBoardView(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.updatePass.path,
              name: RouteNames.updatePass.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const PasswordChangeView(),
              ),
            ),
            GoRoute(
                parentNavigatorKey: rootKey,
                path: RouteNames.withdraw.path,
                name: RouteNames.withdraw.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const WithdrawView(),
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootKey,
                    path: RouteNames.withdrawNow.path,
                    name: RouteNames.withdrawNow.name,
                    pageBuilder: (context, state) => NoTransitionPage(
                      key: state.pageKey,
                      child: const WithdrawNowView(),
                    ),
                  ),
                ]),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.voucher.path,
              name: RouteNames.voucher.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const VoucherView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.totalBalance.path,
              name: RouteNames.totalBalance.name,
              pageBuilder: (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const TotalBalanceView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.addressNew.path,
              name: RouteNames.addressNew.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const AddressView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.addAddress.path,
                  name: RouteNames.addAddress.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const AddAddressView1(),
                  ),
                ),
                      // GoRoute(
                      //   parentNavigatorKey: rootKey,
                      //   path: RouteNames.sellerChatDetails.path,
                      //   name: RouteNames.sellerChatDetails.name,
                      //   onExit: (context, s) {
                      //     HomeInitPage.route = '';
                      //     return true;
                      //   },
                      //   pageBuilder: (context, state) {
                      //     final id = state.pathParameters['id'];
                      //     return AnimatePageRoute(
                      //       name: state.name,
                      //       key: state.pageKey,
                      //       child: (animation) => CustomerChatView(id!),
                      //     );
                      //   },
                      // ),
                // GoRoute(
                //   parentNavigatorKey: rootKey,
                //   path: RouteNames.editAddressNew.path,
                //   name: RouteNames.editAddressNew.name,
                //   pageBuilder: (context, state) {
                //     final address = state.extra as BillingAddress;
                //     return AnimatePageRoute(
                //       name: state.name,
                //       key: state.pageKey,
                //       child: (animation) => AddAddressView1(address: address),
                //     );
                //   },
                // ),
              ],
            ),
          ],
        ),

        //! Order section
        GoRoute(
            path: RouteNames.order.path,
            name: RouteNames.order.name,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const OrderView(),
            ),
            routes: [
              GoRoute(
                parentNavigatorKey: rootKey,
                path: RouteNames.orderDetails.path,
                name: RouteNames.orderDetails.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: OrderDetailsView(state.pathParameters['id'] ?? ''),
                ),
              ),
              GoRoute(
                parentNavigatorKey: rootKey,
                path: RouteNames.trackOrder.path,
                name: RouteNames.trackOrder.name,
                pageBuilder: (context, state) => AnimatePageRoute(
                  name: state.name,
                  key: state.pageKey,
                  child: (animation) => TrackOrderView(
                    orderId: state.uri.queryParameters['id'],
                  ),
                ),
              ),
            ]),

        //! Product section
        GoRoute(
          path: RouteNames.product.path,
          name: RouteNames.product.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.productsView.path,
              name: RouteNames.productsView.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const ProductView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.productDetails.path,
                  name: RouteNames.productDetails.name,
                  pageBuilder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return AnimatePageRoute(
                      name: state.name,
                      key: state.pageKey,
                      child: (animation) => ProductDetailsView(
                        id: id,
                        key: ValueKey(id),
                        animation: animation,
                        campaignId: state.uri.queryParameters['cid']
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.brands.path,
              name: RouteNames.brands.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const BrandsView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.brandProducts.path,
                  name: RouteNames.brandProducts.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) =>
                        BrandProductsView(state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.addProduct.path,
              name: RouteNames.addProduct.name,
              pageBuilder: (context, state) {
                final extra = state.extra;
                if (extra is ProductModel?) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: AddProductView(editingProduct: extra),
                  );
                }
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const ErrorRoutePage(error: 'Invalid data'),
                );
              },
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.addDigitalProduct.path,
              name: RouteNames.addDigitalProduct.name,
              pageBuilder: (context, state) {
                final extra = state.extra;
                if (extra is ProductModel?) {
                  return NoTransitionPage(
                    key: state.pageKey,
                    child: AddDigitalProductView(extra),
                  );
                }
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const ErrorRoutePage(error: 'Invalid data'),
                );
              },
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.flashDeals.path,
              name: RouteNames.flashDeals.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const FlashDetailsView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.allStore.path,
              name: RouteNames.allStore.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const AllStoreView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.store.path,
                  name: RouteNames.store.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) =>
                        StoreView(state.pathParameters['id']!),
                  ),
                ),
              ],
             ),
            GoRoute(
              path: RouteNames.carts.path,
              name: RouteNames.carts.name,
              pageBuilder: (context, state) => NoTransitionPage(
                name: state.name,
                child: const CartsView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.checkoutPayment.path,
                  name: RouteNames.checkoutPayment.name,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:  const CheckoutPaymentView(),
                  ),
                ),
                GoRoute(
                  path: RouteNames.checkoutSummary.path,
                  name: RouteNames.checkoutSummary.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => const CheckoutSummeryView(),
                  ),
                ),
                GoRoute(
                  path: RouteNames.shippingDetails.path,
                  name: RouteNames.shippingDetails.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child: const CheckoutShippingView(),
                  ),
                ),
                GoRoute(
                  path: RouteNames.orderPlaced.path,
                  name: RouteNames.orderPlaced.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:  const OrderPlacedPage(),
                  ),
                ),
                GoRoute(
                  path: RouteNames.bkashPayment.path,
                  name: RouteNames.bkashPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => BkashWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.nagadPayment.path,
                  name: RouteNames.nagadPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:  NagadWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.flutterWavePayment.path,
                  name: RouteNames.flutterWavePayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:  FlutterWaveWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.instaMojoPayment.path,
                  name: RouteNames.instaMojoPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:  InstaMojoWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.paystackPayment.path,
                  name: RouteNames.paystackPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:  PaystackWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.mercadoPayment.path,
                  name: RouteNames.mercadoPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child: MercadoWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.payeerPayment.path,
                  name: RouteNames.payeerPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child:PayeerWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.paypalPayment.path,
                  name: RouteNames.paypalPayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child: PaypalWebviewPage(
                      url: state.extra as String,
                    ),
                  ),
                ),
                GoRoute(
                  path: RouteNames.stripePayment.path,
                  name: RouteNames.stripePayment.name,
                  parentNavigatorKey: rootKey,
                  pageBuilder: (context, state) => NoTransitionPage(
                    name: state.name,
                    key: state.pageKey,
                    child: StripeWebviewPage(state.extra as String),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.categories.path,
              name: RouteNames.categories.name,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => const CategoriesView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.categoryProducts1.path,
                  name: RouteNames.categoryProducts1.name,
                  pageBuilder: (context, state) => AnimatePageRoute(
                    name: state.name,
                    key: state.pageKey,
                    child: (animation) => CategoriesProductsView(
                      state.pathParameters['id']!,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),


  //! Massage section
        GoRoute(
          path: RouteNames.messages.path,
          name: RouteNames.messages.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MessagesTabView(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.customerChats.path,
              name: RouteNames.customerChats.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CustomerChatListView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.customerChat.path,
                  name: RouteNames.customerChat.name,
                  onExit: (c, s) {
                    DashInitPage.route = '';
                    return true;
                  },
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: CustomerChatView(id: state.pathParameters['id']!),
                  ),
                ),
              ],
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.tickets.path,
              name: RouteNames.tickets.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: TicketListView(),
              ),
              routes: [
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.ticket.path,
                  name: RouteNames.ticket.name,
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: TicketView(state.pathParameters['id']!),
                  ),
                ),
                GoRoute(
                  parentNavigatorKey: rootKey,
                  path: RouteNames.createTicket.path,
                  name: RouteNames.createTicket.name,
                  pageBuilder: (context, state) => const NoTransitionPage(
                    child: CreateTicketView(),
                  ),
                ),
              ],
            ),
          ],
        ),
        //! Profile section
        GoRoute(
          path: RouteNames.profile.path,
          name: RouteNames.profile.name,
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileView(),
          ),
          routes: [
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.accountSettings.path,
              name: RouteNames.accountSettings.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: SellerProfileView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.changeAccount.path,
              name: RouteNames.changeAccount.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ChangeAccountInformationView(),
              ),
            ),
            GoRoute(
                parentNavigatorKey: rootKey,
                path: RouteNames.subscription.path,
                name: RouteNames.subscription.name,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: SubscriptionView(),
                ),
                routes: [
                  GoRoute(
                    parentNavigatorKey: rootKey,
                    path: RouteNames.planUpdate.path,
                    name: RouteNames.planUpdate.name,
                    pageBuilder: (context, state) => const NoTransitionPage(
                      child: PlanUpdateView(),
                    ),
                  ),
                ]),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.storeInformation.path,
              name: RouteNames.storeInformation.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: StoreInfoUpdateView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.language.path,
              name: RouteNames.language.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: LanguageView(),
              ),
            ),
            GoRoute(
              parentNavigatorKey: rootKey,
              path: RouteNames.currency.path,
              name: RouteNames.currency.name,
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CurrencyView(),
              ),
            ),
          ],
        ),
        ///! wishlist Section
        GoRoute(
          path: RouteNames.wishlist.path,
          name: RouteNames.wishlist.name,
          pageBuilder: (context, state) => NoTransitionPage(
            name: state.name,
            key: state.pageKey,
            child: const WishListView(),
          ),
        ),

        //! Campaign section
        GoRoute(
          path: RouteNames.campaigns.path,
          name: RouteNames.campaigns.name,
          pageBuilder: (context, state) => NoTransitionPage(
              name: state.name,
              key: state.pageKey,
              child: const CampaignsView()),
          routes: [
            GoRoute(
              path: RouteNames.campaignDetails.path,
              name: RouteNames.campaignDetails.name,
              parentNavigatorKey: rootKey,
              pageBuilder: (context, state) => AnimatePageRoute(
                name: state.name,
                key: state.pageKey,
                child: (animation) => CampaignDetailsView(
                  state.pathParameters['id']!,
                ),
              ),
            ),
          ],
        ),
      ],

    ),
  ];
  return routeList;
});

Future<bool> showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return const ExitDialog();
    },
  );

  return result ?? false;
}
