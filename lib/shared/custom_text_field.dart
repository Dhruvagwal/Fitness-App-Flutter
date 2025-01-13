import 'package:flutter/material.dart';
import 'package:xrun/shared/colors.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? initialValue;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final Color? labelColor;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool? isVisible;
  final VoidCallback? onVisibilityToggle;

  const CustomTextField({
    super.key,
    required this.label,
    this.onChanged,
    required this.controller,
    this.initialValue = '',
    this.obscureText = false,
    this.enabled = true,
    this.textInputAction,
    this.keyboardType,
    this.validator,
    this.labelColor,
    this.isVisible,
    this.onVisibilityToggle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = widget.isVisible ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText && !_isPasswordVisible,
      onChanged: widget.onChanged,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      style: TextStyle(color: Colors.white), // Set the text color to white
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
            color: widget.labelColor ?? xrunWhite), // Set the label color
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: xrunLightGreen),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: xrunLightGreen),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        suffixIcon: widget.onVisibilityToggle != null
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                  if (widget.onVisibilityToggle != null) {
                    widget.onVisibilityToggle!();
                  }
                },
              )
            : null,
      ),
    );
  }
}
