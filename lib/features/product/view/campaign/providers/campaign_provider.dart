import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/base/item_list_with_page_data.dart';
import 'package:seller_management/features/product/view/common/shared_pref_provider.dart';
import 'package:seller_management/features/product/view/content/campaign_models.dart';
import 'package:seller_management/features/product/view/home/controller/home_page_ctrl.dart';
import 'package:seller_management/features/product/view/products/repository/pagination_providing_repo.dart';
import 'package:seller_management/features/product/view/strings/shared_pref_const.dart';

final campaignListProvider = AutoDisposeAsyncNotifierProvider<
    CampaignListNotifier,
    ItemListWithPageData<CampaignModel>>(CampaignListNotifier.new);

class CampaignListNotifier
    extends AutoDisposeAsyncNotifier<ItemListWithPageData<CampaignModel>> {
  @override
  FutureOr<ItemListWithPageData<CampaignModel>> build() {
    final pref = ref.watch(sharedPrefProvider);
    final campaigns = pref.getString(CachedKeys.campaigns);

    return ItemListWithPageData<CampaignModel>.fromJson(
      campaigns,
      (source) => CampaignModel.fromMap(source)
          //.fromJson(source),
    );
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    await ref.read(homeCtrlProvider.notifier).reload(false);
    ref.invalidateSelf();
  }

  Future<void> next() async {
    final stateData = await future;
    final repo = ref.watch(paginationProvidingRepoProvider);
    final url = stateData.pagination?.nextPageUrl;
    if (url == null) return;

    state = const AsyncLoading();

    final res = await repo.pageFromHome(url);
    final data = res.fold((l) => null, (r) => r.data);
    if (data == null) return;

    state = AsyncData(data.campaigns);
  }

  Future<void> previous() async {
    final stateData = await future;
    final repo = ref.watch(paginationProvidingRepoProvider);
    final url = stateData.pagination?.prevPageUrl;
    if (url == null) return;

    state = const AsyncLoading();

    final res = await repo.pageFromHome(url);
    final data = res.fold((l) => null, (r) => r.data);
    if (data == null) return;

    state = AsyncData(data.campaigns);
  }
}
