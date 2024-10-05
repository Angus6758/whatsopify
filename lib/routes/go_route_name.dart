import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteNames {
  const RouteNames._();
  static const RouteName onboard = RouteName('/onboarding');
  static const RouteName shopNotActive = RouteName('/not_active');
  static const RouteName login = RouteName('/login');

  static const RouteName splash = RouteName('/splash');
  static const RouteName error = RouteName('/oops');
  static const RouteName notFound = RouteName('/404');
  static const RouteName noInternet = RouteName('/no_internet');
  static const RouteName maintenance = RouteName('/maintenance');
  static const RouteName invalidPurchase = RouteName('/invalid_purchase');
  static const RouteName panelNotActive = RouteName('/panel-not-active');
  static const RouteName noSUbscription = RouteName('/no-subscription');
 // static const RouteName home = RouteName('/home');
  static const RouteName home = RouteName('/product');
  static const RouteName tools = RouteName('/tools');
  static const RouteName data = RouteName('/data');
  static const RouteName messages = RouteName('/massages');
  static const RouteName profile = RouteName('/profile');
  static const RouteName order = RouteName('/order');
  //static const RouteName product = RouteName('/product');
  static const RouteName product = RouteName('/home');

  //SUB ROUTE
  static const RouteName signUp = RouteName('sign-up');
  static const RouteName addProduct = RouteName('add-product');
  static const RouteName updatePass = RouteName('update-pass');
 // static const RouteName productDetails = RouteName('product-details/:id');
  static const RouteName addDigitalProduct = RouteName('add-digital-product');
  static const RouteName voucher = RouteName('voucher');
  static const RouteName orderDetails = RouteName('order-details/:id');
  static const RouteName tickets = RouteName('tickets');
  static const RouteName ticket = RouteName('ticket/:id');
  static const RouteName customerChats = RouteName('customer/chats');
  static const RouteName customerChat = RouteName('chat/:id');
  static const RouteName withdraw = RouteName('withdraw');
  static const RouteName withdrawNow = RouteName('withdraw-now');
  static const RouteName totalBalance = RouteName('total-balance');
  static const RouteName accountSettings = RouteName('account-settings');
  static const RouteName changeAccount = RouteName('change-account');
  static const RouteName storeInformation = RouteName('store-information');
  static const RouteName subscription = RouteName('subscription');
  static const RouteName planUpdate = RouteName('plan-update');
  static const RouteName campaign = RouteName('campaign');
  static const RouteName editCampaign = RouteName('edit-campaign');
  static const RouteName dashLoading = RouteName('dash-loading');
  static const RouteName createTicket = RouteName('create-ticket');
  static const RouteName passwordReset = RouteName('password-reset');
  static const RouteName otpScreen = RouteName('otp-screen');
  static const RouteName newPassword = RouteName('new-password');
  static const RouteName language = RouteName('language');
  static const RouteName currency = RouteName('currency');
  static const RouteName sellerBanned = RouteName('/seller-banned');





  //NEW SCREEN
  static const RouteName categories = RouteName('categories');
  static String categoryProducts(String uid) => '/category/products/$uid';
  static const RouteName categoryProducts1 = RouteName('cat/:id');
  //static String campaignDetails1(String uid) => '/campaigns/$uid';
  static String sellerChatDetailsNew(String id) => '/seller/chat/messages/$id';
  static const RouteName store = RouteName('store/:id');
  static const RouteName extraPage = RouteName('extra/:pageId');
  static String sellerChatDetails4(String id) => '/seller/chat/messages/$id';
  static const RouteName brands = RouteName('brands');
  static String brandProducts1(String uid) => '/brand/products/$uid';
  static const RouteName carts = RouteName('carts');
  static const RouteName flashDeals = RouteName('flash-deals');
 // static const RouteName productsView = RouteName('products');
 // static const RouteName allProductsView = RouteName('all-products');
  static const RouteName productDetails1 = RouteName('p/:id');
  static const RouteName allStore = RouteName('all-store');
 // static const RouteName shippingDetails = RouteName('shipping_details');
  static const RouteName afterPayment = RouteName('/after-payment');
 // static const RouteName checkoutPayment = RouteName('shipping_payment');
 // static const RouteName checkoutSummary = RouteName('checkout-summary');
 // static const RouteName orderPlaced = RouteName('order_placed');
  static const RouteName trackOrder = RouteName('track-order');
  static const RouteName address = RouteName('address');
  static const RouteName userEditing = RouteName('user_profile_edit');
  static const RouteName brandProducts = RouteName('b/:id');

  static const RouteName notifications = RouteName('notification');
  static const RouteName orders = RouteName('orders');
  static const RouteName editAddress = RouteName('edit-address');
  static const RouteName campaigns = RouteName('/campaigns');
  static const RouteName region = RouteName('region');
  static const RouteName notAuthorize = RouteName('/not_authorize');
  // subRoute of cart
  static const RouteName shippingDetails = RouteName('shipping_details');
  // subRoute of shippingDetails
  static const RouteName checkoutPayment = RouteName('shipping_payment');
  static const RouteName checkoutSummary = RouteName('checkout-summary');
  static const RouteName orderPlaced = RouteName('order_placed');

  static const RouteName bkashPayment = RouteName('payment/bkash');
  static const RouteName paypalPayment = RouteName('payment/paypal');
  static const RouteName instaMojoPayment = RouteName('payment/instamojo');
  static const RouteName paystackPayment = RouteName('payment/paystack');
  static const RouteName sslCommerzPayment = RouteName('payment/sslcommerz');
  static const RouteName nagadPayment = RouteName('payment/nagad');
  static const RouteName flutterWavePayment = RouteName('payment/flutterwave');
  static const RouteName stripePayment = RouteName('payment/stripe');
  static const RouteName mercadoPayment = RouteName('payment/mercado');
  static const RouteName payeerPayment = RouteName('payment/payeer');
  // static const RouteName search = RouteName('searched');
  static const RouteName productsView = RouteName('products');
  static const RouteName allProductsView = RouteName('all-products');
  static const RouteName supportTicket = RouteName('support_ticket');
  static const RouteName wishlist = RouteName('/wishlist');
  static const RouteName sellerChatDetails =
  RouteName('seller-chat-details/:id');
  static const RouteName addAddress13 = RouteName('add-address');
  static const RouteName photoView = RouteName('/photo-view');
  static const RouteName campaignDetails = RouteName('camp/:id');
  static const RouteName register = RouteName('register');
  static const RouteName addressNew = RouteName('address');
  static const RouteName addAddress = RouteName('add-address');
  static const RouteName editAddressNew = RouteName('edit-address');

  /// Must pass {'id':product.id} path parameter
  ///
  /// Must pass {'isRegular':product or digital} query param
  ///
  /// pass {'cat':category.id} query param
  ///
  /// pass {'brand':brand.id} query param
  ///
  /// pass {'type':deal|new|best|digital} query param
  static const RouteName productDetails = RouteName('p/:id');

  static const List<RouteName> nestedRoutes = [
    product,
    order,
    home,
    messages,
    profile
  ];
}

