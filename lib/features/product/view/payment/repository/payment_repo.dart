import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/routes/go_route_name.dart';

class PaymentRepo {
  PaymentRepo();

  Future<void> confirmPayment(
    BuildContext context,
    Map<String, dynamic> body,
    String callBack, {
    String method = 'POST',
  }) async {
    try {
      final dio = Dio()..interceptors.add(talk.dioLogger);

      final options = Options(
        method: method,
        headers: {'Accept': 'application/json'},
      );

      final response =
          await dio.request(callBack, data: body, options: options);

      final res = json.decode(response.data);

      if (!context.mounted) {
        Toaster.showInfo('Unknown error\n${res['message']}');
        return;
      }

      RouteNames.afterPayment.goNamed(
        context,
        query: {'status': res['status'] ? 's' : 'f'},
      );
    } on DioException catch (e) {
      Toaster.showError(e.response?.data['message']);
    }
  }
}
