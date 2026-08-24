import "package:flutter/material.dart";

/// Class to inject the dependencies in the application
class DependencyInjection {
  /// Inject the services in the application
  static Future<void> injectCriticalServices() async {
    WidgetsFlutterBinding.ensureInitialized();
    // await Supabase.initialize(
    //   url: FlavorConfig.instance.variables[EnvironmentConfig.supabaseUrlKey],
    //   anonKey:
    //       FlavorConfig.instance.variables[EnvironmentConfig.supabaseAnonKey],
    //   httpClient: SupabaseQueryLogger(),
    // );
  }

  /// Initialize the services in the application
  static Future<void> injectServices() async {
    // if (Platform.isAndroid) {
    //   await NotificationListenerService.init();
    // }

    //await LocalNotificationsService().initLocalNotificationsService();
  }

  /// Inject the repositories in the application
  ///
  /// This injects the repositories when the application is running
  /// These repositories are loaded during the splash screen
  static Future<void> injectRepositories() async {}
}
