import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links3/uni_links.dart';
import 'package:xrun/bloc/auth_bloc.dart';
import 'package:xrun/screens/auth_screens/forgot_password_screen.dart';
import 'package:xrun/screens/auth_screens/login_screen.dart';
import 'package:xrun/bloc/events/auth_event_initialize.dart';
import 'package:xrun/bloc/events/auth_event_update_password.dart';
import 'package:xrun/bloc/events/auth_event_verify_email.dart';
import 'package:xrun/bloc/states/auth_state.dart' as state;
import 'package:xrun/bloc/states/auth_state_forgot_password.dart';
import 'package:xrun/bloc/states/auth_state_logged_in.dart';
import 'package:xrun/bloc/states/auth_state_logged_out.dart';
import 'package:xrun/bloc/states/auth_state_needs_verification.dart';
import 'package:xrun/bloc/states/auth_state_registering.dart';
import 'package:xrun/bloc/states/auth_state_uninitialized.dart';
import 'package:xrun/bloc/states/auth_state_update_password.dart';
import 'package:xrun/screens/auth_screens/sign_up_screen.dart';
import 'package:xrun/screens/auth_screens/update_password_screen.dart';
import 'package:xrun/screens/homescreen.dart';
import 'package:xrun/services/auth/supabase_auth_provider.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/loading_dialogs/loading_dialog.dart';
import 'package:xrun/shared/loading_dialogs/loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(
          context,
          SupabaseAuthProvider(),
        ),
        child: AuthBlocHandler(),
      ),
    );
  }
}

class AuthBlocHandler extends StatefulWidget {
  const AuthBlocHandler({super.key});

  @override
  State<AuthBlocHandler> createState() => _AuthBlocHandlerState();
}

class _AuthBlocHandlerState extends State<AuthBlocHandler> {
  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }

      linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      }, onError: (err) {
        // Handle error
      });
    } catch (e) {
      // Handle exception
    }
  }

  void _handleDeepLink(String link) {
    if (link.contains('login-callback')) {
      context.read<AuthBloc>().add(AuthEventVerifyEmail());
    }
    if (link.contains('passwordreset-callback')) {
      context.read<AuthBloc>().add(AuthEventUpdatePassword(newPassword: ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, state.AuthState>(listener: (context, state) {
      if (state.message != null && state.message!.isError) {
        return LoadingDialog().show(
          context: context,
          text: state.message?.message ?? 'Please wait a moment',
        );
      } else {
        return LoadingDialog().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateUninitialized) {
        context.read<AuthBloc>().add(AuthEventInitialize());
        return LoadingScreen();
      } else if (state is AuthStateLoggedIn) {
        return Homescreen();
      } else if (state is AuthStateNeedsVerification) {
        return SignUpScreen();
      } else if (state is AuthStateLoggedOut) {
        return LoginScreen();
      } else if (state is AuthStateRegistering) {
        return SignUpScreen();
      } else if (state is AuthStateForgotPassword) {
        return ForgotPasswordScreen();
      } else if (state is AuthStateUpdatePassword) {
        return UpdatePasswordScreen();
      } else {
        return Scaffold(
          body: Center(
            child: SpinKitSpinningLines(
              color: xrunBlue,
            ),
          ),
        );
      }
    });
  }
}
