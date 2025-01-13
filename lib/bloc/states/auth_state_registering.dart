import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({
    super.message,
    required this.exception,
  });

  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateRegistering(
      exception: exception,
      message: message,
    );
  }
}
