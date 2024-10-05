import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class ChatRepo extends Repo {
  FutureResponse<List<Customer>> fetchChatList() async {
    final data = await rdb.fetchChatList();
    return data;
  }

  FutureResponse<CustomerMessageData> fetchMessage(String id) async {
    final data = await rdb.fetchChatMessage(id);
    return data;
  }

  FutureResponse<PagedItem<CustomerMessage>> loadMoreFromUrl(String url) async {
    final data =
        await rdb.pagedItemFromUrl(url, 'messages', CustomerMessage.fromMap);
    return data;
  }

  FutureResponse<String> sendReply({
    required String id,
    required String msg,
    List<File> files = const [],
  }) async {
    final partFiles = <MultipartFile>[];

    for (var file in files) {
      partFiles.add(
        await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      );
    }

    final formData = {'customer_id': id, 'message': msg, 'files': partFiles};

    final data = await rdb.sendChatMessage(formData);
    return data;
  }
}
