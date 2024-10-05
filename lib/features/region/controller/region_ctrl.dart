import 'package:seller_management/main.export.dart';

import '../repository/region_repo.dart';

final regionCtrlProvider =
    AutoDisposeNotifierProvider<RegionCtrlNotifier, Region>(
        RegionCtrlNotifier.new);

class RegionCtrlNotifier extends AutoDisposeNotifier<Region> {
  final _repo = locate<RegionRepo>();

  @override
  Region build() {
    return _repo.getRegion();
  }

  Future<void> setLanguage(String langCode) async {
    final region = state.copyWith(langCode: langCode);
    _repo.setLanguage(langCode);
    state = region;
  }

  Future<void> setCurrency(Currency currency) async {
    final region = state.copyWith(currency: currency);
    _repo.setCurrency(currency);
    state = region;
  }
}
