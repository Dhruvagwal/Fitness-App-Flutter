import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xrun/bloc/auth_bloc.dart';
import 'package:xrun/bloc/events/auth_event_forgot_password.dart';
import 'package:xrun/bloc/events/auth_event_logout.dart';
import 'package:xrun/bloc/states/auth_state.dart';
import 'package:xrun/bloc/states/auth_state_forgot_password.dart';
import 'package:xrun/services/auth/auth_exceptions.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/buttons/custom_auth_button.dart';
import 'package:xrun/shared/show_snackbar.dart';
import 'package:xrun/shared/text_fields/custom_auth_text_field.dart';
import 'package:xrun/utils/constant.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _emailController.clear();
            await showSnackbar(
              context,
              'Password reset link sent to your registered email',
              type: SnackbarType.success,
            );
          }
          if (state.exception is UserNotFoundAuthException) {
            await showSnackbar(
              context,
              'User not found',
              type: SnackbarType.error,
            );
          }

          if (state.exception != null) {
            await showSnackbar(
              context,
              'Please check your credentials, and try again',
              type: SnackbarType.error,
            );
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/app_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/shared/app_icon.png'),
                      const SizedBox(height: 40),
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.09,
                            fontWeight: FontWeight.bold,
                            color: xrunWhite),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Provide your email address to reset your password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: xrunWhite,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomAuthTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty";
                          } else if (!emailValid.hasMatch(value)) {
                            return "Invalid email provided";
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomAuthButton(
                        text: 'Reset Password',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthEventForgotPassword(
                                    email: _emailController.text,
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthEventLogout());
                        },
                        child: Text(
                          'Back to login',
                          style: TextStyle(color: xrunBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
