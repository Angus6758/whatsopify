import 'dart:io';

import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:seller_management/main.export.dart';

import '../repository/chat_repo.dart';

part 'chat_ctrl.g.dart';

@riverpod
class ChatCtrl extends _$ChatCtrl {
  final _repo = locate<ChatRepo>();

  Future<void> reload([bool silent = false]) async {
    if (!silent) state = const AsyncValue.loading();
    ref.invalidateSelf();
  }

  @override
  Future<List<Customer>> build() async {
    final data = await _repo.fetchChatList();

    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}

@riverpod
class ChatMessageCtrl extends _$ChatMessageCtrl {
  final _repo = locate<ChatRepo>();

  Future<void> reload() async {
    final data = await _init();
    state = AsyncData(data);
  }

  Future<LoadStatus> loadMore() async {
    final it = await future;
    final next = it.messages.pagination?.nextPageUrl;
    if (next == null) return LoadStatus.noMore;

    final moreData = await _repo.loadMoreFromUrl(next);
    final more = moreData.fold(
      (l) => it.messages,
      (r) => it.messages + r.data,
    );

    state = AsyncData(it.newMessages(more));

    return moreData.fold((l) => LoadStatus.failed, (r) => LoadStatus.idle);
  }

  Future<void> reply(String msg, List<File> files) async {
    if (msg.isEmpty) {
      Toaster.showError('Please enter message');
      return;
    }
    final data = await _repo.sendReply(id: id, msg: msg, files: files);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<List<File>> pickFiles() async {
    final newFiles = await locate<FilePickerRepo>().pickFiles();

    return newFiles.fold(
      (l) => Toaster.showError(l).andReturn([]),
      (r) => r,
    );
  }

  @override
  Future<CustomerMessageData> build(String id) async {
    return _init();
  }

  Future<CustomerMessageData> _init() async {
    final data = await _repo.fetchMessage(id);
    return data.fold((l) => l.toFError(), (r) => r.data);
  }
}
