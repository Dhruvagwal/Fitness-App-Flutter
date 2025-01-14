import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:xrun/shared/colors.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: xrunBlack,
      body: Center(
        child: SpinKitSpinningLines(
          color: xrunBlue,
          size: 150,
        ),
      ),
    );
  }
}
