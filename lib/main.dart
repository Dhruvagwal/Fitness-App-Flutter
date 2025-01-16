import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uni_links3/uni_links.dart';
import 'package:xrun/bloc/auth_bloc.dart';
import 'package:xrun/bloc/events/auth_event_update_password.dart';
import 'package:xrun/bloc/events/auth_event_verify_email.dart';
import 'package:xrun/bloc/states/auth_state.dart' as state;
import 'package:xrun/services/auth/supabase_auth_provider.dart';
import 'package:xrun/shared/loading_dialogs/loading_dialog.dart';
import 'package:xrun/utils/go_router.dart';

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
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(
        context,
        SupabaseAuthProvider(),
      ),
      child: Builder(
        builder: (context) {
          final goRouter = appRouter(context);

          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            routerConfig: goRouter,
          );
        },
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
      // Listen for the initial deep link
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }

      // Listen for new deep links
      linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      }, onError: (err) {
        // Handle error
        debugPrint('Error handling deep link: $err');
      });
    } catch (e) {
      debugPrint('Exception handling deep link: $e');
    }
  }

  void _handleDeepLink(String link) {
    final authBloc = context.read<AuthBloc>();

    if (link.contains('login-callback')) {
      authBloc.add(AuthEventVerifyEmail());
    } else if (link.contains('passwordreset-callback')) {
      authBloc.add(AuthEventUpdatePassword(newPassword: ''));
    } else {
      debugPrint('Unhandled deep link: $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, state.AuthState>(
      listener: (context, state) {
        if (state.message != null && state.message!.isError) {
          LoadingDialog().show(
            context: context,
            text: state.message?.message ?? 'Please wait a moment',
          );
        } else {
          LoadingDialog().hide();
        }
      },
      builder: (context, state) {
        // Delegate routing to the router based on AuthBloc state
        return Router(
          routerDelegate: appRouter(context).routerDelegate,
          routeInformationParser: appRouter(context).routeInformationParser,
          routeInformationProvider: appRouter(context).routeInformationProvider,
        );
      },
    );
  }
}
