import 'package:meta/meta.dart';

class AppConfig {
  String baseUrl;
  String buildFlavor;

  AppConfig({
    @required this.baseUrl,
    @required this.buildFlavor,
  });
}
