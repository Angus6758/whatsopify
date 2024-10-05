import 'dart:convert';

import 'package:seller_management/features/product/view/common/logger.dart';

class CampaignModel {
  CampaignModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.startTime,
    required this.endTime,
  });

  factory CampaignModel.fromJson(String source) =>
      CampaignModel.fromMap(json.decode(source));

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    // print("received map from CampaignModel $map");
    return CampaignModel(

      uid: map['uid'] ?? (throw Exception('UID is missing or null')),
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),

    );
  }


  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'end_time': endTime.toIso8601String(),
      'image': image,
      'name': name,
      'start_time': startTime.toIso8601String(),
      'uid': uid,
    };
  }

  @override
  String toString() {
    talk.debug('CampaignModel(uid: $uid, name: $name, image: $image, startTime: $startTime, endTime: $endTime)');
    return 'CampaignModel(uid: $uid, name: $name, image: $image, startTime: $startTime, endTime: $endTime)';
  }

  final DateTime endTime;
  final String image;
  final String name;
  final DateTime startTime;
  final String uid;
}
