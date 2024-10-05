import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class SettingsRepo extends Repo {
  FutureResponse<AppSettings> getApiSettings() async {
    final data = await rdb.config();
    return data;
  }

  AppSettings? getAppSettingsSync() {
    return ldb.config();
  }

  Future<AppSettings?> saveSettings(AppSettings settings) async {
    final data = ldb.config(settings);
    return data;
  }

  FutureResponse<AuthConfig> getAuthConfig() async {
    final data = await rdb.authConfig();
    return data;
  }

  AuthConfig? getAuthConfigSync() {
    return ldb.authConfig();
  }

  Future<AuthConfig?> saveAuthConfig(AuthConfig settings) async {
    final data = ldb.authConfig(settings);
    return data;
  }
}
