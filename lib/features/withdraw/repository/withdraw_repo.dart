import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class WithdrawRepo extends Repo {
  FutureReport<BaseResponse<List<WithdrawMethod>>> getMethods() async {
    final data = await rdb.withdrawMethods();
    return data;
  }

  FutureReport<BaseResponse<PagedItem<WithdrawData>>> getWithdrawList([
    String search = '',
    String date = '',
  ]) async {
    final data = await rdb.withdrawList(search, date);
    return data;
  }

  FutureReport<BaseResponse<PagedItem<WithdrawData>>> getWithdrawListFromUrl(
    String url,
  ) async {
    final data = await rdb.withdrawListFromUrl(url);
    return data;
  }

  FutureReport<BaseResponse<({String msg, WithdrawData data})>> request(
    String id,
    String number,
  ) async {
    final data = await rdb.requestWithdraw(id, number);
    return data;
  }

  FutureReport<BaseResponse<String>> storeWithdraw(
    String id,
    QMap formData,
  ) async {
    final data = await rdb.storeWithdraw(id, formData);
    return data;
  }
}
