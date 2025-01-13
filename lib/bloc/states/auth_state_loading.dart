import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';

class AuthStateLoading extends AuthState {
  const AuthStateLoading({super.message});
  @override
  AuthState copyWith({StateMessage? message, bool? isLoading}) {
    return AuthStateLoading(message: message);
  }
}
