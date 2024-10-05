// ignore_for_file: use_build_context_synchronously


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seller_management/features/add_product/view/product_review/repository/product_review_repo.dart';
import 'package:seller_management/features/product/view/common/toast.dart';
import 'package:seller_management/features/product/view/content/product_models.dart';
import 'package:seller_management/features/product/view/products/controller/product_ctrl.dart';

final reviewCtrlProvider =
    StateNotifierProvider.family<ReviewNotifier, ReviewPostData, String>(
        (ref, uid) {
  final data = ReviewPostData(uid: uid, review: '', rate: 0);
  return ReviewNotifier(ref, data);
});

class ReviewNotifier extends StateNotifier<ReviewPostData> {
  ReviewNotifier(this._ref, ReviewPostData data) : super(data);

  final reviewCtrl = TextEditingController();

  final Ref _ref;

  updateRating(double rating) {
    state = state.copyWith(rate: rating.toInt());
  }

  submitReview(BuildContext context) async {
    Toaster.showLoading('Loading...');
    state = state.copyWith(review: reviewCtrl.text);

    final res = await _repo.submitReview(state.toMap());
    context.pop;

    res.fold(
      (l) => Toaster.showError(l),
      (r) {
        _ref
            .read(productCtrlProvider(
                (uid: state.uid, campaignId: null, isRegular: true)).notifier)
            .silentReload();
        Toaster.showSuccess(r.data.message);
      },
    );
  }

  ReviewRepo get _repo => _ref.watch(reviewRepoProvider);
}
