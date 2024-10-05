
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/region_settings/repository/region_repo.dart';
import 'package:seller_management/features/product/view/settings/region_model.dart';
import '../../../../../locator.dart';

final regionCtrlProvider =
    NotifierProvider<RegionCtrlNotifier, RegionModel>(RegionCtrlNotifier.new);

class RegionCtrlNotifier extends Notifier<RegionModel> {
  final _repo = locate<RegionRepoEx1>();

  @override
  RegionModel build() => _repo.getRegion();

  Future<void> setLangCode(String code) async {
    final region = state.copyWith(langCode: code);
    _repo.setLanguage(code);
    state = region;
  }

  setCurrencyCode(Currency currency) async {
    final region = state.copyWith(currency: currency);
    _repo.setCurrency(currency);
    state = region;
  }
}
