// Mock "which quick-commerce platforms deliver to this locality" lookup.
// There's no real serviceability API to call, so this matches the
// free-text location against a small set of known metros and falls back
// to a conservative default for anywhere else, purely to make the
// "stores in your area" and account-linking flows feel grounded.
const Map<String, List<String>> _cityPlatformIds = {
  'bengaluru': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'bangalore': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'mumbai': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'delhi': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'gurugram': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'gurgaon': ['blinkit', 'zepto', 'instamart', 'bigbasket', 'jiomart'],
  'pune': ['blinkit', 'zepto', 'bigbasket', 'jiomart'],
  'hyderabad': ['blinkit', 'instamart', 'bigbasket', 'jiomart'],
  'chennai': ['instamart', 'bigbasket', 'jiomart'],
  'kolkata': ['bigbasket', 'jiomart'],
};

const List<String> _defaultPlatformIds = ['bigbasket', 'jiomart'];

List<String> platformIdsAvailableFor(String location) {
  final normalized = location.toLowerCase();
  for (final entry in _cityPlatformIds.entries) {
    if (normalized.contains(entry.key)) return entry.value;
  }
  return _defaultPlatformIds;
}
