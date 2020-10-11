import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'login_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import '../providers/city_provider.dart';
import '../providers/providers.dart';

// ℉', '℃'
class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 0), () {
      context.read(cityProvider).state = 'seoul';
      context.read(currentWeatherProvider).fetchWeather();
    });
    super.initState();
  }

  String calculateTemp(TemperatureUnit tempUnit, double temp) {
    if (tempUnit == TemperatureUnit.fahrenheit) {
      return ((temp * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }
    return temp.toStringAsFixed(2) + '℃';
  }

  Widget buildBody(
    WeatherState weatherState,
    TemperatureUnit tempUnit,
    BuildContext context,
  ) {
    if (weatherState == CurrentWeather.initialWeatherState) {
      return Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }

    if (weatherState.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (weatherState.weather == null) {
      return Center(
        child: Text(
          'Select a city',
          style: TextStyle(fontSize: 18.0),
        ),
      );
    }

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 6),
        Text(
          weatherState.weather.city,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          '${TimeOfDay.fromDateTime(weatherState.weather.lastUpdated).format(context)}',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 60.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              calculateTemp(tempUnit, weatherState.weather.theTemp),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Max: ' +
                      calculateTemp(tempUnit, weatherState.weather.maxTemp),
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Min: ' +
                      calculateTemp(tempUnit, weatherState.weather.minTemp),
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Text(
          weatherState.weather.weatherStateName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32.0,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await context.read(authProvider).logout();
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) {
                  return SettingsPage();
                }),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              context.read(cityProvider).state = await Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) {
                  return SearchPage();
                }),
              );

              print('City: ${context.read(cityProvider).state}');

              if (context.read(cityProvider).state != null) {
                final cwp = context.read(currentWeatherProvider);
                await cwp.fetchWeather();
              }
            },
          ),
        ],
      ),
      body: ProviderListener(
        provider: weatherStateProvider,
        onChange: (context, weather) {
          if (weather != null &&
              weather.error != null &&
              weather.error.isNotEmpty) {
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(weather.error),
                );
              },
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await context.read(currentWeatherProvider).fetchWeather();
          },
          child: Consumer(builder: (context, watch, child) {
            return buildBody(
              watch(weatherStateProvider),
              watch(settingsaProvider).state,
              context,
            );
          }),
        ),
      ),
    );
  }
}
