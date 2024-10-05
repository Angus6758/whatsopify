import 'dart:io';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@Singleton(order: 2)
class LocalDB extends LocalStorageBase implements Database {
  final _noImplementationNeeded =
      UnsupportedError('No Implementation Needed in LocalDB');

  @override
  attributeDelete(String id) {
    throw _noImplementationNeeded;
  }

  @override
  attributeValueDelete(String id) {
    throw _noImplementationNeeded;
  }

  @override
  AuthConfig? authConfig([AuthConfig? settings]) {
    const key = DBKeys.authConfig;
    if (settings != null) {
      save(key, settings.toMap());
      return settings;
    }
    final config = getMap(key);
    if (config == null) return null;

    return AuthConfig.fromMap(config);
  }

  @override
  AppSettings? config([AppSettings? settings]) {
    const key = DBKeys.config;
    if (settings != null) {
      save(key, settings.toJson());
      return settings;
    }
    final config = getMap(key);

    if (config == null) return null;

    return AppSettings.fromMap(config);
  }

  @override
  createTicket(QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  deleteGalleryImage(String id) {
    throw _noImplementationNeeded;
  }

  @override
  deletePermanently(String id) {
    throw _noImplementationNeeded;
  }

  @override
  digitalAttributeStore({required String uid, required QMap formData}) {
    throw _noImplementationNeeded;
  }

  @override
  getCampaign([String? url]) {
    throw _noImplementationNeeded;
  }

  @override
  getDashboard() {
    throw _noImplementationNeeded;
  }

  @override
  getDigitalOrder({
    DateTimeRange? dateRange,
    String? search,
    String? status,
  }) {
    throw _noImplementationNeeded;
  }

  @override
  getDigitalProduct(String status, String search) {
    throw _noImplementationNeeded;
  }

  @override
  getDownload({
    required String id,
    required String massageId,
    required String ticketNo,
  }) {
    throw _noImplementationNeeded;
  }

  @override
  getOrderDetails(String id) {
    throw _noImplementationNeeded;
  }

  @override
  getPhysicalOrder({
    DateTimeRange? dateRange,
    String? search,
    String? status,
  }) {
    throw _noImplementationNeeded;
  }

  @override
  getPhysicalProduct(String search, String status) {
    throw _noImplementationNeeded;
  }

  @override
  getProductByUrl(String url) {
    throw _noImplementationNeeded;
  }

  @override
  getStoreInfo() {
    throw _noImplementationNeeded;
  }

  @override
  getSubscriptionList({String date = ''}) {
    throw _noImplementationNeeded;
  }

  @override
  getSubscriptionListFromUrl(String url) {
    throw _noImplementationNeeded;
  }

  @override
  getSubscriptionPlan() {
    throw _noImplementationNeeded;
  }

  @override
  getTransactionList({String date = '', String search = ''}) {
    throw _noImplementationNeeded;
  }

  @override
  FutureResponse<String> login(
      {required String username, required String password}) {
    throw _noImplementationNeeded;
  }

  @override
  logout() {
    throw _noImplementationNeeded;
  }

  @override
  orderFromUrl(String url) {
    throw _noImplementationNeeded;
  }

  @override
  orderStatusUpdate({
    required String orderId,
    required String status,
    String note = '',
  }) {
    throw _noImplementationNeeded;
  }

  @override
  productAttributeValueStore({required String uid, required String text}) {
    throw _noImplementationNeeded;
  }

  @override
  productDelete(String id) {
    throw _noImplementationNeeded;
  }

  @override
  productDetails(String id) {
    throw _noImplementationNeeded;
  }

  @override
  productRestore(String id) {
    throw _noImplementationNeeded;
  }

  @override
  FutureResponse<String> register(QMap formData) =>
      throw _noImplementationNeeded;

  @override
  renewSubscription(id) {
    throw _noImplementationNeeded;
  }

  @override
  requestWithdraw(String method, String amount) {
    throw _noImplementationNeeded;
  }

  @override
  resetPassword(QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  storeDigitalProduct(QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  storePhysicalProduct(QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  storeWithdraw(String id, QMap data) {
    throw _noImplementationNeeded;
  }

  @override
  subscribeToPlan(String id) {
    throw _noImplementationNeeded;
  }

  @override
  subscriptionUpdate(String id) {
    throw _noImplementationNeeded;
  }

  @override
  ticketList([String? url]) {
    throw _noImplementationNeeded;
  }

  @override
  ticketMassage(String id) {
    throw _noImplementationNeeded;
  }

  @override
  ticketReply({
    required String ticketNumber,
    required String message,
    required List files,
  }) {}

  @override
  transactionsFromUrl(String url) {
    throw _noImplementationNeeded;
  }

  @override
  updateDigitalProduct(String id, QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  updatePassword(QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  updatePhysicalProduct(String id, QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  updateSellerProfile(QMap formData, File file) {
    throw _noImplementationNeeded;
  }

  @override
  updateStoreInfo(QMap formData, Map<String, File> partFiles) {
    throw _noImplementationNeeded;
  }

  @override
  verifyEmail(String email) {
    throw _noImplementationNeeded;
  }

  @override
  verifyOTP(QMap formData) {
    throw _noImplementationNeeded;
  }

  @override
  withdrawList(String search, String date) {
    throw _noImplementationNeeded;
  }

  @override
  withdrawListFromUrl(String url) {
    throw _noImplementationNeeded;
  }

  @override
  withdrawMethods() {
    throw _noImplementationNeeded;
  }

  //! Token
  Future<bool> setToken(String? token) async {
    if (token == null) return delete(PrefKeys.accessToken);
    return await save(PrefKeys.accessToken, token);
  }

  String? getToken() => getString(PrefKeys.accessToken);

  //! Language
  Future<bool> setLanguage(String? langCode) async {
    if (langCode == null) return delete(PrefKeys.language);
    return await save(PrefKeys.language, langCode);
  }

  String? getLanguage() => getString(PrefKeys.language);

  //! Currency
  Future<bool> setCurrency(Currency? currency) async {
    if (currency == null) return delete(PrefKeys.currency);
    return await save(PrefKeys.currency, currency.toMap());
  }

  Currency? getCurrency() {
    var map = getMap(PrefKeys.currency);
    if (map == null) return null;
    return Currency.fromMap(map);
  }

  //! Currency
  Future<bool> setBaseCurrency(Currency? currency) async {
    if (currency == null) return delete(PrefKeys.baseCurrency);
    return await save(PrefKeys.baseCurrency, currency.toMap());
  }

  Currency? getBaseCurrency() {
    var map = getMap(PrefKeys.baseCurrency);
    if (map == null) return null;
    return Currency.fromMap(map);
  }

  //! Theme
  Future<bool> setTheme(bool? themeMode) async {
    if (themeMode == null) return delete(PrefKeys.isLight);
    return await save(PrefKeys.isLight, themeMode);
  }

  String? getTheme() => getString(PrefKeys.isLight);

  @override
  fetchChatList() {
    throw UnimplementedError();
  }

  @override
  fetchChatMessage(String id) {
    throw UnimplementedError();
  }

  @override
  sendChatMessage(QMap formData) {
    throw UnimplementedError();
  }

  @override
  updateFCMToken(String token) {
    throw UnimplementedError();
  }
}
