import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../data/models/savings_record.dart';

sealed class SavingsEvent {
  const SavingsEvent();
}

class SavingsRecorded extends SavingsEvent {
  final String platformName;
  final double amountSaved;
  const SavingsRecorded({required this.platformName, required this.amountSaved});
}

class SavingsBloc extends HydratedBloc<SavingsEvent, List<SavingsRecord>> {
  SavingsBloc() : super(const []) {
    on<SavingsRecorded>((event, emit) {
      final record = SavingsRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        timestamp: DateTime.now(),
        platformName: event.platformName,
        amountSaved: event.amountSaved,
      );
      emit([record, ...state]);
    });
  }

  double get totalSavings => state.fold(0.0, (sum, r) => sum + r.amountSaved);

  @override
  List<SavingsRecord>? fromJson(Map<String, dynamic> json) => (json['items'] as List)
      .map((e) => SavingsRecord.fromJson(e as Map<String, dynamic>))
      .toList();

  @override
  Map<String, dynamic>? toJson(List<SavingsRecord> state) =>
      {'items': state.map((r) => r.toJson()).toList()};
}
