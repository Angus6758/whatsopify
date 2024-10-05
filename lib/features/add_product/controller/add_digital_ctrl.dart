import 'dart:io';

import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:seller_management/features/add_product/repository/add_product_repo.dart';
import 'package:seller_management/features/product/controller/list_ctrls.dart';
import 'package:seller_management/features/product/controller/product_ctrl.dart';
import 'package:seller_management/main.export.dart';

final digitalStoreCtrlProvider = AutoDisposeNotifierProviderFamily<
    ProductStoreNotifier,
    DigitalStoreState,
    ProductModel?>(ProductStoreNotifier.new);

class ProductStoreNotifier
    extends AutoDisposeFamilyNotifier<DigitalStoreState, ProductModel?> {
  final _repo = locate<AddProductRepo>();

  Future<void> storeProductData() async {
    final parts = await state.toMapMultiPart();
    final formData = {...state.toMap(), ...parts};

    final res = await _repo.addDigitalProduct(formData);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );

    ref.invalidate(digitalProductCtrlProvider);
    ref.invalidateSelf();
  }

  Future<void> updateProductData(String id) async {
    final parts = await state.toMapMultiPart();
    final formData = {...state.toMap(), ...parts};
    final res = await _repo.updateDigitalProduct(id, formData);

    res.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidate(digitalProductCtrlProvider);
  }

  bool updateTaxData(QMap map) {
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

  void addInfoFromMap(QMap map) {
    updateTaxData(map);
    setAttributesFromMap(map);
    state = state.copyWithMap(map);
  }

  void copyWith(DigitalStoreState Function(DigitalStoreState current) copy) {
    state = copy(state);
  }

  void setCategory(String? id) {
    state = state.copyWith(categoryId: () => id);
  }

  void setSubCategory(String? id) {
    state = state.copyWith(subCategoryId: () => id);
  }

  void updateThumbImage(File? img) {
    state =
        state.copyWith(featuredImage: () => img == null ? null : right(img));
  }

  void addNewAttributeField() {
    final attributes = [...?state.attributes];
    attributes.add((name: '', price: '', id: attributes.length));

    state = state.copyWith(attributes: () => attributes);
  }

  Future<void> removeAttributeField(int id) async {
    final attributes = [...?state.attributes];
    attributes.removeWhere((e) => e.id == id);

    await deleteAttribute();

    state = state.copyWith(attributes: () => attributes);
  }

  Future<void> deleteAttribute() async {
    if (arg == null) return;
    final attributes = arg!.digitalAttributes;

    for (var attr in state.attributes!) {
      final match = attributes.firstWhereOrNull(
        (e) => e.name == attr.name && '${e.price}' == attr.price,
      );

      if (match != null) {
        ref
            .read(productDetailsCtrlProvider(arg!.uid).notifier)
            .deleteAttribute(match.uid);
        break;
      }
    }
  }

  void setAttributesFromMap(QMap map) {
    final names = <String>[];
    final prices = <String>[];

    final attributes =
        map.entries.where((e) => e.key.startsWith('attr_')).toList();

    for (var MapEntry(:key, :value) in attributes) {
      if (key.startsWith('attr_name')) names.add(value);
      if (key.startsWith('attr_price')) prices.add(value);
    }

    state = state.copyWith(
      attributeNames: () => names,
      attributePrices: () => prices,
    );
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

  @override
  DigitalStoreState build(ProductModel? arg) {
    return DigitalStoreState.fromProduct(arg);
  }
}
