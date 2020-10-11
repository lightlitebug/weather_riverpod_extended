import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/weather_repository.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  print('>>> In weatherRepositoryProvider');
  return WeatherRepository(read: ref.read);
});
