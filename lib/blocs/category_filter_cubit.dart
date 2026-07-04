import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryFilterCubit extends Cubit<String?> {
  CategoryFilterCubit() : super(null);

  void select(String? categoryId) => emit(categoryId);
}
