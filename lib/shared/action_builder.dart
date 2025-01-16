import 'package:flutter/material.dart';
import 'package:xrun/shared/colors.dart';

class ActionBuilder extends StatelessWidget {
  final IconData icon;
  final String label;
  final void Function() onTap;
  const ActionBuilder({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        width: 100,
        decoration: BoxDecoration(
          color: xrunMediumGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: xrunWhite,
              size: 30,
            ),
            Text(
              label,
              style: TextStyle(
                color: xrunWhite,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
