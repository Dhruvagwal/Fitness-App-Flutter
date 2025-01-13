import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class AuthUser {
  final String email;
  final bool isEmailVerified;
  final String id;

  const AuthUser({
    required this.email,
    required this.isEmailVerified,
    required this.id,
  });

  factory AuthUser.fromSupabase(User user) => AuthUser(
        email: user.email ?? '',
        isEmailVerified: user.emailConfirmedAt != null,
        id: user.id,
      );

  AuthUser copyWith({
    String? email,
    bool? isEmailVerified,
    String? id,
  }) {
    return AuthUser(
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      id: id ?? this.id,
    );
  }
}
