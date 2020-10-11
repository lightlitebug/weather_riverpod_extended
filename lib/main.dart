import 'package:flutter/material.dart';
import 'package:weather_riverpod_extended/pages/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod_extended/providers/providers.dart';

import 'pages/home_page.dart';

class MyApp extends StatelessWidget {
  final String mode;

  const MyApp({Key key, this.mode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('mode: $mode');
    context.read(appConfigProvider).state.buildFlavor = mode;

    return MaterialApp(
      title: 'Riverpod Weather',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
      },
    );
  }
}
