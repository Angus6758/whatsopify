import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class DashboardRepo extends Repo {
  FutureReport<BaseResponse<Dashboard>> getDashboard() async {
    final data = await rdb.getDashboard();

    return data;
  }
}
