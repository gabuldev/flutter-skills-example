/// Compile-time configuration.
///
/// These are `const` and resolved by the compiler, so a missing
/// `--dart-define` is NOT an error - it is the empty string. That is why
/// [isConfigured] exists and why the app says so on screen instead of failing
/// with a confusing network error.
abstract final class AppEnv {
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Agenda',
  );

  static bool get isConfigured => baseUrl.isNotEmpty;
}
