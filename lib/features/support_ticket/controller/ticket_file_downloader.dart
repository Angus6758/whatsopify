import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:seller_management/main.export.dart';

import '../repository/ticket_repository.dart';

final fileDownloaderProvider =
    NotifierProvider<FileDownloaderNotifier, List<FileDownloaderQueue>>(
        FileDownloaderNotifier.new);

class FileDownloaderNotifier extends Notifier<List<FileDownloaderQueue>> {
  @override
  List<FileDownloaderQueue> build() {
    return [];
  }

  void addToQueue(
    TicketFile file,
    String ticketNo,
    String messageId, {
    bool openable = true,
  }) async {
    final saveDir = await getApplicationDocumentsDirectory();
    final downloadPath = saveDir.path + file.fileName;
    final isExisting = await File(downloadPath).exists();

    state = [
      ...state,
      FileDownloaderQueue(
        id: file.id,
        url: '',
        progress: isExisting ? -1 : null,
        downloadPath: downloadPath,
      ),
    ];

    if (isExisting) {
      if (openable) await OpenFilex.open(downloadPath);
      return;
    }
    await _getUrlNDownload(file.id, messageId, ticketNo);
  }

  Future<void> _getUrlNDownload(
    int id,
    String messageId,
    String ticketNo,
  ) async {
    final res = await locate<TicketRepo>().fileDownload(
      id: id.toString(),
      massageId: messageId,
      ticketNo: ticketNo,
    );

    res.fold(
      (l) => Toaster.showError(l),
      (r) async {
        state = [
          for (final file in state)
            if (file.id == id) file.copyWith(url: r.data) else file
        ];
        await _startDownload(id);
      },
    );
  }

  Future<void> _startDownload(int id) async {
    final queuedFile = state.firstWhere((element) => element.id == id);

    try {
      await Dio().download(
        queuedFile.url,
        queuedFile.downloadPath,
        lengthHeader: Headers.contentLengthHeader,
        options: Options(
          // Disables gzip
          headers: {HttpHeaders.acceptEncodingHeader: '*'},
        ),
        onReceiveProgress: (received, total) {
          double? progress = ((received / total) * 100) / 100;
          if (total <= 0) progress = null;
          state = [
            for (final file in state)
              if (file.id == id) file.updateProgress(progress) else file
          ];
        },
      );

      state = [
        for (final file in state)
          if (file.id == id) file.updateProgress(-1) else file
      ];
    } on PlatformException catch (e) {
      Toaster.showError(e.code);
    } on DioException catch (e) {
      Toaster.showError(e.message);
    }
  }
}
