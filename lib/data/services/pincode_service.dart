import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/location_availability.dart';

/// Quirky validation error for an Indian PIN code, or null when valid.
/// Empty input gets no error (the Next button already stays locked), so
/// the form doesn't nag before the user has started typing.
String? pincodeError(String value) {
  final v = value.trim();
  if (v.isEmpty) return null;
  if (RegExp(r'[^\d]').hasMatch(v)) {
    return 'PIN codes are strictly digits — letters get returned to sender 📮';
  }
  if (v.length < 6) {
    return 'Only ${v.length} of 6 digits — your parcel would get lost halfway 🗺️';
  }
  if (v.length > 6) {
    return "That's ${v.length} digits — Indian PIN codes stop at 6 ✂️";
  }
  if (v.startsWith('0')) {
    return "Indian PIN codes never start with 0 — that one's from a parallel universe 🌌";
  }
  return null;
}

/// Where a lookup result came from, so the UI can be honest about it.
enum PincodeLookupSource { live, offline }

class PincodeLookupResult {
  final String pincode;
  final String area; // e.g. "Koramangala"
  final String district; // e.g. "Bengaluru"
  final String state; // e.g. "Karnataka"
  final List<String> platformIds;
  final PincodeLookupSource source;

  const PincodeLookupResult({
    required this.pincode,
    required this.area,
    required this.district,
    required this.state,
    required this.platformIds,
    required this.source,
  });

  /// "Koramangala, Bengaluru, Karnataka" with empty parts skipped.
  String get displayLocation =>
      [area, district, state].where((s) => s.isNotEmpty).join(', ');
}

/// Resolves a PIN code to a locality and the platforms serving it.
///
/// Uses the free India Post postal API (api.postalpincode.in) to verify
/// the PIN code really exists and to name the area, then maps the
/// resolved district/state onto platform serviceability. When the network
/// is unavailable the postal-prefix fallback keeps the flow working.
class PincodeService {
  PincodeService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const _timeout = Duration(seconds: 6);

  Future<PincodeLookupResult> lookup(String pincode) async {
    try {
      final response = await _client
          .get(Uri.parse('https://api.postalpincode.in/pincode/$pincode'))
          .timeout(_timeout);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final entry = (decoded is List && decoded.isNotEmpty) ? decoded.first : null;
        final offices = entry?['PostOffice'];
        if (offices is List && offices.isNotEmpty) {
          final office = offices.first as Map<String, dynamic>;
          final area = (office['Name'] as String?)?.trim() ?? '';
          final district = (office['District'] as String?)?.trim() ?? '';
          final state = (office['State'] as String?)?.trim() ?? '';
          return PincodeLookupResult(
            pincode: pincode,
            area: area,
            district: district,
            state: state,
            platformIds: platformIdsServing(
              pincode: pincode,
              location: '$district $state',
            ),
            source: PincodeLookupSource.live,
          );
        }
        // The API answered but knows no such PIN code.
        throw const UnknownPincodeException();
      }
      throw http.ClientException('Unexpected status ${response.statusCode}');
    } on UnknownPincodeException {
      rethrow;
    } catch (_) {
      // Network trouble — fall back to the postal-prefix heuristic so the
      // user isn't blocked, and tell the UI the result is an offline guess.
      return PincodeLookupResult(
        pincode: pincode,
        area: '',
        district: _titleCase(cityForPincode(pincode) ?? ''),
        state: '',
        platformIds: platformIdsForPincode(pincode),
        source: PincodeLookupSource.offline,
      );
    }
  }

  void dispose() => _client.close();
}

/// Thrown when the postal API confirms the PIN code does not exist.
class UnknownPincodeException implements Exception {
  const UnknownPincodeException();
}

String _titleCase(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
