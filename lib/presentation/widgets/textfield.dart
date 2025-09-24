import 'package:flutter/material.dart';
import 'package:task_app/core/theme/color.dart';
import 'package:task_app/core/theme/text_style.dart';

class AppTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int? maxLength;
  final int? maxLines;
  final bool autofocus;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  const AppTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.maxLength,
    this.autofocus = false,
    this.maxLines,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      autofocus: autofocus,
      keyboardType: keyboardType,
      maxLength: maxLength,
      onTap: onTap,
      maxLines: maxLines,
      readOnly: readOnly!,
      style: AppTextStyle.lightBodyLargeMedium,
      decoration: InputDecoration(
        hintText: hintText,
        counterText: '',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.primaryColor),
        ),
        hintStyle: AppTextStyle.lightBodyLargeRegular,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
          
        ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red),
          ),
        focusedErrorBorder:   OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
