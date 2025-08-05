/// App Information and Constants
///
/// This file contains app-wide constants and information
class AppInfo {
  // App Details
  static const String appName = "GroceryStore";
  static const String appVersion = "1.0.0";
  static const String appDescription = "A Flutter app for jersey management";

  // App Colors
  static const int primaryColor = 0xFF2196F3; // Blue
  static const int secondaryColor = 0xFF1976D2; // Dark Blue
  static const int accentColor = 0xFF03A9F4; // Light Blue

  // App Dimensions
  static const double defaultPadding = 16.0;
  static const double defaultMargin = 8.0;
  static const double borderRadius = 8.0;

  // App Text Styles
  static const String defaultFontFamily = "Roboto";
  static const double titleFontSize = 24.0;
  static const double subtitleFontSize = 18.0;
  static const double bodyFontSize = 14.0;

  // App Features
  static const bool enableDebugMode = true;
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;

  // App URLs
  static const String privacyPolicyUrl = "https://example.com/privacy";
  static const String termsOfServiceUrl = "https://example.com/terms";
  static const String supportEmail = "support@grocerystore.com";

  // App Storage Keys
  static const String userTokenKey = "user_token";
  static const String userDataKey = "user_data";
  static const String isLoggedInKey = "is_logged_in";
  static const String themeKey = "app_theme";
  static const String languageKey = "app_language";
}
