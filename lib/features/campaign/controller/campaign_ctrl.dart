import 'dart:async';

import 'package:seller_management/main.export.dart';

import '../repository/campaign_repo.dart';

final campaignCtrlProvider = AutoDisposeAsyncNotifierProvider<
    CampaignCtrlNotifier, PagedItem<CampaignModel>>(
  CampaignCtrlNotifier.new,
);

class CampaignCtrlNotifier
    extends AutoDisposeAsyncNotifier<PagedItem<CampaignModel>> {
  final _repo = locate<CampaignRepo>();

  Future<void> reload() async {
    state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  Future<void> listByUrl(String? url) async {
    if (url == null) return;
    state = const AsyncValue.loading();
    final data = await _repo.getCampaignList(url);
    data.fold(
      (l) => state = l.toAsyncError(),
      (r) => state = AsyncData(r.data),
    );
  }

  @override
  FutureOr<PagedItem<CampaignModel>> build() async {
    final data = await _repo.getCampaignList();
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}
