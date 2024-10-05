import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class ProductRepo extends Repo {
  FutureResponse<PagedItem<ProductModel>> getDigitalPRoduct({
    String? status,
    String? search,
  }) async {
    final data = await rdb.getDigitalProduct(status ?? '', search ?? '');
    return data;
  }

  FutureResponse<PagedItem<ProductModel>> getPhysicalProduct({
    String? status,
    String? search,
  }) async {
    final data = await rdb.getPhysicalProduct(search ?? '', status ?? '');
    return data;
  }

  FutureResponse<PagedItem<ProductModel>> getProductByUrl(String url) async {
    final data = await rdb.getProductByUrl(url);
    return data;
  }

  FutureResponse<ProductModel> getProductDetails(String id) async {
    final data = await rdb.productDetails(id);
    return data;
  }

  FutureResponse<ProductModel> storeDigitalAttribute(
      String uid, QMap formData) async {
    final data = await rdb.digitalAttributeStore(uid: uid, formData: formData);
    return data;
  }

  FutureResponse<ProductModel> attributeValueStore(
    String uid,
    String text,
  ) async {
    final data = await rdb.productAttributeValueStore(
      uid: uid,
      text: text,
    );
    return data;
  }

  FutureResponse<ProductModel> attributeDelete(String id) async {
    final data = await rdb.attributeDelete(id);
    return data;
  }

  FutureResponse<ProductModel> attributeValueDelete(
    String id,
  ) async {
    final data = await rdb.attributeValueDelete(id);
    return data;
  }

  FutureResponse<String> deleteGalleryImage(
    String id,
  ) async {
    final data = await rdb.deleteGalleryImage(id);
    return data;
  }

  FutureResponse<String> productDelete(
    String id,
  ) async {
    final data = await rdb.productDelete(id);
    return data;
  }

  FutureResponse<String> deletePermanently(
    String id,
  ) async {
    final data = await rdb.deletePermanently(id);
    return data;
  }

  FutureResponse<String> productRestore(
    String id,
  ) async {
    final data = await rdb.productRestore(id);
    return data;
  }
}
