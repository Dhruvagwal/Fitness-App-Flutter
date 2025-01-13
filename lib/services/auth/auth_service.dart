import 'package:xrun/services/auth/auth_provider.dart';
import 'package:xrun/services/auth/auth_user.dart';
import 'package:xrun/services/auth/supabase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  AuthService(this.provider);
  factory AuthService.superBase() => AuthService(
        SupabaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser(
          {required String email, required String password}) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  AuthUser? get getCurrentUser => provider.getCurrentUser;

  @override
  Future<AuthUser> refreshUser(AuthUser user) => provider.refreshUser(user);

  @override
  Future<void> sendPasswordResetEmail({required String toEmail}) =>
      provider.sendPasswordResetEmail(
        toEmail: toEmail,
      );

  @override
  Future<AuthUser> signIn({required String email, required String password}) =>
      provider.signIn(
        email: email,
        password: password,
      );

  @override
  Future<void> signOut() => provider.signOut();

  @override
  AuthUser? get user => provider.user;

  @override
  Future<void> updatePassword({required String newPassword}) =>
      provider.updatePassword(newPassword: newPassword);

  @override
  Future<AuthUser> signInWithGoogle() => provider.signInWithGoogle();
}
