import 'package:seller_management/main.export.dart';

class RatingModel {
  RatingModel({
    required this.totalReview,
    required this.avgRating,
    required this.review,
  });

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      totalReview: map.parseInt('total_review'),
      avgRating: map.parseInt('avg_rating'),
      review: List<dynamic>.from(map['review']),
    );
  }

  final int avgRating;

  final List<dynamic> review;

  final int totalReview;

  static RatingModel empty =
      RatingModel(totalReview: 0, avgRating: 0, review: []);

  Map<String, dynamic> toMap() {
    return {
      'total_review': totalReview,
      'avg_rating': avgRating,
      'review': review,
    };
  }
}
