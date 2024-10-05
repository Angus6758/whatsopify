import 'package:seller_management/main.export.dart';
import 'package:timeago/timeago.dart' as timeago;

class CustomerMessageData {
  const CustomerMessageData({
    required this.messages,
    required this.customer,
  });

  final PagedItem<CustomerMessage> messages;
  final Customer? customer;

  factory CustomerMessageData.fromMap(Map<String, dynamic> map) {
    return CustomerMessageData(
      messages: PagedItem.fromMap(
        map['messages'],
        (s) => CustomerMessage.fromMap(s),
      ),
      customer: Customer.fromMap(map['user']),
    );
  }

  CustomerMessageData newMessages(
    PagedItem<CustomerMessage>? messages,
  ) {
    return CustomerMessageData(
      messages: messages ?? this.messages,
      customer: customer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messages': messages.toMap((e) => e.toMap()),
      'user': customer?.toMap(),
    };
  }
}

class CustomerMessage {
  const CustomerMessage({
    required this.id,
    required this.message,
    required this.fileMap,
    required this.isSeen,
    required this.createdAt,
    required this.isMine,
  });

  factory CustomerMessage.fromMap(Map<String, dynamic> map) {
    return CustomerMessage(
     id: map.parseInt('id'),
      message: map['message'],
      fileMap: List<Map>.from(map['files']),
      isSeen: map['is_seen'],
      createdAt: map['created_at'],
      isMine: map['sender_role']['role'] == 'seller',
    );
  }

  final String createdAt;
  final List<Map> fileMap;
  final int id;
  final bool isSeen;
  final String message;
  final bool isMine;

  DateTime get dateTime => DateTime.parse(createdAt);
  String get readableTime => timeago.format(dateTime, locale: 'en');

  List<({String name, String url})> get files {
    final fileJoin = <String, String>{};

    for (final file in fileMap) {
      fileJoin.addAll(file.cast<String, String>());
    }

    return fileJoin.entries.map((e) => (name: e.key, url: e.value)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'files': fileMap,
      'is_seen': isSeen,
      'created_at': createdAt,
      'sender_role': {
        'role': isMine ? 'deliveryman' : 'customer',
        // 'user': sender.fold((l) => l.toMap(), (r) => r.toMap()),
      },
    };
  }
}
