class Endpoints1 {
  Endpoints1._();

  static String? testURL;

  // base url
  static const String baseUrl = "https://cartuser.kodepixel.com";

  static String api = '${testURL ?? baseUrl}/api/seller/v1/api';

  // connectTimeout
  static const Duration connectionTimeout = Duration(milliseconds: 25000);

  // receiveTimeout
  static const Duration receiveTimeout = Duration(milliseconds: 25000);
  static const String register = '/register';
  static const String login = '/login';
  static const String ticket = '/ticket/list';
  static String ticketMessage(String id) => '/ticket/$id/messages';
  static const String ticketStore = '/ticket/store';
  static const String ticketReply = '/ticket/reply';
  static const String subscriptionPlan = '/subscription/plan';
  static const String subscriptionList = '/subscription/list';
  static const String subscriptionUpdate = '/subscription/update';
  static const String subscribe = '/subscription/subscribe';
  static String renewSubscription(String id) => '/subscription/renew/$id';
  static const String dashboard = '/dashboard';
  static const String shop = '/shop';
  static const String transactions = '/transactions';
  static const String shopUpdate = '/shop/update';
  static const String profileUpdate = '/profile/update';
  static const String passwordUpdate = '/password/update';
  static const String verifyEmail = '/verify/email';
  static const String verifyOTP = '/verify/otp/code';
  static const String resetPassword = '/password/reset';
  static const String logout = '/logout';
  static const String config = '/config';
  static const String authConfig = '/auth/config';
  static const String fileDownload = '/ticket/file/download';

  /// digital

  static const String digitalOrder = '/order/digital/list';
  static const String digitalProductStore = '/product/digital/store';
  static const String digitalProductUpdate = '/product/digital/update';
  static const String digitalProduct = '/product/digital/list';
  static const String digitalProductAttributeStore =
      '/product/digital/attribute/store';
  static const String attributeValueStore =
      '/product/digital/attribute/value/store';
  static String attributeDelete(String id) =>
      '/product/digital/attribute/delete/$id';
  static String attributeValueDelete(String id) =>
      '/product/digital/attribute/value/delete/$id';

  /// physical

  static const String physicalOrder = '/order/physical/list';
  static const String physicalProductStore = '/product/store';
  static const String physicalProductUpdate = '/product/update';
  static const String physicalProduct = '/product/physical/list';

  static String orderDetails(String id) => '/order/details/$id';
  static const String orderStatusUpdate = '/order/status/update';
  static String productDelete(String id) => '/product/delete/$id';
  static String productPermanentDelete(String id) =>
      '/product/permanent/delete/$id';
  static String productRestore(String id) => '/product/restore/$id';
  static String productDetails(String id) => '/product/details/$id';
  static String galleryDelete(String id) => '/product/gallery/delete/$id';
  static const String withdrawMethods = '/withdraw/methods';
  static const String withdrawList = '/withdraw/list';
  static const String withdrawRequest = '/withdraw/request';
  static const String withdrawStore = '/withdraw/store';
  static const String campaign = '/campaigns';

  static const String chatList = '/customer/chat/list';
  static String chatMessage(String id) => '/customer/chat/messages/$id';
  static const String chatSendMessage = '/customer/chat/send/message';

  static const String updateFCM = '/update/fcm-token';
}