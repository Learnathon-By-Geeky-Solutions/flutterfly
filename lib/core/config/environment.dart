import 'flavor.dart';

/*
    Environment class manages the current app flavor and environment-specific
    variables
*/

class Environment {
  static late Flavor appFlavor;

  static String get flavorName {
    switch (appFlavor) {
      case Flavor.dev:
        return 'Development';
      case Flavor.staging:
        return 'Staging';
      case Flavor.prod:
        return 'Production';
      }
  }

  static bool get isDev => appFlavor == Flavor.dev;
  static bool get isStaging => appFlavor == Flavor.staging;
  static bool get isProd => appFlavor == Flavor.prod;
}