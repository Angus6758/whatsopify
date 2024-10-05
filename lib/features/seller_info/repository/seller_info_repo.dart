import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class SellerRepo extends Repo {
  FutureReport<BaseResponse<Seller>> getStoreInfo() async {
    final store = await rdb.getStoreInfo();
    return store;
  }

  FutureReport<BaseResponse<({String msg, Seller seller})>> updateStoreInfo(
    QMap formData,
    Map<String, File> partFiles,
  ) async {
    final store = await rdb.updateStoreInfo(formData, partFiles);
    return store;
  }

  FutureReport<BaseResponse<({String msg, Seller seller})>> updateSellerInfo(
    QMap formData,
    File? file,
  ) async {
    final store = await rdb.updateSellerProfile(formData, file);
    return store;
  }
}