class RouteName {
  const RouteName(this.path, {String? name}) : _name = name;

  final String path;
  final String? _name;

  RouteName addQuery(Map<String, String> query) {
    final encoded = {
      for (final q in query.entries) q.key: Uri.encodeComponent(q.value)
    };

    final pathWithQuery = Uri(path: path, queryParameters: encoded).toString();
    return RouteName(pathWithQuery, name: _name);
  }

  String get name => _name ?? path.replaceFirst('/', '').replaceAll('/', '_');

  Future<T?> push<T extends Object?>(BuildContext context, {Object? extra}) =>
      context.push(path, extra: extra);

  Future<T?> pushNamed<T extends Object?>(
    BuildContext context, {
    Map<String, String> pathParams = const <String, String>{},
    Map<String, String> query = const <String, String>{},
    Object? extra,
  }) {
    return context.pushNamed(
      name,
      extra: extra,
      pathParameters: pathParams,
      queryParameters: query,
    );
  }

  void go(BuildContext context, {Object? extra}) =>
      context.go(path, extra: extra);

  void goNamed(
    BuildContext context, {
    Map<String, String> pathParams = const <String, String>{},
    Map<String, String> query = const <String, String>{},
    Object? extra,
  }) =>
      context.goNamed(
        name,
        pathParameters: pathParams,
        queryParameters: query,
        extra: extra,
      );
}
