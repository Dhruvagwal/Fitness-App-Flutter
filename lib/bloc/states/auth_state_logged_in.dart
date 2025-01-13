import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';
import 'package:xrun/services/auth/auth_user.dart';

class AuthStateLoggedIn extends AuthState {
  final AuthUser authUser;

  const AuthStateLoggedIn({
    super.message,
    required this.authUser,
  });
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateLoggedIn(
      authUser: authUser,
      message: message,
    );
  }
}
