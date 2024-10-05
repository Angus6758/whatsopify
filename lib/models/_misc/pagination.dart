import 'dart:convert';

import 'package:seller_management/main.export.dart';

class PagedItem<T> {
  const PagedItem({
    required this.listData,
    required this.pagination,
  });

  const PagedItem.empty()
      : listData = const [],
        pagination = null;

  factory PagedItem.fromJson(
    String? source,
    T Function(dynamic source) fromJsonT,
  ) =>
      PagedItem.fromMap(
        source == null ? {} : json.decode(source),
        fromJsonT,
      );

  factory PagedItem.fromMap(QMap map, T Function(QMap source) fromJsonT) {
    return PagedItem(
      listData: map['data'] == null
          ? []
          : List<T>.from(map['data']?.map((x) => fromJsonT(x))),
      pagination: map['pagination'] == null
          ? null
          : PaginationInfo.fromMap(map['pagination']),
    );
  }

  final List<T> listData;
  final PaginationInfo? pagination;

  bool get isEmpty => listData.isEmpty;
  bool get isNotEmpty => listData.isNotEmpty;
  int get length => listData.length;
  int get totalLength => pagination?.totalItem ?? 0;

  T operator [](int index) => listData[index];

  PagedItem<T> operator +(PagedItem<T> other) {
    return PagedItem<T>(
      listData: [...listData, ...other.listData],
      pagination: other.pagination,
    );
  }

  Map<String, dynamic> toMap(Object Function(T data) toJsonT) {
    return {
      'data': List<dynamic>.from(listData.map((x) => toJsonT(x))),
      'pagination': pagination?.toMap(),
    };
  }

  String toJson(Object Function(T data) toJsonT) {
    return json.encode(toMap(toJsonT));
  }

  PagedItem<T> copyWith({
    List<T>? listData,
    PaginationInfo? pagination,
  }) {
    return PagedItem<T>(
      listData: listData ?? this.listData,
      pagination: pagination ?? this.pagination,
    );
  }
}

class PaginationInfo {
  PaginationInfo({
    required this.totalItem,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.prevPageUrl,
    required this.nextPageUrl,
    required this.path,
  });

  factory PaginationInfo.fromJson(String source) =>
      PaginationInfo.fromMap(json.decode(source));

  factory PaginationInfo.fromMap(Map<String, dynamic> map) {
    return PaginationInfo(
      totalItem: map.parseInt('total'),
      perPage: map.parseInt('per_page'),
      currentPage: map.parseInt('current_page'),
      lastPage: map.parseInt('last_page'),
      from: map.parseInt('from'),
      to: map.parseInt('to'),

      //
      prevPageUrl: map['prev_page_url'],
      nextPageUrl: map['next_page_url'],
      path: map['path'] ?? '',
    );
  }

  final int currentPage;
  final int from;
  final int lastPage;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int to;
  final int totalItem;

  int get limitedTotal => lastPage > 3 ? 3 : lastPage;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'total': totalItem});
    result.addAll({'per_page': perPage});
    result.addAll({'current_page': currentPage});
    result.addAll({'last_page': lastPage});
    result.addAll({'from': from});
    result.addAll({'to': to});
    result.addAll({'prev_page_url': prevPageUrl});
    result.addAll({'next_page_url': nextPageUrl});
    result.addAll({'path': path});

    return result;
  }

  String toJson() => json.encode(toMap());
}
