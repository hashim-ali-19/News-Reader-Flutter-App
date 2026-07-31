import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/article.dart';
import '../utils/constants.dart';

/// Handles all local persistence: bookmarked articles (for offline
/// reading) and a lightweight cache of the last successful feed
/// (bonus feature) — plus simple key/value app settings like theme.
///
/// Articles are stored as JSON strings keyed by their [Article.url].
/// This avoids needing Hive TypeAdapter code generation for a model
/// that changes shape occasionally.
class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(AppConstants.bookmarksBoxName);
    await Hive.openBox<String>(AppConstants.cachedFeedBoxName);
    await Hive.openBox(AppConstants.settingsBoxName);
  }

  Box<String> get _bookmarksBox =>
      Hive.box<String>(AppConstants.bookmarksBoxName);
  Box<String> get _cachedFeedBox =>
      Hive.box<String>(AppConstants.cachedFeedBoxName);
  Box get _settingsBox => Hive.box(AppConstants.settingsBoxName);

  // ---------------- Bookmarks ----------------

  List<Article> getBookmarks() {
    return _bookmarksBox.values
        .map((jsonStr) => Article.fromJson(jsonDecode(jsonStr)))
        .toList()
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
  }

  bool isBookmarked(String url) => _bookmarksBox.containsKey(url);

  Future<void> addBookmark(Article article) async {
    await _bookmarksBox.put(article.url, jsonEncode(article.toJson()));
  }

  Future<void> removeBookmark(String url) async {
    await _bookmarksBox.delete(url);
  }

  // ---------------- Cached feed (bonus: offline last feed) ----------------

  Future<void> cacheFeed(List<Article> articles, String category) async {
    final key = 'feed_$category';
    final jsonList = articles.map((a) => a.toJson()).toList();
    await _cachedFeedBox.put(key, jsonEncode(jsonList));
  }

  List<Article> getCachedFeed(String category) {
    final key = 'feed_$category';
    final raw = _cachedFeedBox.get(key);
    if (raw == null) return [];
    final List decoded = jsonDecode(raw);
    return decoded
        .map((json) => Article.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // ---------------- Settings ----------------

  bool get isDarkMode => _settingsBox.get('dark_mode', defaultValue: false);

  Future<void> setDarkMode(bool value) async {
    await _settingsBox.put('dark_mode', value);
  }
}
