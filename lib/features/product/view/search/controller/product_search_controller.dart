
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/search/repository/product_search_repo.dart';

final searchCtrlProvider =
    AsyncNotifierProvider<SearchCtrlNotifier, List<ProductsData>>(
        SearchCtrlNotifier.new);

class SearchCtrlNotifier extends AsyncNotifier<List<ProductsData>> {
  SearchRepo get _repo => ref.watch(searchRepoProvider);

  @override
  Future<List<ProductsData>> build() async {
    return [];
  }

  Future<void> search(String text) async {
    if (text.isEmpty) {
      Toaster.showInfo('Nothing to search');
      return;
    }

    state = const AsyncValue.loading();

    final res = await _repo.searchProduct(text);

    res.fold((l) => null, (r) => state = AsyncValue.data(r.data.listData));
  }

  clear() {
    state = const AsyncValue.data([]);
  }
}
