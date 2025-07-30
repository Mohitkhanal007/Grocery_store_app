enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment _environment = Environment.development;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static Environment get environment => _environment;

  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        // Try different common Jersey backend URLs
        return "http://10.0.2.2:2000/"; // Android emulator without /api
      case Environment.staging:
        return "https://your-staging-server.com/api/";
      case Environment.production:
        return "https://your-production-server.com/api/";
    }
  }

  static String get serverAddress {
    switch (_environment) {
      case Environment.development:
        return "http://10.0.2.2:2000";
      case Environment.staging:
        return "https://your-staging-server.com";
      case Environment.production:
        return "https://your-production-server.com";
    }
  }

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProduction => _environment == Environment.production;
}
