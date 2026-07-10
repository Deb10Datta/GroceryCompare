import 'package:equatable/equatable.dart';

import 'payment_method.dart';

class UserProfile extends Equatable {
  final String name;
  /// Self-described sex/gender category, picked on the name step.
  final String sex;
  /// Contact details kept purely for our own record keeping (savings
  /// reports, order history) — never sent to any third-party platform.
  final String email;
  final String phoneNumber;
  final String avatarEmoji;
  final String tribe;
  final String location;
  final String pincode;
  final String preferredCategoryId;
  final PaymentMethod preferredPayment;
  final bool onboardingComplete;

  const UserProfile({
    this.name = '',
    this.sex = '',
    this.email = '',
    this.phoneNumber = '',
    this.avatarEmoji = '🙂',
    this.tribe = '',
    this.location = '',
    this.pincode = '',
    this.preferredCategoryId = '',
    this.preferredPayment = PaymentMethod.upi,
    this.onboardingComplete = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sex': sex,
        'email': email,
        'phoneNumber': phoneNumber,
        'avatarEmoji': avatarEmoji,
        'tribe': tribe,
        'location': location,
        'pincode': pincode,
        'preferredCategoryId': preferredCategoryId,
        'preferredPayment': preferredPayment.name,
        'onboardingComplete': onboardingComplete,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        name: json['name'] as String? ?? '',
        sex: json['sex'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phoneNumber: json['phoneNumber'] as String? ?? '',
        avatarEmoji: json['avatarEmoji'] as String? ?? '🙂',
        tribe: json['tribe'] as String? ?? '',
        location: json['location'] as String? ?? '',
        pincode: json['pincode'] as String? ?? '',
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
        sex,
        email,
        phoneNumber,
        avatarEmoji,
        tribe,
        location,
        pincode,
        preferredCategoryId,
        preferredPayment,
        onboardingComplete,
      ];
}
