import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_riverpod_extended/providers/auth_repository_provider.dart';

class AuthState {
  final bool loggingIn;
  final bool tryingAutoLogin;
  final bool authenticated;
  final String error;

  AuthState({
    this.loggingIn = false,
    this.tryingAutoLogin = false,
    this.authenticated = false,
    this.error = '',
  });

  AuthState copyWith({
    bool loggingIn,
    bool tryingAutoLogin,
    bool authenticated,
    String error,
  }) {
    return AuthState(
      loggingIn: loggingIn ?? this.loggingIn,
      tryingAutoLogin: tryingAutoLogin ?? this.tryingAutoLogin,
      authenticated: authenticated ?? this.authenticated,
      error: error ?? this.error,
    );
  }
}

final authProvider = StateNotifierProvider<Auth>((ref) {
  return Auth(read: ref.read);
});

class Auth extends StateNotifier<AuthState> {
  final Reader read;
  static AuthState initialAuthState = AuthState();
  Auth({this.read}) : super(initialAuthState);

  Future<void> login(String email, String password) async {
    state = state.copyWith(
      loggingIn: true,
      error: '',
    );

    try {
      await read(authRepositoryProvider).login(email, password);
      state = state.copyWith(
        loggingIn: false,
        authenticated: true,
      );
    } catch (e) {
      print(e);
      state = state.copyWith(
        loggingIn: false,
        error: e.toString(),
      );
    }
  }

  Future<void> tryAutoLogin() async {
    state = state.copyWith(
      tryingAutoLogin: true,
    );
    final bool authenticated =
        await read(authRepositoryProvider).tryAutoLogin();
    state = state.copyWith(
      tryingAutoLogin: false,
      authenticated: authenticated,
    );
  }

  Future<void> logout() async {
    await read(authRepositoryProvider).logout();
    state = state.copyWith(
      loggingIn: false,
      authenticated: false,
      error: '',
    );
  }
}

final authStateProvider = Provider<AuthState>((ref) {
  final AuthState auth = ref.watch(authProvider.state);

  return auth;
});
