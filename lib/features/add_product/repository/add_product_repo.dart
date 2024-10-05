import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class AddProductRepo extends Repo {
  FutureResponse<String> addDigitalProduct(QMap formData) async {
    final data = await rdb.storeDigitalProduct(formData);
    return data;
  }

  FutureResponse<String> updateDigitalProduct(String id, QMap formData) async {
    final data = await rdb.updateDigitalProduct(id, formData);
    return data;
  }

  FutureResponse<String> addPhysicalProduct(QMap formData) async {
    final data = await rdb.storePhysicalProduct(formData);
    return data;
  }

  FutureResponse<String> updatePhysicalProduct(String id, QMap formData) async {
    final data = await rdb.updatePhysicalProduct(id, formData);
    return data;
  }
}
