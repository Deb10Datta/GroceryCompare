import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../data/models/payment_method.dart';
import '../data/models/user_profile.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class OnboardingCompleted extends ProfileEvent {
  final String email;
  final String phoneNumber;
  final bool isNewUser;
  final String name;
  final String avatarEmoji;
  final String tribe;
  final String location;
  final String categoryId;
  final PaymentMethod paymentMethod;

  const OnboardingCompleted({
    required this.email,
    required this.phoneNumber,
    required this.isNewUser,
    required this.name,
    required this.avatarEmoji,
    required this.tribe,
    required this.location,
    required this.categoryId,
    required this.paymentMethod,
  });
}

class ProfileBloc extends HydratedBloc<ProfileEvent, UserProfile> {
  ProfileBloc() : super(const UserProfile()) {
    on<OnboardingCompleted>((event, emit) {
      emit(UserProfile(
        email: event.email,
        phoneNumber: event.phoneNumber,
        isNewUser: event.isNewUser,
        name: event.name,
        avatarEmoji: event.avatarEmoji,
        tribe: event.tribe,
        location: event.location,
        preferredCategoryId: event.categoryId,
        preferredPayment: event.paymentMethod,
        onboardingComplete: true,
      ));
    });
  }

  @override
  UserProfile? fromJson(Map<String, dynamic> json) => UserProfile.fromJson(json);

  @override
  Map<String, dynamic>? toJson(UserProfile state) => state.toJson();
}
