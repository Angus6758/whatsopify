import 'dart:async';
import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:seller_management/features/product/controller/list_ctrls.dart';
import 'package:seller_management/features/product/controller/product_ctrl.dart';
import 'package:seller_management/main.export.dart';

import '../repository/add_product_repo.dart';

final physicalStoreCtrlProvider = AutoDisposeNotifierProviderFamily<
    ProductStoreNotifier,
    PhysicalStoreState,
    ProductModel?>(ProductStoreNotifier.new);

class ProductStoreNotifier
    extends AutoDisposeFamilyNotifier<PhysicalStoreState, ProductModel?> {
  final _repo = locate<AddProductRepo>();

  Future<void> storeProductData() async {
    final parts = await state.toMapMultiPart();
    final formData = {...state.toMap(), ...parts};

    final res = await _repo.addPhysicalProduct(formData);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(physicalProductCtrlProvider);
  }

  Future<void> updateProductData(String id) async {
    final parts = await state.toMapMultiPart();
    final formData = {...state.toMap(), ...parts};
    final res = await _repo.updatePhysicalProduct(id, formData);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(physicalProductCtrlProvider);
  }

  void addInfoFromMap(QMap map) {
    state = state.copyWithMap(map);
  }

  void copyWith(PhysicalStoreState Function(PhysicalStoreState current) copy) {
    state = copy(state);
  }

  void setShippingFeeMultiplier(bool? value) {
    state = state.copyWith(feeMultiplier: value ?? false);
  }

  void setCategory(String? id) {
    state = state.copyWith(categoryId: () => id);
  }

  void setSubCategory(String? id) {
    state = state.copyWith(subCategoryId: () => id);
  }

  void setBrand(String? id) {
    state = state.copyWith(brandId: () => id);
  }

  void updateThumbImage(File? img) {
    state =
        state.copyWith(featuredImage: () => img == null ? null : right(img));
  }

  void addGalleryImage(List<File> files) {
    final images = state.gallery?.toList() ?? [];

    images.addAll(files.map((e) => right(e)));

    state = state.copyWith(gallery: () => images);
  }

  Future<void> removeGalleryImage(String path, [bool isNetwork = false]) async {
    final images = state.gallery?.toList() ?? [];

    if (isNetwork) {
      await deleteGalleryImage(path);
    }

    images.removeWhere(
      (e) => e.fold((l) => l == path, (r) => r.path == path),
    );

    state = state.copyWith(gallery: () => images);
  }

  Future<void> deleteGalleryImage(String path) async {
    Logger(state.galleryWithId?.length.toString());
    if (state.galleryWithId == null) return;

    for (var img in state.galleryWithId!) {
      if (img.url == path) {
        ref
            .read(productDetailsCtrlProvider(state.id ?? '').notifier)
            .deleteGalleryImage('${img.id}');
      }
    }
  }

  bool updateTaxData(QMap map) {
    Logger(map.keys.toList());
    final ids = <String>{};
    final amounts = <String>[];
    final types = <String>[];
    for (var MapEntry(:key, :value) in map.entries) {
      if (value != null && key.contains('^')) {
        final split = key.split('^');

        final id = split.first;
        final k = split.last;
        if (k == 'amount') amounts.add(value);
        if (k == 'type') types.add(value == true ? '1' : '0');
        ids.add(id);
      }
    }

    if (amounts.length != types.length) {
      Toaster.showError('Please fill the TAX information properly');
      return false;
    }
    state = state.copyWith(
      taxIds: () => ids.toList(),
      taxAmounts: () => amounts,
      taxTypes: () => types,
    );

    return true;
  }

  void updateMetaKeyword(String keyword) {
    final keywords = [...?state.metaKeywords];

    if (keywords.contains(keyword)) {
      keywords.remove(keyword);
    } else {
      keywords.add(keyword);
    }
    state = state.copyWith(metaKeywords: () => keywords);
  }

  void addShippingId(String id) {
    final ids = state.shippingDeliveryIds?.toList() ?? [];
    if (ids.contains(id)) return;
    ids.add(id);
    state = state.copyWith(shippingDeliveryIds: () => ids);
  }

  void removeShippingId(String id) {
    final ids = state.shippingDeliveryIds?.toList() ?? [];
    ids.remove(id);
    state = state.copyWith(shippingDeliveryIds: () => ids);
  }

  void setAttribute(QMap attributeData) {
    state = state.copyWith(attributeData: () => attributeData);
  }

  void updateChoice(String id) {
    final choices = state.choiceNos?.toList() ?? [];
    if (choices.contains(id)) {
      choices.remove(id);
      removeFullChoiceOption(id);
    } else {
      choices.add(id);
    }

    state = state.copyWith(choiceNos: () => choices);
  }

  void addChoiceOption(String choice, String option) {
    final options = {...?state.choiceOptions};

    final key = 'choice_options_$choice';
    final value = [...?options[key]];

    if (!value.contains(option)) value.add(option);

    options.addAll({key: value});

    state = state.copyWith(choiceOptions: () => options);
  }

  void removeChoiceOption(String choice, String option) {
    final options = {...?state.choiceOptions};
    final key = 'choice_options_$choice';
    final value = [...?options[key]];

    value.remove(option);
    if (value.isEmpty) {
      options.remove(key);
    } else {
      options.addAll({key: value});
    }

    state = state.copyWith(choiceOptions: () => options);
  }

  void removeFullChoiceOption(String choiceId) {
    final options = {...?state.choiceOptions};
    final key = 'choice_options_$choiceId';

    options.remove(key);

    state = state.copyWith(choiceOptions: () => options);
  }

  @override
  PhysicalStoreState build(ProductModel? arg) {
    // final ax
    return PhysicalStoreState.fromProduct(arg);
  }
}
