import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class AuthRepo extends Repo {
  FutureResponse<String> loginUser(String name, String pass) async {
    final data = await rdb.login(username: name, password: pass);
    return data;
  }

  FutureResponse<String> updatePassword(QMap formData) async {
    final data = await rdb.updatePassword(formData);
    return data;
  }

  FutureResponse<String> emailVerify(String email) async {
    final data = await rdb.verifyEmail(email);
    return data;
  }

  FutureResponse<String> verifyOTP(QMap formData) async {
    final data = await rdb.verifyOTP(formData);
    return data;
  }

  FutureResponse<String> resetPassword(QMap formData) async {
    final data = await rdb.resetPassword(formData);
    return data;
  }

  FutureResponse<String> registerUser(QMap formData) async {
    final data = await rdb.register(formData);
    return data;
  }

  FutureResponse<String> logOut() async {
    final data = await rdb.logout();
    await deleteToken();
    return data;
  }

  String? getToken() {
    final token = ldb.getToken();
    Logger('$token', 'Got TOKEN');
    return token;
  }

  Future<bool> saveToken(String token) async {
    final data = await ldb.setToken(token);
    Logger('[$data] : $token', 'Saved TOKEN');
    return data;
  }

  Future<bool> deleteToken() async {
    final data = await ldb.setToken(null);
    Logger('TOKEN DELETED : $data', 'TOKEN DELETED');
    return data;
  }
}
