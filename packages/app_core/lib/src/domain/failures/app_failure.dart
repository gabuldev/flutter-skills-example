/// A failure the UI is expected to handle and show.
///
/// The data layer catches transport exceptions (`DioException`, a parse error)
/// and rethrows one of these, so nothing above the repository has to know what
/// HTTP is.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => '\$runtimeType: \$message';
}

/// The device could not reach the API at all.
class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No connection. Check your network.']);
}

/// The API answered, and the answer was an error.
class ServerFailure extends AppFailure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

/// The request was rejected because the input was invalid.
class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, {this.fieldErrors = const {}});

  final Map<String, String> fieldErrors;
}
