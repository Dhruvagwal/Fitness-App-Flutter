import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';

class AuthStateForgotPassword extends AuthState {
  final bool hasSentEmail;
  final Exception? exception;

  const AuthStateForgotPassword({
    super.message,
    required this.hasSentEmail,
    required this.exception,
  });
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateForgotPassword(
      message: message,
      hasSentEmail: hasSentEmail,
      exception: exception,
    );
  }
}
