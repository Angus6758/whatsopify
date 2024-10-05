import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class OrderRepository extends Repo {
  FutureResponse<PagedItem<OrderModel>> getPhysicalOrder({
    DateTimeRange? dateRange,
    String search = '',
    String status = '',
  }) async {
    final data = await rdb.getPhysicalOrder(
      dateRange: dateRange,
      search: search,
      status: status,
    );
    return data;
  }

  FutureResponse<PagedItem<OrderModel>> getOrderFromUrl(String url) async {
    final data = await rdb.orderFromUrl(url);
    return data;
  }

  FutureResponse<PagedItem<OrderModel>> getDigitalOrder({
    // DateTimeRange? dateRange,
    String search = '',
    String status = '',
  }) async {
    final data = await rdb.getDigitalOrder(
      // dateRange: dateRange,
      search: search,
      status: status,
    );
    return data;
  }

  FutureResponse<OrderModel> getOrderDetails(String id) async {
    final data = await rdb.getOrderDetails(id);
    return data;
  }

  FutureResponse<String> updateOrderStatus(
      String orderId, String status, String deliveryNote) async {
    final data = await rdb.orderStatusUpdate(
      orderId: orderId,
      status: status,
      note: deliveryNote,
    );
    return data;
  }
}
