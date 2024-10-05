import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@Singleton(order: 5)
class RemoteDB extends Database with ApiHandler {
  final _dio = locate<DioClient>();

  FutureResponse<PagedItem<T>> pagedItemFromUrl<T>(
    String url,
    String key,
    T Function(QMap map) mapper,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => PagedItem<T>.fromMap(map[key], mapper),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<({String msg, Seller seller})>> updateStoreInfo(
    QMap formData,
    Map<String, File> partFiles,
  ) async {
    final body = formData;
    for (var MapEntry(:key, :value) in partFiles.entries) {
      body[key] = await MultipartFile.fromFile(value.path);
    }

    final data = await apiCallHandler(
      call: () => _dio.post(Endpoints1.shopUpdate, data: body),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => (
          msg: map['message'].toString(),
          seller: Seller.fromMap(map['seller'])
        ),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<({String msg, Seller seller})>> updateSellerProfile(
      QMap formData, File? file) async {
    final body = {...formData};

    if (file != null) {
      body['image'] = await MultipartFile.fromFile(file.path);
    }

    final data = await apiCallHandler(
      call: () => _dio.post(Endpoints1.profileUpdate, data: body),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => (
          msg: map['message'].toString(),
          seller: Seller.fromMap(map['seller'])
        ),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<({String msg, WithdrawData data})>> requestWithdraw(
    String method,
    String amount,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints1.withdrawRequest,
        data: {'id': method, 'amount': amount},
      ),
      mapper: (map) => (
        msg: '${map['message']}',
        data: WithdrawData.fromMap(map['withdraw'])
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> storeDigitalProduct(QMap formData) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints1.digitalProductStore,
        data: formData,
      ),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> updateDigitalProduct(
    String id,
    QMap formData,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints1.digitalProductUpdate,
        data: {'uid': id, ...formData},
      ),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> storePhysicalProduct(QMap formData) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints1.physicalProductStore,
        data: formData,
      ),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> updatePhysicalProduct(
    String id,
    QMap formData,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(
        Endpoints1.physicalProductUpdate,
        data: {'uid': id, ...formData},
      ),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<ProductModel>> attributeDelete(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.attributeDelete(id)),
      mapper: (map) => ProductModel.fromMap(map['product']),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<ProductModel>> attributeValueDelete(
      String id) async {
    final data = await apiCallHandler(
      call: () => _dio.get(Endpoints1.attributeValueDelete(id)),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => ProductModel.fromMap(
          map['product'],
        ),
      ),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<AuthConfig>> authConfig() async {
    final data = await apiCallHandler(
      call: () => _dio.get(Endpoints1.authConfig),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => AuthConfig.fromMap(map),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<AppSettings>> config() async {
    final data = await apiCallHandler(
      call: () => _dio.get(Endpoints1.config),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => AppSettings.fromMap(map),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<TicketData>> createTicket(QMap formData) async {
    final data = await apiCallHandler(
      call: () => _dio.post(Endpoints1.ticketStore, data: formData),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => TicketData.fromMap(map),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> verifyEmail(String email) async {
    final data = await apiCallHandler(
      call: () => _dio.post(Endpoints1.verifyEmail, data: {'email': email}),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => (map['message'] as String?) ?? 'Reset code sent your email',
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> verifyOTP(QMap formData) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.verifyOTP, data: formData),
      mapper: (map) =>
          (map['message'] as String?) ?? 'Reset code sent your email',
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> resetPassword(QMap formData) async {
    final data = await apiCallHandler(
      call: () => _dio.post(Endpoints1.resetPassword, data: formData),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => (map['message'] as String?) ?? 'Password Change Successfully',
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<CampaignModel>>> getCampaign([
    String? url,
  ]) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url ?? Endpoints1.campaign),
      mapper: (map) =>
          PagedItem.fromMap(map['campaigns'], CampaignModel.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<Dashboard>> getDashboard() async {
    final data = await apiCallHandler(
      call: () => _dio.get(Endpoints1.dashboard),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => Dashboard.fromMap(map),
      ),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<OrderModel>>> getDigitalOrder({
    DateTimeRange? dateRange,
    String search = '',
    String status = '',
  }) async {
    final start = dateRange?.start.formatDate('yyyy-MM-dd');
    final end = dateRange?.end.formatDate('yyyy-MM-dd');
    final date = dateRange == null ? '' : '$start+to+$end';
    final data = await apiCallHandlerBase(
      call: () => _dio.get(
        '${Endpoints1.digitalOrder}?search=$search&date=$date&status=$status',
      ),
      mapper: (map) => PagedItem.fromMap(map['orders'], OrderModel.fromMap),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<ProductModel>>> getDigitalProduct(
    String status,
    String search,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(
        Endpoints1.digitalProduct,
        queryParameters: {'status': status, 'search': search},
      ),
      mapper: (map) => PagedItem.fromMap(map['products'], ProductModel.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> getDownload({
    required String id,
    required String massageId,
    required String ticketNo,
  }) async {
    final body = {
      'id': id,
      'support_message_id': massageId,
      'ticket_number': ticketNo,
    };

    final data = await apiCallHandler(
      call: () => _dio.post(Endpoints1.fileDownload, data: body),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => map['url'] as String,
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<OrderModel>> getOrderDetails(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.orderDetails(id)),
      mapper: (map) => OrderModel.fromMap(map['order']),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<OrderModel>>> getPhysicalOrder({
    DateTimeRange? dateRange,
    String search = '',
    String status = '',
  }) async {
    final start = dateRange?.start.formatDate('yyyy-MM-dd');
    final end = dateRange?.end.formatDate('yyyy-MM-dd');
    final date = dateRange == null ? '' : '$start+to+$end';

    final data = await apiCallHandlerBase(
      call: () => _dio.get(
        '${Endpoints1.physicalOrder}?search=$search&date=$date&status=$status',
      ),
      mapper: (map) => PagedItem.fromMap(map['orders'], OrderModel.fromMap),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<OrderModel>>> orderFromUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => PagedItem.fromMap(map['orders'], OrderModel.fromMap),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<ProductModel>>> getPhysicalProduct(
    String search,
    String status,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(
        Endpoints1.physicalProduct,
        queryParameters: {'status': status, 'search': search},
      ),
      mapper: (map) => PagedItem.fromMap(map['products'], ProductModel.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<ProductModel>>> getProductByUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => PagedItem.fromMap(map['products'], ProductModel.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<Seller>> getStoreInfo() async {
    final data = await apiCallHandler(
      call: () => _dio.get(Endpoints1.shop),
      mapper: (map) => BaseResponse.fromMap(
        map,
        (map) => Seller.fromMap(map['seller']),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<SubscriptionInfo>>> getSubscriptionList({
    String date = '',
  }) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get('${Endpoints1.subscriptionList}?date=$date'),
      mapper: (map) =>
          PagedItem.fromMap(map['subscriptions'], SubscriptionInfo.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<SubscriptionInfo>>>
      getSubscriptionListFromUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) =>
          PagedItem.fromMap(map['subscriptions'], SubscriptionInfo.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<List<SubscriptionPlan>>>
      getSubscriptionPlan() async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.subscriptionPlan),
      mapper: (map) => List<SubscriptionPlan>.from(
        map['plans']?['data']?.map((x) => SubscriptionPlan.fromMap(x)) ?? [],
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<TransactionData>>> getTransactionList({
    String date = '',
    String search = '',
  }) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(
        '${Endpoints1.transactions}?search=$search&date=$date',
      ),
      mapper: (map) => PagedItem<TransactionData>.fromMap(
        map['transaction'],
        (map) => TransactionData.fromMap(map),
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<TransactionData>>> transactionsFromUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) =>
          PagedItem.fromMap(map['transaction'], TransactionData.fromMap),
    );
    return data;
  }

  @override
  FutureResponse<String> login({
    required String username,
    required String password,
  }) async {
    final body = {'username': username, 'password': password};

    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.login, data: body),
      mapper: (map) => (map)['access_token'] as String,
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<String>> orderStatusUpdate({
    required String orderId,
    required String status,
    String note = '',
  }) async {
    final body = {
      'order_number': orderId,
      'status': status,
      'delivery_note': note,
    };

    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.orderStatusUpdate, data: body),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<ProductModel>> digitalAttributeStore({
    required String uid,
    required QMap formData,
  }) async {
    final body = {'uid': uid, ...formData};

    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.digitalProductAttributeStore, data: body),
      mapper: (map) => ProductModel.fromMap(map['product']),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<ProductModel>> productAttributeValueStore({
    required String uid,
    required String text,
  }) async {
    final body = {
      'uid': uid,
      'text': text,
    };

    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.attributeValueStore, data: body),
      mapper: (map) => ProductModel.fromMap(map['product']),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<String>> deleteGalleryImage(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.galleryDelete(id)),
      mapper: (map) =>
          map['message']?.toString() ?? 'Image deleted successfully',
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<String>> productDelete(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.productDelete(id)),
      mapper: (map) =>
          map['message']?.toString() ?? 'Product deleted successfully',
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<String>> deletePermanently(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.productPermanentDelete(id)),
      mapper: (map) =>
          map['message']?.toString() ?? 'Product deleted successfully',
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<String>> productRestore(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.productRestore(id)),
      mapper: (map) =>
          map['message']?.toString() ?? 'Product restored successfully',
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<ProductModel>> productDetails(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.productDetails(id)),
      mapper: (map) => ProductModel.fromMap(map['product']),
    );

    return data;
  }

  @override
  FutureResponse<String> register(QMap formData) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.register, data: formData),
      mapper: (map) => (map)['access_token'] as String,
    );
    return data;
  }

  @override
  FutureResponse<String> logout() async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.logout),
      mapper: (map) => map['message']?.toString() ?? 'Logout Successfully',
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<String>> renewSubscription(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.renewSubscription(id)),
      mapper: (map) => (map['message'] as String?) ?? 'Subscription Renewed',
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> storeWithdraw(
    String id,
    QMap formData,
  ) async {
    final body = {'id': id, ...formData};
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.withdrawStore, data: body),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> subscribeToPlan(String id) async {
    Logger(id);
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.subscribe, data: {'id': id}),
      mapper: (map) => (map['message'] as String?) ?? 'Subscribed',
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> subscriptionUpdate(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.subscriptionUpdate, data: {'id': id}),
      mapper: (map) => (map['message'] as String?) ?? 'Subscription Updated',
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<SupportTicket>>> ticketList(
      [String? url]) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url ?? Endpoints1.ticket),
      mapper: (map) => PagedItem.fromMap(map['tickets'], SupportTicket.fromMap),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<TicketData>> ticketMassage(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.ticketMessage(id)),
      mapper: (map) => TicketData.fromMap(map),
    );
    return data;
  }

  @override
  FutureReport<BaseResponse<TicketData>> ticketReply({
    required String ticketNumber,
    required String message,
    required List<File> files,
  }) async {
    final parts = <MultipartFile>[];
    for (var file in files) {
      parts.add(
        await MultipartFile.fromFile(file.path),
      );
    }
    final body = {
      'ticket_number': ticketNumber,
      'message': message,
      'file': parts,
    };

    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.ticketReply, data: body),
      mapper: (map) => TicketData.fromMap(map),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<String>> updatePassword(QMap formData) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.passwordUpdate, data: formData),
      mapper: (map) => (map['message'] as String?) ?? 'Password Updated',
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<WithdrawData>>> withdrawList(
    String search,
    String date,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(
        '${Endpoints1.withdrawList}?search=$search&date=$date',
      ),
      mapper: (map) =>
          PagedItem.fromMap(map['withdraw_list'], WithdrawData.fromMap),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<PagedItem<WithdrawData>>> withdrawListFromUrl(
    String url,
  ) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(url),
      mapper: (map) => PagedItem<WithdrawData>.fromMap(
        map['withdraw_list'],
        WithdrawData.fromMap,
      ),
    );

    return data;
  }

  @override
  FutureReport<BaseResponse<List<WithdrawMethod>>> withdrawMethods() async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.withdrawMethods),
      mapper: (map) => List<WithdrawMethod>.from(
        map['methods']?['data']?.map((x) => WithdrawMethod.fromMap(x)) ?? [],
      ),
    );

    return data;
  }

  //! chat

  @override
  FutureResponse<List<Customer>> fetchChatList() async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.chatList),
      mapper: (map) => List<Customer>.from(map['customers']?['data'].map(
        (x) => Customer.fromMap(x),
      )),
    );

    return data;
  }

  @override
  FutureResponse<CustomerMessageData> fetchChatMessage(String id) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.get(Endpoints1.chatMessage(id)),
      mapper: (map) => CustomerMessageData.fromMap(map),
    );

    return data;
  }

  @override
  FutureResponse<String> sendChatMessage(QMap formData) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.chatSendMessage, data: formData),
      mapper: (map) => map['message'].toString(),
    );

    return data;
  }

  // fcm

  @override
  FutureResponse<String> updateFCMToken(String token) async {
    final data = await apiCallHandlerBase(
      call: () => _dio.post(Endpoints1.updateFCM, data: {'fcm_token': token}),
      mapper: (map) => '${map['message']}',
    );
    return data;
  }
}
