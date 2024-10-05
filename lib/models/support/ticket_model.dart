import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seller_management/main.export.dart';

class SupportTicket {
  SupportTicket({
    required this.ticketNumber,
    required this.subject,
    required this.priority,
    required this.status,
    required this.createdAt,
  });

  factory SupportTicket.fromMap(Map<String, dynamic> map) {
    return SupportTicket(
      ticketNumber: map['ticket_number'] ?? '',
      subject: map['subject'] ?? '',
      createdAt: map['created_at'] ?? '',
      priority: TicketPriority.fromValue(map.parseInt('priority')),
      status: TicketStatus.fromValue(map['status'] ?? 0),
    );
  }

  final String createdAt;
  final TicketPriority priority;
  final TicketStatus status;
  final String subject;
  final String ticketNumber;

  SupportTicket copyWith({
    String? ticketNumber,
    String? createdAt,
    String? subject,
    TicketPriority? priority,
    TicketStatus? status,
  }) {
    return SupportTicket(
      ticketNumber: ticketNumber ?? this.ticketNumber,
      createdAt: createdAt ?? this.createdAt,
      subject: subject ?? this.subject,
      priority: priority ?? this.priority,
      status: status ?? this.status,
    );
  }

  bool get isClosed => status == TicketStatus.closed;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': createdAt});

    result.addAll({'priority': priority.index + 1});
    result.addAll({'status': status.index + 1});
    result.addAll({'subject': subject});
    result.addAll({'ticketNumber': ticketNumber});

    return result;
  }

  String toJson() => json.encode(toMap());
}

enum TicketPriority {
  low,
  medium,
  high;

  factory TicketPriority.fromValue(int value) =>
      switch (value) { 1 => low, 2 => medium, 3 => high, _ => low };

  String get title => name.titleCaseSingle;

  Color get color {
    return switch (this) {
      TicketPriority.low => Colors.green,
      TicketPriority.medium => Colors.orange,
      TicketPriority.high => Colors.red,
    };
  }
}

enum TicketStatus {
  running,
  answered,
  replied,
  closed,
  unknown;

  factory TicketStatus.fromValue(int value) {
    return switch (value) {
      1 => running,
      2 => answered,
      3 => replied,
      4 => closed,
      _ => unknown,
    };
  }

  String get title => name.titleCaseSingle;

  Color get color {
    return switch (this) {
      TicketStatus.running => Colors.green,
      TicketStatus.answered => Colors.orange,
      TicketStatus.replied => Colors.blue,
      TicketStatus.closed => Colors.red,
      TicketStatus.unknown => Colors.grey,
    };
  }
}

class TicketMassage {
  TicketMassage({
    required this.id,
    required this.createdAt,
    required this.message,
    required this.isAdminReply,
    required this.isUserReply,
    required this.files,
  });

  factory TicketMassage.fromMap(Map<String, dynamic> map) {
    return TicketMassage(
     id: map.parseInt('id'),
      createdAt: DateTime.parse(map['created_at']),
      message: map['message'],
      isAdminReply: map['is_admin_reply'] ?? false,
      isUserReply: map['is_seller_reply'] ?? false,
      files: List<TicketFile>.from(
          map['files']?.map((x) => TicketFile.fromMap(x))),
    );
  }

  final DateTime createdAt;
  final List<TicketFile> files;
  final int id;
  final bool isAdminReply;
  final bool isUserReply;
  final String? message;
}

class TicketFile {
  TicketFile({
    required this.id,
    required this.uid,
    required this.supportMessageId,
    required this.fileName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketFile.fromMap(Map<String, dynamic> map) {
    return TicketFile(
     id: map.parseInt('id'),
      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      supportMessageId: map.parseInt('support_message_id'),
      fileName: map['file'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  final String createdAt;
  final String fileName;
  final int id;
  final int supportMessageId;
  final String uid;
  final String updatedAt;
}

class TicketData {
  TicketData({
    required this.ticket,
    required this.massages,
  });

  factory TicketData.fromMap(Map<String, dynamic> map) {
    return TicketData(
      massages: List<TicketMassage>.from(
        map['ticket_messages']['data']?.map((x) => TicketMassage.fromMap(x)),
      ),
      ticket: SupportTicket.fromMap(map['ticket']),
    );
  }

  final List<TicketMassage> massages;
  final SupportTicket ticket;
}
