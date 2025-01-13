import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;

  const AuthStateLoggedOut({
    super.message,
    required this.exception,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateLoggedOut(
      exception: exception,
      message: message,
    );
  }
}
