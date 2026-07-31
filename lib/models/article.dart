/// Represents a single news article.
///
/// [url] is used as the unique identifier throughout the app (for
/// bookmarking, caching, and list keys) since NewsAPI does not provide
/// a stable numeric id.
class Article {
  final String title;
  final String? description;
  final String? content;
  final String url;
  final String? imageUrl;
  final String? sourceName;
  final String? author;
  final DateTime publishedAt;
  final String category;

  Article({
    required this.title,
    this.description,
    this.content,
    required this.url,
    this.imageUrl,
    this.sourceName,
    this.author,
    required this.publishedAt,
    this.category = 'general',
  });

  factory Article.fromJson(Map<String, dynamic> json, {String category = 'general'}) {
    return Article(
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? json['title']
          : 'Untitled article',
      description: json['description'] as String?,
      content: json['content'] as String?,
      url: json['url'] as String? ?? '',
      imageUrl: json['urlToImage'] as String?,
      sourceName: (json['source'] as Map<String, dynamic>?)?['name'] as String?,
      author: json['author'] as String?,
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
          DateTime.now(),
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': imageUrl,
      'source': {'name': sourceName},
      'author': author,
      'publishedAt': publishedAt.toIso8601String(),
      'category': category,
    };
  }

  Article copyWith({String? category}) {
    return Article(
      title: title,
      description: description,
      content: content,
      url: url,
      imageUrl: imageUrl,
      sourceName: sourceName,
      author: author,
      publishedAt: publishedAt,
      category: category ?? this.category,
    );
  }

  @override
  bool operator ==(Object other) => other is Article && other.url == url;

  @override
  int get hashCode => url.hashCode;
}
