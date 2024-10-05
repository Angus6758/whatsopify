import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:seller_management/main.export.dart';

@singleton
class TicketRepo extends Repo {
  FutureResponse<PagedItem<SupportTicket>> getTickets([String? url]) async {
    final data = await rdb.ticketList(url);
    return data;
  }

  FutureResponse<TicketData> getMassage(String id) async {
    final data = await rdb.ticketMassage(id);
    return data;
  }

  FutureResponse<TicketData> ticketReply(
    String message,
    String ticketNumber,
    List<File> file,
  ) async {
    final data = await rdb.ticketReply(
      ticketNumber: ticketNumber,
      message: message,
      files: file,
    );
    return data;
  }

  FutureResponse<TicketData> createTicket({required QMap formData}) async {
    final data = await rdb.createTicket(formData);
    return data;
  }

  FutureResponse<String> fileDownload({
    required String id,
    required String massageId,
    required String ticketNo,
  }) async {
    final data = await rdb.getDownload(
      id: id,
      massageId: massageId,
      ticketNo: ticketNo,
    );
    return data;
  }
}
