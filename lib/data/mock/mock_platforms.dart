import 'package:flutter/material.dart';

import '../models/grocery_platform.dart';

const List<GroceryPlatform> mockPlatforms = [
  GroceryPlatform(
    id: 'blinkit',
    name: 'Blinkit',
    badgeLabel: 'BK',
    color: Color(0xFFF8CB46),
    websiteUrl: 'https://blinkit.com',
    searchUrlTemplate: 'https://blinkit.com/s/?q={query}',
  ),
  GroceryPlatform(
    id: 'zepto',
    name: 'Zepto',
    badgeLabel: 'ZP',
    color: Color(0xFF8A3FFC),
    websiteUrl: 'https://www.zeptonow.com',
    searchUrlTemplate: 'https://www.zeptonow.com/search?query={query}',
  ),
  GroceryPlatform(
    id: 'instamart',
    name: 'Swiggy Instamart',
    badgeLabel: 'IM',
    color: Color(0xFFFC8019),
    websiteUrl: 'https://www.swiggy.com/instamart',
    searchUrlTemplate: 'https://www.swiggy.com/instamart/search?query={query}',
  ),
  GroceryPlatform(
    id: 'bigbasket',
    name: 'BigBasket',
    badgeLabel: 'BB',
    color: Color(0xFF84C225),
    websiteUrl: 'https://www.bigbasket.com',
    searchUrlTemplate: 'https://www.bigbasket.com/ps/?q={query}',
  ),
  GroceryPlatform(
    id: 'jiomart',
    name: 'JioMart',
    badgeLabel: 'JM',
    color: Color(0xFF0078AD),
    websiteUrl: 'https://www.jiomart.com',
    searchUrlTemplate: 'https://www.jiomart.com/search/{query}',
  ),
];
