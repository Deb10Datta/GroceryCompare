import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../data/models/bookmark.dart';

sealed class BookmarkEvent {
  const BookmarkEvent();
}

class BookmarkToggled extends BookmarkEvent {
  final String productId;
  final String platformId;
  const BookmarkToggled({required this.productId, required this.platformId});
}

class BookmarkBloc extends HydratedBloc<BookmarkEvent, List<Bookmark>> {
  BookmarkBloc() : super(const []) {
    on<BookmarkToggled>((event, emit) {
      final exists = isBookmarked(event.productId, event.platformId);
      if (exists) {
        emit(state
            .where((b) =>
                !(b.productId == event.productId && b.platformId == event.platformId))
            .toList());
      } else {
        emit([
          ...state,
          Bookmark(
            productId: event.productId,
            platformId: event.platformId,
            savedAt: DateTime.now(),
          ),
        ]);
      }
    });
  }

  bool isBookmarked(String productId, String platformId) => state.any(
      (b) => b.productId == productId && b.platformId == platformId);

  @override
  List<Bookmark>? fromJson(Map<String, dynamic> json) => (json['items'] as List)
      .map((e) => Bookmark.fromJson(e as Map<String, dynamic>))
      .toList();

  @override
  Map<String, dynamic>? toJson(List<Bookmark> state) =>
      {'items': state.map((b) => b.toJson()).toList()};
}
