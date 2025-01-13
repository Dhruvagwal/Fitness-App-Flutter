import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xrun/screens/auth_screens/sign_up_screen.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/custom_buttom.dart';
import 'package:xrun/shared/custom_text_field.dart';
import 'package:xrun/utils/constant.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    return Scaffold(
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
                              fontSize: 30,
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
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
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
                    CustomTextField(
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
                    CustomTextField(
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
                          onPressed: () {},
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
                    CustomButton(text: 'Login', onPressed: () {}),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        _buildSocialButton(
                          "assets/auth/google.png",
                          () {
                            // Handle Google sign-in
                          },
                        ),
                        _buildSocialButton(
                          "assets/auth/apple.png",
                          () {
                            // Handle Facebook sign-in
                          },
                        ),
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
                          onPressed: () {},
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
    );
  }
}
