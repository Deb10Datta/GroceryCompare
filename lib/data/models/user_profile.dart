import 'package:equatable/equatable.dart';

import 'payment_method.dart';

class UserProfile extends Equatable {
  final String name;
  final String avatarEmoji;
  final String location;
  final String preferredCategoryId;
  final PaymentMethod preferredPayment;
  final bool onboardingComplete;

  const UserProfile({
    this.name = '',
    this.avatarEmoji = '🙂',
    this.location = '',
    this.preferredCategoryId = '',
    this.preferredPayment = PaymentMethod.upi,
    this.onboardingComplete = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatarEmoji': avatarEmoji,
        'location': location,
        'preferredCategoryId': preferredCategoryId,
        'preferredPayment': preferredPayment.name,
        'onboardingComplete': onboardingComplete,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '',
        avatarEmoji: json['avatarEmoji'] as String? ?? '🙂',
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
        name,
        avatarEmoji,
        location,
        preferredCategoryId,
        preferredPayment,
        onboardingComplete,
      ];
}
