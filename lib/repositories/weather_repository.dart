import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/weather.dart';
import '../providers/providers.dart';

class WeatherRepository {
  final Reader read;

  WeatherRepository({this.read});

  Future<Weather> getWeather() async {
    final String city = read(cityProvider).state;

    try {
      final int locationId =
          await read(weatherApiClientProvider).getLocationId(city);

      return await read(weatherApiClientProvider).fetchWeather(locationId);
    } catch (e) {
      throw e.toString();
    }
  }
}
