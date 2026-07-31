import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/storage_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final StorageService _storageService;

  BookmarkProvider(this._storageService) {
    refresh();
  }

  List<Article> _bookmarks = [];
  List<Article> get bookmarks => _bookmarks;

  void refresh() {
    _bookmarks = _storageService.getBookmarks();
    notifyListeners();
  }

  bool isBookmarked(String url) => _storageService.isBookmarked(url);

  Future<void> toggleBookmark(Article article) async {
    if (isBookmarked(article.url)) {
      await _storageService.removeBookmark(article.url);
    } else {
      await _storageService.addBookmark(article);
    }
    refresh();
  }
}
