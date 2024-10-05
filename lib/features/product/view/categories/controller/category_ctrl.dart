
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/product/view/categories/repository/category_repo.dart';
import 'package:seller_management/features/product/view/content/category_models.dart';

final categoryCtrlProvider =
    AsyncNotifierProviderFamily<CategoryCtrlNotifier, CategoryDetails, String>(
        CategoryCtrlNotifier.new);

class CategoryCtrlNotifier
    extends FamilyAsyncNotifier<CategoryDetails, String> {
  CategoryRepo get _repo => ref.watch(categoryRepoProvider);

  @override
  Future<CategoryDetails> build(String arg) async {
    return await _init();
  }

  Future<CategoryDetails> _init() async {
    final res = await _repo.getCategoryProducts(arg);

    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  Future<void> handlePagination(bool isNext) async {
    final stateData = await future;
    final url = isNext
        ? stateData.products.pagination?.nextPageUrl
        : stateData.products.pagination?.prevPageUrl;

    if (url == null) return;
    state = const AsyncValue.loading();
    final res = await _repo.getCategoryFromUrl(url);

    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => state = AsyncValue.data(r.data),
    );
  }

  Future<void> reload() async {
    ref.invalidateSelf();
  }
}
