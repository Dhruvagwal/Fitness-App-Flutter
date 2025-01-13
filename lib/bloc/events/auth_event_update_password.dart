import 'package:xrun/bloc/events/auth_event.dart';

class AuthEventUpdatePassword extends AuthEvent {
  final String newPassword;

  const AuthEventUpdatePassword({required this.newPassword});
}
