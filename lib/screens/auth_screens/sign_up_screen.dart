import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xrun/screens/auth_screens/login_screen.dart';
import 'package:xrun/shared/colors.dart';
import 'package:xrun/shared/custom_buttom.dart';
import 'package:xrun/shared/custom_text_field.dart';
import 'package:xrun/utils/constant.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _fullNameController;
  late final TextEditingController _sportInterestController;
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool checkTermsAndConditions = false;
  double passwordStrength = 0;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _fullNameController = TextEditingController();
    _sportInterestController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _sportInterestController.dispose();

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
                    const SizedBox(
                      height: 50,
                    ),
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
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text('Login',
                              style: TextStyle(
                                color: xrunWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Text(
                          'Signup',
                          style: TextStyle(
                            color: xrunBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white38, thickness: 1),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Full Name',
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email can't be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      label: 'Sport Interest',
                      controller: _sportInterestController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email can't be empty";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
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
                    CustomButton(text: 'Login', onPressed: () {}),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: checkTermsAndConditions,
                          onChanged: (value) {
                            setState(() {
                              checkTermsAndConditions = value!;
                            });
                          },
                          activeColor: xrunBlue,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'By signing up, you agree to our ',
                                    style: GoogleFonts.poppins(
                                      color: xrunWhite,
                                      fontSize: 14,
                                    ),
                                  ),
                                  TextSpan(
                                      text: 'terms and conditions.',
                                      style: GoogleFonts.poppins(
                                        color: xrunBlue,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      )),
                                ],
                              ),
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
