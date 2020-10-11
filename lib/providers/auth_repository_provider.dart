import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod_extended/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(read: ref.read);
});
