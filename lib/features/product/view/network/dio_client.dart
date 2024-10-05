import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/_core/network/server_status_provider.dart';
import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/features/product/view/common/logger.dart';
import 'package:seller_management/features/product/view/region_settings/controller/region_ctrl.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../locator.dart';

export 'package:dio/dio.dart' show DioException;

class DioClient {
  DioClient(this._ref) {
    _dio = Dio(_options);
    _dio.interceptors.add(_interceptorsWrapper());
    _dio.interceptors.add(talk.dioLogger);
  }

  late Dio _dio;

  final _options = BaseOptions(
    baseUrl: Endpoints.baseApiUrl,
    connectTimeout: Endpoints.connectionTimeout,
    receiveTimeout: Endpoints.receiveTimeout,
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  );

  final Ref _ref;

  Future<Map<String, String?>> header() async {
    final token = locate<SharedPreferences>().getString(PrefKeys.accessToken);
    final langCode = locate<RegionRepoEx1>().getLanguage();
    final currencyUid = locate<RegionRepoEx1>().getCurrency()?.uid;

    return {
      'api-lang': langCode,
      'currency-uid': currencyUid,
      'Authorization': 'Bearer $token',
    };
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      final formData = data == null
          ? null
          : FormData.fromMap(data, ListFormat.multiCompatible);

      final Response response = await _dio.post(
        url,
        data: formData,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  Future<Response> download(
      String url,
      String savePath, {
        void Function(int, int)? onReceiveProgress,
      }) async {
    try {
      final Response response = await _dio.get(
        url,
        onReceiveProgress: onReceiveProgress,
        options: Options(
          headers: {},
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return (status ?? 0) < 500;
          },
        ),
      );
      Logger(response.data, 'download');
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Interceptors :----------------------------------------------------------------------
  _interceptorsWrapper() => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final headers = await header();
      options.headers.addAll(headers);
      return handler.next(options);
    },
    onResponse: (res, handler) async {
      final regionRepo = locate<RegionRepoEx1>();
      await regionRepo.setFromResponse(res);
      _ref.invalidate(regionCtrlProvider);

      final statusCtrl = _ref.read(serverStatusProvider.notifier);
      final Map<String, dynamic> response = res.data ?? {};

      final code = response['code'];

      statusCtrl.update(code);
      return handler.next(res);
    },
    onError: (DioException error, handler) async {
      if (error.response?.statusCode == 401) {
        _ref.read(authCtrlProvider.notifier).logout(false);
      }
      final statusCtrl = _ref.read(serverStatusProvider.notifier);
      final data = error.response?.data;

      if (data is Map?) {
        final response = data ?? {};
        final code = response['code'];
        statusCtrl.update(code);
      }
      return handler.next(error);
    },
  );
}
