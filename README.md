# Loop — News & Article Reader

A Flutter news reader with a warm, editorial-style UI (serif headlines,
amber accent, category-tinted cards), live REST API integration,
pagination, search, category filtering, and offline bookmarking.

<img width="1791" height="820" alt="image" src="https://github.com/user-attachments/assets/2722d085-4c23-4b9c-90f0-50e21dad2ac7" />


## ⚠️ Important — This folder ships `lib/` + config only

This container has no Flutter SDK, so `android/`, `ios/`, `web/`, etc.
platform folders could not be generated here. To run the app:

```bash
# 1. Unzip this project, then inside the folder:
flutter create . --project-name news_reader_app --org com.example

# This regenerates platform folders (android/ios/web/etc.) WITHOUT
# touching the lib/, pubspec.yaml, or README you already have —
# flutter create is safe to run on an existing project directory.

# 2. Add your free NewsAPI key:
#    Get one at https://newsapi.org/register
#    Paste it into lib/utils/constants.dart -> ApiConstants.apiKey

# 3. Install dependencies
flutter pub get

# 4. Run
flutter run
```

> Note: NewsAPI's free "Developer" plan only allows requests from
> `localhost` for the `/everything` (search) endpoint when called from
> a browser, but works fine from a mobile/desktop app. If you hit
> 426/401 errors, double check your key and plan at newsapi.org.
> You can swap in GNews or any similar API by editing `api_service.dart`
> and `constants.dart` — the rest of the app doesn't care where the
> JSON comes from as long as `Article.fromJson` can parse it.

## Features implemented

- **API integration** — `http` package, `/top-headlines` for category
  feeds and `/everything` for search, parsed into a typed `Article` model.
- **Home feed** — infinite-scroll paginated list with thumbnail, title,
  source, and relative published time. A "featured" wide card appears
  every 5th item for visual rhythm.
- **Article detail** — hero image transition, full description/content,
  "Read full article" (opens in browser via `url_launcher`), share
  (`share_plus`), bookmark toggle.
- **Search** — expandable search field in the app bar, hits the API's
  search endpoint.
- **Category filter** — horizontal chip selector (general, technology,
  business, sports, entertainment, health, science).
- **Bookmarks / offline reading** — saved articles are stored as JSON in
  Hive and remain fully viewable with no internet connection.
- **Loading / empty / error states** — shimmer skeleton feed while
  loading, friendly empty state, error state with retry button.
- **Pull-to-refresh** on the home feed.
- **Bonus:** light/dark theme toggle, offline last-feed caching (shows
  an amber "offline" banner and your last successful feed if the network
  drops), share article link.

## Packages used

| Package | Purpose |
|---|---|
| `http` | REST API calls |
| `provider` | State management |
| `hive` / `hive_flutter` | Local storage for bookmarks & feed cache |
| `connectivity_plus` | Detect online/offline state |
| `google_fonts` | Playfair Display + Inter typography |
| `cached_network_image` | Image loading/caching with placeholders |
| `shimmer` | Skeleton loading placeholders |
| `intl` | Date formatting |
| `share_plus` | Share article links |
| `url_launcher` | Open the original article in a browser |

## Project structure

```
lib/
├── main.dart
├── models/
│   └── article.dart
├── services/
│   ├── api_service.dart
│   ├── storage_service.dart
│   ├── connectivity_service.dart
│   └── app_exceptions.dart
├── providers/
│   ├── article_provider.dart
│   ├── bookmark_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── root_screen.dart
│   ├── home_screen.dart
│   ├── article_detail_screen.dart
│   └── bookmarks_screen.dart
├── widgets/
│   ├── article_card.dart
│   ├── category_selector.dart
│   ├── shimmer_loading.dart
│   └── state_widgets.dart
└── utils/
    ├── constants.dart
    └── app_theme.dart
```

## Design notes

The UI leans into an "editorial" identity rather than a generic
Material list: warm paper background, burnt-amber accent, a serif
display face (Playfair Display) for headlines paired with Inter for
body copy, and per-category accent colors used consistently across
badges, bookmark icons, and buttons. Every fifth card in the feed uses
a larger "featured" layout to break up the rhythm of the list, similar
to how print/magazine layouts vary story prominence.
