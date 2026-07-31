import 'dart:async' hide TimeoutException;
import 'dart:async' as async show TimeoutException;
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/article.dart';
import '../utils/constants.dart';
import 'app_exceptions.dart';
import 'connectivity_service.dart';

class ApiService {
  final http.Client _client;
  final ConnectivityService _connectivityService;

  ApiService({http.Client? client, ConnectivityService? connectivityService})
      : _client = client ?? http.Client(),
        _connectivityService = connectivityService ?? ConnectivityService();

  /// Fetches a page of articles.
  ///
  /// If [query] is provided, hits the `/everything` search endpoint.
  /// Otherwise hits `/top-headlines` filtered by [category].
  Future<List<Article>> fetchArticles({
    required int page,
    String category = 'general',
    String? query,
  }) async {
    if (!await _connectivityService.isOnline) {
      throw NoInternetException();
    }

    final bool isSearch = query != null && query.trim().isNotEmpty;

    final uri = isSearch
        ? Uri.parse(ApiConstants.everything).replace(queryParameters: {
            'q': query,
            'page': '$page',
            'pageSize': '${ApiConstants.pageSize}',
            'sortBy': 'publishedAt',
            'apiKey': ApiConstants.apiKey,
          })
        : Uri.parse(ApiConstants.topHeadlines).replace(queryParameters: {
            'category': category,
            'country': ApiConstants.defaultCountry,
            'page': '$page',
            'pageSize': '${ApiConstants.pageSize}',
            'apiKey': ApiConstants.apiKey,
          });

    http.Response response;
    try {
      response = await _client.get(uri).timeout(const Duration(seconds: 15));
    } on async.TimeoutException {
      throw TimeoutException();
    } catch (_) {
      throw NoInternetException();
    }

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List articlesJson = body['articles'] as List? ?? [];
        return articlesJson
            .map((json) => Article.fromJson(
                  json as Map<String, dynamic>,
                  category: category,
                ))
            // NewsAPI sometimes returns "[Removed]" placeholder entries.
            .where((a) => a.title != '[Removed]' && a.url.isNotEmpty)
            .toList();
      } catch (_) {
        throw ParsingException();
      }
    } else if (response.statusCode == 401) {
      throw ApiException(
        'Invalid or missing API key. Add your NewsAPI key in lib/utils/constants.dart.',
        statusCode: 401,
      );
    } else if (response.statusCode == 429) {
      throw ApiException(
        'Rate limit reached. Please wait a moment and try again.',
        statusCode: 429,
      );
    } else {
      String message = 'Something went wrong (${response.statusCode}).';
      try {
        final body = jsonDecode(response.body);
        if (body['message'] != null) message = body['message'];
      } catch (_) {}
      throw ApiException(message, statusCode: response.statusCode);
    }
  }

  void dispose() => _client.close();
}
