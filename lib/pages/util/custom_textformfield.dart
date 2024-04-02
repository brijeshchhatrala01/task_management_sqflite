import 'package:flutter/material.dart';
import 'package:task_management/theme/colors.dart';
import 'package:task_management/theme/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final IconData iconData;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLine;
  const CustomTextFormField(
      {super.key,
      required this.hintText,
      required this.iconData,
      required this.controller,
      required this.keyboardType,
      required this.maxLine});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLine,
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        return value!.isEmpty ? "Please Enter Required Fields" : null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(iconData),
        errorStyle: errorTextStyle,
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor),
            borderRadius: BorderRadius.circular(12)),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor),
            borderRadius: BorderRadius.circular(12)),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
