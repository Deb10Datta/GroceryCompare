import 'package:equatable/equatable.dart';

import 'payment_method.dart';

class UserProfile extends Equatable {
  final String email;
  final String phoneNumber;
  final bool isNewUser;
  final String name;
  final String avatarEmoji;
  final String tribe;
  final String location;
  final String preferredCategoryId;
  final PaymentMethod preferredPayment;
  final bool onboardingComplete;

  const UserProfile({
    this.email = '',
    this.phoneNumber = '',
    this.isNewUser = false,
    this.name = '',
    this.avatarEmoji = '🙂',
    this.tribe = '',
    this.location = '',
    this.preferredCategoryId = '',
    this.preferredPayment = PaymentMethod.upi,
    this.onboardingComplete = false,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'phoneNumber': phoneNumber,
        'isNewUser': isNewUser,
        'name': name,
        'avatarEmoji': avatarEmoji,
        'tribe': tribe,
        'location': location,
        'preferredCategoryId': preferredCategoryId,
        'preferredPayment': preferredPayment.name,
        'onboardingComplete': onboardingComplete,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        email: json['email'] as String? ?? '',
        phoneNumber: json['phoneNumber'] as String? ?? '',
        isNewUser: json['isNewUser'] as bool? ?? false,
        name: json['name'] as String? ?? '',
        avatarEmoji: json['avatarEmoji'] as String? ?? '🙂',
        tribe: json['tribe'] as String? ?? '',
        location: json['location'] as String? ?? '',
        preferredCategoryId: json['preferredCategoryId'] as String? ?? '',
        preferredPayment: PaymentMethod.values.firstWhere(
          (m) => m.name == json['preferredPayment'],
          orElse: () => PaymentMethod.upi,
        ),
        onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        email,
        phoneNumber,
        isNewUser,
        name,
        avatarEmoji,
        tribe,
        location,
        preferredCategoryId,
        preferredPayment,
        onboardingComplete,
      ];
}
