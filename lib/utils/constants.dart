/// Centralized app constants.
///
/// IMPORTANT: Get a free API key from https://newsapi.org/register
/// and paste it below before running the app. NewsAPI's free tier
/// works great for development/demo purposes.
class ApiConstants {
  static const String apiKey = 'aba4e40ad1084dc69c96f6e9948c7951';

  static const String baseUrl = 'https://newsapi.org/v2';
  static const String topHeadlines = '$baseUrl/top-headlines';
  static const String everything = '$baseUrl/everything';

  static const String defaultCountry = 'us';
  static const int pageSize = 20;
}

class AppConstants {
  static const String appName = 'Loop';
  static const String appTagline = 'Stay in the loop';

  static const List<String> categories = [
    'general',
    'technology',
    'business',
    'sports',
    'entertainment',
    'health',
    'science',
  ];

  static const bookmarksBoxName = 'bookmarks_box';
  static const cachedFeedBoxName = 'cached_feed_box';
  static const settingsBoxName = 'settings_box';
}
