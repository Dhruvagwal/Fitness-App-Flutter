import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:xrun/services/auth/auth_exceptions.dart';
import 'package:xrun/services/auth/auth_provider.dart';
import 'package:xrun/services/auth/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseAuthProvider implements AuthProvider {
  final _supabase = supabase.Supabase.instance.client;
  AuthUser? _userFromSuperbaseUser(supabase.User? user) {
    return user != null
        ? AuthUser(
            email: user.email ?? '',
            isEmailVerified: user.emailConfirmedAt != null,
            id: user.id,
          )
        : null;
  }

  @override
  AuthUser? get getCurrentUser {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return AuthUser.fromSupabase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> refreshUser(AuthUser user) async {
    final refreshedSession = await _supabase.auth.refreshSession();
    final refreshedUser = refreshedSession.user;
    if (refreshedUser != null) {
      var refreshedAuthUser = user.copyWith(
        isEmailVerified: refreshedUser.emailConfirmedAt != null,
      );
      return refreshedAuthUser;
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String toEmail}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        toEmail,
        redirectTo: 'io.supabase.flutterquickstart://passwordreset-callback/',
      );
    } on supabase.AuthException catch (e) {
      debugPrint(e.toString());
      throw GenericAuthException();
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> signIn(
      {required String email, required String password}) async {
    try {
      final loggedInUser = await _supabase.auth.signInWithPassword(
        password: password,
        email: email,
      );

      supabase.User? user = loggedInUser.user;
      if (user != null) {
        return AuthUser.fromSupabase(user);
      } else {
        throw UserNotLoggedInAuthException();
      }
    } on supabase.AuthException catch (e) {
      debugPrint(e.toString());
      throw GenericAuthException();
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> signOut() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return _supabase.auth.signOut();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) async {
    try {
      final createdUser = await _supabase.auth.signUp(
          password: password,
          email: email,
          emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/');

      final authUser = _userFromSuperbaseUser(createdUser.user);
      if (authUser == null) {
        throw GenericAuthException();
      }

      return authUser;
    } on supabase.AuthException catch (e) {
      debugPrint(e.toString());
      throw GenericAuthException();
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get user => _userFromSuperbaseUser(_supabase.auth.currentUser);

  @override
  Future<void> updatePassword({required String newPassword}) async {
    try {
      await _supabase.auth.updateUser(
        supabase.UserAttributes(password: newPassword),
      );
    } on supabase.AuthException catch (e) {
      debugPrint(e.toString());
      throw GenericAuthException();
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    const webClientId =
        '51632356470-1hiep725n3281koa7bk9ue3bec3ipkps.apps.googleusercontent.com';

    const iosClientId =
        '51632356470-tct7rnooc05sk14ekeac5gd3b9auchep.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    final response = await _supabase.auth.signInWithIdToken(
      provider: supabase.OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    final user = response.user;

    if (user == null) {
      throw GenericAuthException();
    }

    return AuthUser.fromSupabase(user);
  }
}
