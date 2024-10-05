import 'dart:io' as io;

import 'package:dio/dio.dart';

class TicketCreateModel {
  const TicketCreateModel({
    required this.subject,
    required this.priority,
    required this.message,
    required this.files,
  });

  final String subject;
  final String priority;
  final String message;
  final List<io.File> files;

  TicketCreateModel copyWith({
    String? subject,
    String? priority,
    String? message,
    List<io.File>? files,
  }) {
    return TicketCreateModel(
      subject: subject ?? this.subject,
      priority: priority ?? this.priority,
      message: message ?? this.message,
      files: files ?? this.files,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject,
      'priority': priority,
      'message': message,
    };
  }

  Future<Map<String, dynamic>> toMapFiles() async {
    final fileParts = <MultipartFile>[];
    for (var img in files) {
      final file = await MultipartFile.fromFile(
        img.path,
        filename: img.path.split('/').last,
      );
      fileParts.add(file);
    }
    return <String, dynamic>{'file': fileParts};
  }

  static TicketCreateModel empty = const TicketCreateModel(
    subject: '',
    priority: '1',
    message: '',
    files: [],
  );
}
