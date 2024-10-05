
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/settings/config_model.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final settingsRepoProvider = Provider<SettingsRepo>((ref) => SettingsRepo(ref));

class SettingsRepo {
  SettingsRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<ConfigModel>> getConfig() async {
    try {
      final response = await _dio.get(Endpoints.config);

      final configRes = ApiResponse.fromMap(
        response.data,
        (json) => ConfigModel.fromMap(json),
      );

      return right(configRes);
    } on DioException catch (e, s) {
      final failure = DioExp(e).toFailure(s);
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
