import 'package:flutter/material.dart';
import 'package:xrun/shared/colors.dart';

class ViewAllComponent extends StatelessWidget {
  final String eventTitle;
  final String buttonText;
  final Function() onTap;
  const ViewAllComponent({
    super.key,
    required this.eventTitle,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          eventTitle,
          style: TextStyle(
            color: xrunWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            buttonText,
            style: TextStyle(
              color: xrunBlue,
              fontSize: 20,
            ),
          ),
        )
      ],
    );
  }
}
