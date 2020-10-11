import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(mode: 'prod'),
    ),
  );
}
