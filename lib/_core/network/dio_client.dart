import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/features/region/repository/region_repo.dart';
import 'package:seller_management/main.export.dart';
import 'package:seller_management/routes/routes.dart';

export 'package:dio/dio.dart' show DioException;

@Singleton(order: 4)
class DioClient {
  DioClient() {
    _dio = Dio(_options);
    _dio.interceptors.add(_interceptorsWrapper());
    _dio.interceptors.add(Logger.dioLogger());
  }

  late Dio _dio;
  final _ls = locate<LocalDB>();
  final _options = BaseOptions(
    baseUrl: Endpoints1.api,
    connectTimeout: Endpoints1.connectionTimeout,
    receiveTimeout: Endpoints1.receiveTimeout,
    responseType: ResponseType.json,
    headers: {'Accept': 'application/json'},
  );

  Future<Map<String, String?>> header() async {
    final token = _ls.getString(PrefKeys.accessToken);
    final lang = locate<RegionRepo>().getLanguage();
    final cur = locate<RegionRepo>().getCurrency()?.uid;

    return {
      'Authorization': 'Bearer $token',
      'currency-uid': cur,
      'api-lang': lang,
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
      final response = await _dio.get(
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
    } catch (e) {
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
    } catch (e) {
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
    } catch (e) {
      rethrow;
    }
  }

  final _eventStreamer = locate<EventStreamer>();
  // Interceptors :----------------------------------------------------------------------
  _interceptorsWrapper() => InterceptorsWrapper(
    onRequest: (options, handler) async {
      final headers = await header();
      options.headers.addAll(headers);
      return handler.next(options);
    },
    onResponse: (res, handler) async {
      final regionRepo = locate<RegionRepo>();
      await regionRepo.setFromResponse(res);

      final Map<String, dynamic> response = res.data ?? {};

      if (response.isNotEmpty) {
        _eventStreamer.addEvent(Event('server_status', payload: response));
      }

      return handler.next(res);
    },
    onError: (error, handler) async {
      final response = error.response;
      final data = response?.data ?? {};

      if (data.isNotEmpty && response != null) {
        final isUnAuth = data['is_seller_authenticate'] == false ||
            '${data['message']}'.toLowerCase().contains('unauthenticated');

        if (isUnAuth) {
          final err = DioExp(error).toFailure(null);

          if (Get.context != null) {
            RouteNames.login.goNamed(
              Get.context!,
              query: {'logout': 'true', 'msg': err.message},
            );
          }
        }
        if (data['is_seller_authenticate'] != false) {
          _eventStreamer.addEvent(Event('server_status', payload: data));
        }
      }

      return handler.next(error);
    },
  );
}