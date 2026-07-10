import 'package:flutter/material.dart';

class GroceryPlatform {
  final String id;
  final String name;
  final String badgeLabel;
  final Color color;

  /// The platform's storefront homepage, used when handing the user off
  /// to complete their purchase on the provider's own website.
  final String websiteUrl;

  /// URL template for the platform's on-site product search. `{query}` is
  /// replaced with the URL-encoded search term. None of these platforms
  /// expose a public "add to cart" deep link, so search results for the
  /// exact item is the closest official entry point we can hand off to.
  final String searchUrlTemplate;

  const GroceryPlatform({
    required this.id,
    required this.name,
    required this.badgeLabel,
    required this.color,
    required this.websiteUrl,
    required this.searchUrlTemplate,
  });

  Uri get websiteUri => Uri.parse(websiteUrl);

  Uri searchUri(String query) =>
      Uri.parse(searchUrlTemplate.replaceFirst('{query}', Uri.encodeComponent(query)));
}
