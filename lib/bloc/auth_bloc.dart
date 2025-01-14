import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:xrun/bloc/events/auth_event.dart';
import 'package:xrun/bloc/events/auth_event_forgot_password.dart';
import 'package:xrun/bloc/events/auth_event_initialize.dart';
import 'package:xrun/bloc/events/auth_event_login.dart';
import 'package:xrun/bloc/events/auth_event_logout.dart';
import 'package:xrun/bloc/events/auth_event_register.dart';
import 'package:xrun/bloc/events/auth_event_should_register.dart';
import 'package:xrun/bloc/events/auth_event_signin_with_google.dart';
import 'package:xrun/bloc/events/auth_event_update_password.dart';
import 'package:xrun/bloc/events/auth_event_verify_email.dart';
import 'package:xrun/bloc/state_message.dart';
import 'package:xrun/bloc/states/auth_state.dart';
import 'package:xrun/bloc/states/auth_state_forgot_password.dart';
import 'package:xrun/bloc/states/auth_state_logged_in.dart';
import 'package:xrun/bloc/states/auth_state_logged_out.dart';
import 'package:xrun/bloc/states/auth_state_needs_verification.dart';
import 'package:xrun/bloc/states/auth_state_registering.dart';
import 'package:xrun/bloc/states/auth_state_uninitialized.dart';
import 'package:xrun/bloc/states/auth_state_update_password.dart';
import 'package:xrun/services/auth/auth_exceptions.dart';
import 'package:xrun/services/auth/auth_provider.dart';
import 'package:xrun/services/auth/supabase_auth_provider.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  BuildContext context;

  AuthBloc(this.context, AuthProvider authProvider)
      : super(AuthStateUninitialized(
          message: StateMessage(
            'State uninitialized',
            isError: true,
          ),
        )) {
    on<AuthEventInitialize>((event, emit) async {
      final authUser = (authProvider as SupabaseAuthProvider).getCurrentUser;
      if (authUser == null) {
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Please wait till we initialize',
            isError: false,
          ),
        ));
      } else if (!authUser.isEmailVerified) {
        emit(const AuthStateNeedsVerification(
          message: StateMessage(
            'Please verify your email',
            isError: false,
          ),
        ));
      } else {
        emit(AuthStateLoggedIn(
          authUser: authUser,
          message: StateMessage(
            'Logged in',
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventShouldRegister>((event, emit) {
      emit(const AuthStateRegistering(
        exception: null,
        message: StateMessage(
          'Please register',
          isError: false,
        ),
      ));
    });

    on<AuthEventLogout>((event, emit) async {
      try {
        await authProvider.signOut();
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Logged out',
            isError: false,
          ),
        ));
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await authProvider.createUser(
          email: email,
          password: password,
        );
        emit(AuthStateNeedsVerification(
          message: StateMessage(
            'Please verify your email',
            isError: false,
          ),
        ));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventLogin>((event, emit) async {
      emit(const AuthStateLoggedOut(
        exception: null,
        message: StateMessage(
          'Logged you out',
          isError: false,
        ),
      ));

      final email = event.email;
      final password = event.password;

      try {
        final authUser = await authProvider.signIn(
          email: email,
          password: password,
        );
        if (!authUser.isEmailVerified) {
          emit(AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Please verify your email',
              isError: false,
            ),
          ));
          emit(const AuthStateNeedsVerification(
            message: StateMessage(
              'Please verify your email',
              isError: false,
            ),
          ));
        } else if (authUser.isEmailVerified) {
          emit(AuthStateLoggedIn(
            authUser: authUser,
            message: StateMessage(
              'Logged in successfully',
              isError: false,
            ),
          ));
        } else {
          emit(const AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Logged you out',
              isError: false,
            ),
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventVerifyEmail>((event, emit) async {
      try {
        var authUser = authProvider.getCurrentUser;
        if (authUser == null) {
          emit(const AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'User not found',
              isError: false,
            ),
          ));
          return;
        }

        authUser = await authProvider.refreshUser(authUser);
        if (authUser.isEmailVerified) {
          emit(AuthStateLoggedOut(
            exception: null,
            message: StateMessage(
              'Email verified! You can now log in.',
              isError: false,
            ),
          ));
        } else {
          emit(const AuthStateNeedsVerification(
            message: StateMessage(
              'Please verify your email',
              isError: false,
            ),
          ));
        }
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          exception: e,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        hasSentEmail: false,
        exception: null,
        message: StateMessage(
          'Click here to reset your password',
          isError: false,
        ),
      ));

      final email = event.email;
      if (email == null) {
        return;
      }
      emit(
        const AuthStateForgotPassword(
          hasSentEmail: false,
          exception: null,
          message: StateMessage(
            'Please provide your registered email to receive a password reset link',
            isError: false,
          ),
        ),
      );
      bool didSendEmail;
      Exception? exception;

      try {
        await authProvider.sendPasswordResetEmail(toEmail: email);
        didSendEmail = true;
        exception = null;
        emit(AuthStateForgotPassword(
          message: StateMessage(
            'A password reset link has been sent to $email',
            isError: false,
          ),
          hasSentEmail: didSendEmail,
          exception: null,
        ));
      } on UserNotFoundAuthException catch (_) {
        didSendEmail = false;
        exception = UserNotFoundAuthException();
        emit(AuthStateForgotPassword(
          message: StateMessage(
            'User not found',
            isError: true,
          ),
          hasSentEmail: didSendEmail,
          exception: exception,
        ));
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
        emit(AuthStateForgotPassword(
          message: StateMessage(
            'A password reset link has been sent to $email',
            isError: false,
          ),
          hasSentEmail: didSendEmail,
          exception: exception,
        ));
      }
    });

    on<AuthEventUpdatePassword>((event, emit) async {
      try {
        final updatedPassword = event.newPassword;
        await authProvider.updatePassword(newPassword: updatedPassword);
        emit(const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Password updated',
            isError: false,
          ),
        ));
      } on Exception catch (e) {
        emit(AuthStateUpdatePassword(
          exception: e,
          hasUpdatedPassword: false,
          message: StateMessage(
            e.toString(),
            isError: false,
          ),
        ));
      }
    });

    on<AuthEventSignInWithGoogle>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          message: StateMessage(
            'Logging in with Google',
            isError: false,
          ),
        ),
      );
      try {
        var user = await authProvider.signInWithGoogle();
        emit(AuthStateLoggedIn(authUser: user));
      } on Exception catch (e) {
        AuthStateLoggedOut(
          exception: e,
          message: StateMessage(
            'Loggin failed',
            isError: false,
          ),
        );
      }
    });
  }
}
