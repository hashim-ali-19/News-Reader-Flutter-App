/// Base class for all app-level exceptions so the UI layer can branch
/// on a friendly [message] without knowing about http/dio internals.
abstract class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  NoInternetException()
      : super('No internet connection. Check your network and try again.');
}

class TimeoutException extends AppException {
  TimeoutException() : super('The request timed out. Please try again.');
}

class ApiException extends AppException {
  final int? statusCode;
  ApiException(String message, {this.statusCode}) : super(message);
}

class ParsingException extends AppException {
  ParsingException() : super('Something went wrong reading the response.');
}
