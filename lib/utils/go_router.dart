import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:xrun/bloc/auth_bloc.dart';
import 'package:xrun/bloc/events/auth_event_initialize.dart';
import 'package:xrun/bloc/states/auth_state.dart';
import 'package:xrun/bloc/states/auth_state_forgot_password.dart';
import 'package:xrun/bloc/states/auth_state_logged_in.dart';
import 'package:xrun/bloc/states/auth_state_logged_out.dart';
import 'package:xrun/bloc/states/auth_state_needs_verification.dart';
import 'package:xrun/bloc/states/auth_state_registering.dart';
import 'package:xrun/bloc/states/auth_state_uninitialized.dart';
import 'package:xrun/bloc/states/auth_state_update_password.dart';
import 'package:xrun/screens/auth_screens/forgot_password_screen.dart';
import 'package:xrun/screens/auth_screens/login_screen.dart';
import 'package:xrun/screens/auth_screens/sign_up_screen.dart';
import 'package:xrun/screens/auth_screens/update_password_screen.dart';
import 'package:xrun/screens/home_screens/home_screen.dart';
import 'package:xrun/screens/homescreen.dart';
import 'package:xrun/shared/loading_dialogs/loading_screen.dart';

GoRouter appRouter(BuildContext context) {
  final authBloc = BlocProvider.of<AuthBloc>(context);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: BlocGoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AuthStateLoggedIn;
      final isUnauthenticated = authBloc.state is AuthStateLoggedOut;
      final isRegistering = authBloc.state is AuthStateRegistering;
      final isUpdatingPassword = authBloc.state is AuthStateUpdatePassword;
      final isForgotPassword = authBloc.state is AuthStateForgotPassword;

      if (isUnauthenticated && state.matchedLocation != '/login') {
        return '/login';
      }

      if (isAuthenticated && state.matchedLocation == '/login') {
        return '/home';
      }

      if (isRegistering) {
        return '/register';
      }

      if (isForgotPassword) {
        return '/forgot-password';
      }

      if (isUpdatingPassword) {
        return '/update-password';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthStateUninitialized) {
                context.read<AuthBloc>().add(AuthEventInitialize());
                return LoadingScreen();
              }

              if (state is AuthStateForgotPassword) {
                return ForgotPasswordScreen();
              } else if (state is AuthStateRegistering) {
                return SignUpScreen();
              } else if (state is AuthStateUpdatePassword) {
                return UpdatePasswordScreen();
              } else if (state is AuthStateLoggedIn) {
                return Homescreen();
              } else if (state is AuthStateNeedsVerification) {
                return SignUpScreen();
              } else if (state is AuthStateLoggedOut) {
                return LoginScreen();
              }
              return const Scaffold(
                body: Center(
                  child: SpinKitSpinningLines(color: Colors.blue),
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/update-password',
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const SignUpScreen(),
      ),
    ],
  );
}

class BlocGoRouterRefreshStream extends ChangeNotifier {
  BlocGoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
