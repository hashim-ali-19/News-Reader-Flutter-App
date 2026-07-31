import 'package:flutter/material.dart';

import '../models/article.dart';
import '../services/api_service.dart';
import '../services/app_exceptions.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

enum FeedStatus { initial, loading, loadingMore, loaded, empty, error, offlineCached }

class ArticleProvider extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;

  ArticleProvider({
    ApiService? apiService,
    StorageService? storageService,
    ConnectivityService? connectivityService,
  })  : _apiService = apiService ?? ApiService(),
        _storageService = storageService ?? StorageService(),
        _connectivityService = connectivityService ?? ConnectivityService() {
    fetchInitial();
  }

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  FeedStatus _status = FeedStatus.initial;
  FeedStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  String _selectedCategory = AppConstants.categories.first;
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  bool get isSearching => _searchQuery.trim().isNotEmpty;

  int _page = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchInitial() async {
    _page = 1;
    _hasMore = true;
    _status = FeedStatus.loading;
    notifyListeners();
    await _load(reset: true);
  }

  Future<void> refresh() async {
    _page = 1;
    _hasMore = true;
    await _load(reset: true, isRefresh: true);
  }

  Future<void> loadMore() async {
    if (_status == FeedStatus.loadingMore || !_hasMore) return;
    _status = FeedStatus.loadingMore;
    notifyListeners();
    _page++;
    await _load(reset: false);
  }

  Future<void> setCategory(String category) async {
    if (category == _selectedCategory && !isSearching) return;
    _selectedCategory = category;
    _searchQuery = '';
    _page = 1;
    _hasMore = true;
    _status = FeedStatus.loading;
    notifyListeners();
    await _load(reset: true);
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    _page = 1;
    _hasMore = true;
    _status = FeedStatus.loading;
    notifyListeners();
    await _load(reset: true);
  }

  void clearSearch() {
    _searchQuery = '';
    fetchInitial();
  }

  Future<void> _load({required bool reset, bool isRefresh = false}) async {
    try {
      final newArticles = await _apiService.fetchArticles(
        page: _page,
        category: _selectedCategory,
        query: isSearching ? _searchQuery : null,
      );

      if (reset) {
        _articles = newArticles;
      } else {
        // Avoid duplicate entries if the API returns overlapping pages.
        final existingUrls = _articles.map((a) => a.url).toSet();
        _articles.addAll(newArticles.where((a) => !existingUrls.contains(a.url)));
      }

      _hasMore = newArticles.length >= ApiConstants.pageSize;

      if (!isSearching) {
        await _storageService.cacheFeed(_articles, _selectedCategory);
      }

      _status = _articles.isEmpty ? FeedStatus.empty : FeedStatus.loaded;
      _errorMessage = '';
    } on NoInternetException catch (e) {
      await _fallbackToCache(e.message, reset);
    } on AppException catch (e) {
      if (reset) {
        _errorMessage = e.message;
        _status = FeedStatus.error;
      } else {
        // Keep whatever we already loaded; just stop paginating.
        _page--;
        _status = FeedStatus.loaded;
      }
    } catch (e) {
      if (reset) {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        _status = FeedStatus.error;
      } else {
        _page--;
        _status = FeedStatus.loaded;
      }
    }
    notifyListeners();
  }

  Future<void> _fallbackToCache(String message, bool reset) async {
    if (!reset || isSearching) {
      _errorMessage = message;
      _status = FeedStatus.error;
      return;
    }
    final cached = _storageService.getCachedFeed(_selectedCategory);
    if (cached.isNotEmpty) {
      _articles = cached;
      _hasMore = false;
      _status = FeedStatus.offlineCached;
      _errorMessage = message;
    } else {
      _errorMessage = message;
      _status = FeedStatus.error;
    }
  }
}
