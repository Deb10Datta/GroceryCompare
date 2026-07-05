import 'package:hydrated_bloc/hydrated_bloc.dart';

sealed class CartEvent {
  const CartEvent();
}

class CartItemAdded extends CartEvent {
  final String productId;
  final int quantity;
  const CartItemAdded(this.productId, {this.quantity = 1});
}

class CartItemRemoved extends CartEvent {
  final String productId;
  const CartItemRemoved(this.productId);
}

class CartCleared extends CartEvent {
  const CartCleared();
}

class CartBloc extends HydratedBloc<CartEvent, Map<String, int>> {
  CartBloc() : super(const {}) {
    on<CartItemAdded>((event, emit) {
      final updated = Map<String, int>.from(state);
      updated[event.productId] = (updated[event.productId] ?? 0) + event.quantity;
      emit(updated);
    });

    on<CartItemRemoved>((event, emit) {
      final updated = Map<String, int>.from(state);
      final current = updated[event.productId] ?? 0;
      if (current <= 1) {
        updated.remove(event.productId);
      } else {
        updated[event.productId] = current - 1;
      }
      emit(updated);
    });

    on<CartCleared>((event, emit) => emit(const {}));
  }

  @override
  Map<String, int>? fromJson(Map<String, dynamic> json) =>
      json.map((key, value) => MapEntry(key, value as int));

  @override
  Map<String, dynamic>? toJson(Map<String, int> state) => state;
}
