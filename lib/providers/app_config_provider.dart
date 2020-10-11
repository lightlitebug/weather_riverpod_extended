import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod_extended/models/app_config.dart';

final appConfigProvider = StateProvider<AppConfig>((ref) {
  const String kPort = '3010';
  final String baseUrl =
      Platform.isAndroid ? 'http://10.0.2.2:$kPort' : 'http://localhost:$kPort';

  return AppConfig(baseUrl: baseUrl, buildFlavor: 'dev');
});
