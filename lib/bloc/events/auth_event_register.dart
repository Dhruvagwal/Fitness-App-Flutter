import 'package:xrun/bloc/events/auth_event.dart';

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;

  AuthEventRegister({
    required this.email,
    required this.password,
  });
}
