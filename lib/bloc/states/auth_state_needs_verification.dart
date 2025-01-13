import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({super.message});
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateNeedsVerification(message: message);
  }
}
