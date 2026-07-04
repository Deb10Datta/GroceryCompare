import 'package:equatable/equatable.dart';

class Bookmark extends Equatable {
  final String productId;
  final String platformId;
  final DateTime savedAt;

  const Bookmark({
    required this.productId,
    required this.platformId,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'platformId': platformId,
        'savedAt': savedAt.toIso8601String(),
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        productId: json['productId'] as String,
        platformId: json['platformId'] as String,
        savedAt: DateTime.parse(json['savedAt'] as String),
      );

  @override
  List<Object?> get props => [productId, platformId];
}
