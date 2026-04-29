import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String label;
  final String? hint;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInput({
    super.key,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
