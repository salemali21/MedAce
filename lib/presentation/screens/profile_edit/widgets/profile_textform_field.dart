import 'package:flutter/material.dart';

class ProfileTextFormField extends StatelessWidget {
  const ProfileTextFormField({
    super.key,
    required this.labelText,
    required this.focusNode,
    required this.controller,
    required this.enabled,
    required this.readOnly,
    required this.cursorColor,
    required this.borderSideColor,
  });

  final String labelText;
  final bool focusNode;
  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final Color cursorColor;
  final Color borderSideColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        labelText: labelText,
        filled: true,
        labelStyle: TextStyle(
          color: focusNode ? Colors.black : Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderSideColor, width: 2),
        ),
      ),
    );
  }
}
