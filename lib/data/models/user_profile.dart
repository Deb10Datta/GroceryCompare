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
  /// Record of every payment method the user has, mapped to the providers
  /// they picked under it (UPI apps, card issuers, banks…). Used only to
  /// match payment offers to methods the user can actually use.
  final Map<PaymentMethod, List<String>> paymentOptions;
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
    this.paymentOptions = const {},
    this.onboardingComplete = false,
  });

  Set<PaymentMethod> get ownedPaymentMethods => paymentOptions.keys.toSet();

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
        'paymentOptions': {
          for (final entry in paymentOptions.entries) entry.key.name: entry.value,
        },
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
        paymentOptions: _paymentOptionsFromJson(json),
        onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      );

  /// Reads the method→providers record, falling back to the legacy
  /// single-choice `preferredPayment` field from radio-button-era profiles.
  static Map<PaymentMethod, List<String>> _paymentOptionsFromJson(
      Map<String, dynamic> json) {
    final raw = json['paymentOptions'];
    if (raw is Map) {
      return {
        for (final entry in raw.entries)
          for (final method in PaymentMethod.values)
            if (method.name == entry.key)
              method: [
                for (final provider in entry.value as List? ?? const []) '$provider',
              ],
      };
    }
    final legacy = json['preferredPayment'];
    for (final method in PaymentMethod.values) {
      if (method.name == legacy) return {method: const []};
    }
    return const {};
  }

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
        paymentOptions,
        onboardingComplete,
      ];
}
