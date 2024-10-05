
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/api_res_model.dart';
import 'package:seller_management/features/product/view/common/failure.dart';
import 'package:seller_management/features/product/view/content/campaign_details_model.dart';
import 'package:seller_management/features/product/view/network/dio_client.dart';
import 'package:seller_management/features/product/view/network/dio_errors.dart';
import 'package:seller_management/features/product/view/strings/endpoints.dart';

final campaignRepoProvider = Provider<CampaignRepo>((ref) => CampaignRepo(ref));

class CampaignRepo {
  CampaignRepo(this._ref);

  final Ref _ref;

  FutureEither<ApiResponse<CampaignDetails>> getCampaignDetails(
      String uid) async {
    try {
      final response = await _dio.get(Endpoints.campaignDetails(uid));

      final resParsed = ApiResponse.fromMap(
        response.data,
        (json) => CampaignDetails.fromMap(json),
      );

      return right(resParsed);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  FutureEither<ApiResponse<CampaignDetails>> getPaginatedFromUrl(
      String url) async {
    try {
      final response = await _dio.get(url);

      final resParsed = ApiResponse.fromMap(
        response.data,
        (json) => CampaignDetails.fromMap(json),
      );

      return right(resParsed);
    } on DioException catch (e) {
      final failure = DioExp(e).toFailure();
      return left(failure);
    }
  }

  DioClient get _dio => DioClient(_ref);
}
