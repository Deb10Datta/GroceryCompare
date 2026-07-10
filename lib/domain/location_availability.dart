// Serviceability mapping: which quick-commerce platforms deliver to a
// given area. The platforms expose no official public serviceability API,
// so availability is resolved from the locality/city (either typed by the
// user or resolved live from their PIN code via the India Post API) and,
// as an offline fallback, from the PIN code's leading digits.
const Map<String, List<String>> _cityPlatformIds = {
  'bengaluru': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'bangalore': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'mumbai': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'thane': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'delhi': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'noida': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'ghaziabad': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'gurugram': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'gurgaon': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'faridabad': ['blinkit', 'zepto', 'bigbasket', 'jiomart'],
  'pune': ['blinkit', 'zepto', 'bigbasket', 'jiomart'],
  'hyderabad': ['blinkit', 'instamart', 'bigbasket', 'jiomart'],
  'chennai': ['instamart', 'bigbasket', 'jiomart'],
  'kolkata': ['bigbasket', 'jiomart'],
  'ahmedabad': ['blinkit', 'zepto', 'bigbasket', 'jiomart'],
  'jaipur': ['blinkit', 'bigbasket', 'jiomart'],
  'lucknow': ['blinkit', 'bigbasket', 'jiomart'],
};

// PIN-code prefixes for the metros above, used when the live pincode
// lookup is unavailable (offline / API down). Longest prefix wins.
const Map<String, String> _pinPrefixCity = {
  '110': 'delhi',
  '1201': 'noida', // Ghaziabad range
  '201': 'noida',
  '121': 'faridabad',
  '122': 'gurugram',
  '30': 'jaipur',
  '226': 'lucknow',
  '38': 'ahmedabad',
  '400': 'mumbai',
  '401': 'thane',
  '411': 'pune',
  '412': 'pune',
  '50': 'hyderabad',
  '560': 'bengaluru',
  '562': 'bengaluru',
  '60': 'chennai',
  '70': 'kolkata',
};

const List<String> _defaultPlatformIds = ['bigbasket', 'jiomart'];

List<String> platformIdsAvailableFor(String location) {
  final normalized = location.toLowerCase();
  for (final entry in _cityPlatformIds.entries) {
    if (normalized.contains(entry.key)) return entry.value;
  }
  return _defaultPlatformIds;
}

/// Offline serviceability guess from a 6-digit PIN code alone.
List<String> platformIdsForPincode(String pincode) {
  final city = cityForPincode(pincode);
  if (city != null) return _cityPlatformIds[city]!;
  return _defaultPlatformIds;
}

/// Best-effort city for a PIN code from its postal prefix, or null when
/// the code doesn't fall in one of the mapped metros.
String? cityForPincode(String pincode) {
  String? bestCity;
  var bestLength = 0;
  for (final entry in _pinPrefixCity.entries) {
    if (pincode.startsWith(entry.key) && entry.key.length > bestLength) {
      bestCity = entry.value;
      bestLength = entry.key.length;
    }
  }
  return bestCity;
}

/// Serviceability for a user we know both a PIN code and a free-text
/// location for. The PIN code (precise) wins when it maps to a known
/// metro; otherwise the typed locality decides.
List<String> platformIdsServing({required String pincode, required String location}) {
  if (pincode.length == 6 && cityForPincode(pincode) != null) {
    return platformIdsForPincode(pincode);
  }
  return platformIdsAvailableFor(location);
}
