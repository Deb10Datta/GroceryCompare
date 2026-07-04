import 'package:equatable/equatable.dart';

class SavingsRecord extends Equatable {
  final String id;
  final DateTime timestamp;
  final String platformName;
  final double amountSaved;

  const SavingsRecord({
    required this.id,
    required this.timestamp,
    required this.platformName,
    required this.amountSaved,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'platformName': platformName,
        'amountSaved': amountSaved,
      };

  factory SavingsRecord.fromJson(Map<String, dynamic> json) => SavingsRecord(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        platformName: json['platformName'] as String,
        amountSaved: (json['amountSaved'] as num).toDouble(),
      );

  @override
  List<Object?> get props => [id];
}
