import 'package:xrun/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get getCurrentUser;

  AuthUser? get user;

  Future<AuthUser> createUser({
    required String email,
    required String password,
  });

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({
    required String toEmail,
  });

  Future<AuthUser> refreshUser(
    AuthUser user,
  );

  Future<void> updatePassword({
    required String newPassword,
  });

  Future<AuthUser> signInWithGoogle();
}
