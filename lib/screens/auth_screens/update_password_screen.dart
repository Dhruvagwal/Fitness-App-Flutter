import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xrun/bloc/auth_bloc.dart';
import 'package:xrun/bloc/events/auth_event_logout.dart';
import 'package:xrun/bloc/events/auth_event_update_password.dart';
import 'package:xrun/bloc/states/auth_state.dart';
import 'package:xrun/bloc/states/auth_state_update_password.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/buttons/custom_auth_button.dart';
import 'package:xrun/shared/show_snackbar.dart';
import 'package:xrun/shared/text_fields/custom_auth_text_field.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  double passwordStrength = 0;
  late final TextEditingController _passwordController;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _checkPasswordStrength(String password) {
    double strength = 0;
    if (password.isNotEmpty) {
      strength += 0.25;
      if (password.length >= 8) strength += 0.25;
      if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.25;
      if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.25;
    }
    setState(() {
      passwordStrength = strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateUpdatePassword) {
          if (state.hasUpdatedPassword) {
            _passwordController.clear();
            await showSnackbar(
              context,
              'Password reset link sent',
              type: SnackbarType.success,
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
                        'Update Password',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.09,
                            fontWeight: FontWeight.bold,
                            color: xrunWhite),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Provide your updated password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.06,
                          color: xrunWhite,
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomAuthTextField(
                        label: 'Password',
                        onChanged: _checkPasswordStrength,
                        controller: _passwordController,
                        obscureText: true,
                        isVisible: _isPasswordVisible,
                        onVisibilityToggle: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: LinearProgressIndicator(
                              value: passwordStrength,
                              backgroundColor: xrunGrey,
                              color: passwordStrength > 0.75
                                  ? xrunBlue
                                  : passwordStrength > 0.5
                                      ? xrunBlue
                                      : xrunBlue,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            passwordStrength > 0.75
                                ? 'Strong'
                                : passwordStrength > 0.5
                                    ? 'Not Strong'
                                    : 'Weak',
                            style: TextStyle(color: xrunGrey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomAuthButton(
                        text: 'Update Password',
                        onPressed: () {
                          if (passwordStrength < 0.5) {
                            showSnackbar(
                              context,
                              'Password is too weak',
                              type: SnackbarType.error,
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            final newPassword = _passwordController.text;
                            context.read<AuthBloc>().add(
                                  AuthEventUpdatePassword(
                                      newPassword: newPassword),
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
