import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../data/models/payment_method.dart';
import '../data/models/user_profile.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class OnboardingCompleted extends ProfileEvent {
  final String name;
  final String sex;
  final String email;
  final String phoneNumber;
  final String avatarEmoji;
  final String tribe;
  final String location;
  final String pincode;
  final String categoryId;
  final PaymentMethod paymentMethod;

  const OnboardingCompleted({
    required this.name,
    required this.sex,
    required this.email,
    required this.phoneNumber,
    required this.avatarEmoji,
    required this.tribe,
    required this.location,
    required this.pincode,
    required this.categoryId,
    required this.paymentMethod,
  });
}

class ProfileBloc extends HydratedBloc<ProfileEvent, UserProfile> {
  ProfileBloc() : super(const UserProfile()) {
    on<OnboardingCompleted>((event, emit) {
      emit(UserProfile(
        name: event.name,
        sex: event.sex,
        email: event.email,
        phoneNumber: event.phoneNumber,
        avatarEmoji: event.avatarEmoji,
        tribe: event.tribe,
        location: event.location,
        pincode: event.pincode,
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
