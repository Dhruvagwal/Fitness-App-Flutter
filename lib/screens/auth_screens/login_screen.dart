import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xrun/bloc/auth_bloc.dart';
import 'package:xrun/bloc/events/auth_event_forgot_password.dart';
import 'package:xrun/bloc/events/auth_event_login.dart';
import 'package:xrun/bloc/events/auth_event_should_register.dart';
import 'package:xrun/bloc/events/auth_event_signin_with_google.dart';
import 'package:xrun/bloc/states/auth_state.dart';
import 'package:xrun/bloc/states/auth_state_logged_out.dart';
import 'package:xrun/services/auth/auth_exceptions.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/buttons/custom_auth_button.dart';
import 'package:xrun/shared/show_snackbar.dart';
import 'package:xrun/shared/text_fields/custom_auth_text_field.dart';
import 'package:xrun/utils/constant.dart';
import 'package:xrun/utils/shared_preferrence_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool rememberMe = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSaveCredentials();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadSaveCredentials() async {
    final savedEmail = await SharedPreferrenceHelper.getString('email');
    final savedPassword = await SharedPreferrenceHelper.getString('password');
    final savedRememberMe =
        await SharedPreferrenceHelper.getBool('remember_me') ?? false;

    if (savedRememberMe) {
      setState(() {
        _emailController.text = savedEmail ?? '';
        _passwordController.text = savedPassword ?? '';
        rememberMe = savedRememberMe;
      });
    }
  }

  Future<void> _saveCredentials() async {
    if (rememberMe) {
      await SharedPreferrenceHelper.setString('email', _emailController.text);
      await SharedPreferrenceHelper.setString(
          'password', _passwordController.text);
      await SharedPreferrenceHelper.setBool('remember_me', rememberMe);
    } else {
      await SharedPreferrenceHelper.remove('email');
      await SharedPreferrenceHelper.remove('password');
      await SharedPreferrenceHelper.remove('remember_me');
    }
  }

  Widget _buildSocialButton(String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: xrunMediumGreen,
          border: Border.all(
            width: 1,
            color: xrunLightGreen,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Image.asset(
          assetPath,
          width: 30,
          height: 30,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          await _saveCredentials();
          if (state.exception is UserNotFoundAuthException) {
            await showSnackbar(
              context,
              'User not found',
              type: SnackbarType.error,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showSnackbar(
              context,
              'Cannot find a user with the credentials',
              type: SnackbarType.error,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showSnackbar(
              context,
              'Wrong Credentials',
              type: SnackbarType.error,
            );
          } else if (state.exception is GenericAuthException) {
            await showSnackbar(
              context,
              'Authentication failed',
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Image.asset('assets/shared/app_icon.png'),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Welcome to ',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: xrunWhite,
                                ),
                              ),
                              TextSpan(
                                text: 'X.Run',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.09,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  color: xrunBlue,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Login here with your username and password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            color: xrunWhite,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Login',
                                style: TextStyle(
                                  color: xrunBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )),
                            GestureDetector(
                              onTap: () {
                                context.read<AuthBloc>().add(
                                      AuthEventShouldRegister(),
                                    );
                              },
                              child: Text(
                                'Signup',
                                style: TextStyle(
                                  color: xrunWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white38, thickness: 1),
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
                        const SizedBox(height: 20),
                        CustomAuthTextField(
                          label: 'Password',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value!;
                                    });
                                  },
                                  activeColor: Color(0xFF00D9A5),
                                  checkColor: Colors.black,
                                ),
                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: xrunGrey,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                      AuthEventForgotPassword(),
                                    );
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: xrunGrey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomAuthButton(
                          text: 'Login',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text;
                              final password = _passwordController.text;
                              context.read<AuthBloc>().add(
                                    AuthEventLogin(
                                      email: email,
                                      password: password,
                                    ),
                                  );
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: xrunLightGreen,
                                thickness: 2,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'Or',
                                style: TextStyle(color: xrunGrey, fontSize: 20),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: xrunLightGreen,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // google sign in
                            _buildSocialButton(
                              "assets/auth/google.png",
                              () {
                                context.read<AuthBloc>().add(
                                      AuthEventSignInWithGoogle(),
                                    );
                              },
                            ),
                            // apple sign in
                            _buildSocialButton(
                              "assets/auth/apple.png",
                              () {
                                // Handle apple sign-in
                              },
                            ),
                            // fb sign in
                            _buildSocialButton(
                              "assets/auth/facebook.png",
                              () {
                                // Handle Facebook sign-in
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don’t have any account? ",
                              style: TextStyle(
                                color: xrunWhite,
                                fontSize: 16,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AuthBloc>().add(
                                      AuthEventShouldRegister(),
                                    );
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(
                                  color: xrunBlue,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
