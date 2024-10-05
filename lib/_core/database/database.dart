import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

abstract class Database {
  FutureResponse<String> login({
    required String username,
    required String password,
  });

  FutureResponse<String> register(QMap formData);

  logout();

  config();

  authConfig();

  ticketList([String? url]);

  ticketMassage(String id);

  ticketReply({
    required String ticketNumber,
    required String message,
    required List<File> files,
  });

  getDashboard();

  getTransactionList({String date, String search});
  transactionsFromUrl(String url);

  getStoreInfo();

  updateStoreInfo(QMap formData, Map<String, File> partFiles);

  updateSellerProfile(QMap formData, File file);

  getDownload({
    required String id,
    required String massageId,
    required String ticketNo,
  });

  getSubscriptionPlan();

  getSubscriptionList({String date = ''});
  getSubscriptionListFromUrl(String url);

  renewSubscription(String id);

  subscribeToPlan(String id);

  subscriptionUpdate(String id);

  getDigitalProduct(String status, String search);

  getPhysicalProduct(String search, String status);
  getProductByUrl(String url);

  storeDigitalProduct(QMap formData);
  storePhysicalProduct(QMap formData);
  updatePhysicalProduct(String id, QMap formData);

  updateDigitalProduct(String id, QMap formData);

  productDelete(String id);
  deletePermanently(String id);
  deleteGalleryImage(String id);

  productRestore(String id);
  productDetails(String id);
  digitalAttributeStore({required String uid, required QMap formData});

  attributeDelete(String id);
  attributeValueDelete(String id);

  productAttributeValueStore({required String uid, required String text});

  getPhysicalOrder({DateTimeRange? dateRange, String search, String status});

  getDigitalOrder({DateTimeRange? dateRange, String search, String status});
  orderFromUrl(String url);

  getOrderDetails(String id);

  orderStatusUpdate({
    required String orderId,
    required String status,
    String note,
  });

  createTicket(QMap formData);

  updatePassword(QMap formData);
  verifyEmail(String email);
  verifyOTP(QMap formData);
  resetPassword(QMap formData);

  withdrawMethods();
  withdrawList(String search, String date);
  withdrawListFromUrl(String url);
  requestWithdraw(String method, String amount);
  storeWithdraw(String id, QMap formData);

  getCampaign([String? url]);

  //! chat
  fetchChatList();
  fetchChatMessage(String id);
  sendChatMessage(QMap formData);

  //! fcm
  updateFCMToken(String token);
}
