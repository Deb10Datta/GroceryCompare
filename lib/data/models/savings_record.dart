import 'package:equatable/equatable.dart';

enum OrderStatus { placed, delivered }

class SavingsRecord extends Equatable {
  final String id;
  final DateTime timestamp;
  final String platformName;
  final double amountSaved;
  final OrderStatus status;

  const SavingsRecord({
    required this.id,
    required this.timestamp,
    required this.platformName,
    required this.amountSaved,
    this.status = OrderStatus.placed,
  });

  SavingsRecord copyWith({OrderStatus? status}) => SavingsRecord(
        id: id,
        timestamp: timestamp,
        platformName: platformName,
        amountSaved: amountSaved,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'platformName': platformName,
        'amountSaved': amountSaved,
        'status': status.name,
      };

  factory SavingsRecord.fromJson(Map<String, dynamic> json) => SavingsRecord(
        id: json['id'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        platformName: json['platformName'] as String,
        amountSaved: (json['amountSaved'] as num).toDouble(),
        status: OrderStatus.values.firstWhere(
          (s) => s.name == json['status'],
          orElse: () => OrderStatus.placed,
        ),
      );

  @override
  List<Object?> get props => [id, status];
}
