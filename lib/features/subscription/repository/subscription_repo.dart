import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class SubscriptionRepo extends Repo {
  FutureReport<BaseResponse<List<SubscriptionPlan>>> subscriptionPlan() async {
    final data = await rdb.getSubscriptionPlan();
    return data;
  }

  FutureReport<BaseResponse<PagedItem<SubscriptionInfo>>> subscriptionList([
    DateTimeRange? range,
  ]) async {
    final data = await rdb.getSubscriptionList(date: range.toQuery());
    return data;
  }

  FutureReport<BaseResponse<PagedItem<SubscriptionInfo>>> subscriptionFromUrl(
    String url,
  ) async {
    final data = await rdb.getSubscriptionListFromUrl(url);
    return data;
  }

  FutureReport<BaseResponse<String>> renewPlan(String uid) async {
    final data = await rdb.renewSubscription(uid);
    return data;
  }

  FutureReport<BaseResponse<String>> upgradePlan(String uid) async {
    final data = await rdb.subscriptionUpdate(uid);
    return data;
  }

  FutureReport<BaseResponse<String>> subscribePlan(String uid) async {
    final data = await rdb.subscribeToPlan(uid);
    return data;
  }
}
