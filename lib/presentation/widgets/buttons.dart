import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:task_app/core/theme/color.dart';
import 'package:task_app/core/theme/text_style.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;

  final String lable;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool isLoading;
  final Color? color;
  const AppButton(
      {super.key,
      required this.onTap,
      required this.lable,
      this.isLoading = false,
      this.height,
      this.width,
      this.color,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onTap:  onTap,
      child: Container(
        height: height ?? 45,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color ?? AppColors.primaryColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.06),
                blurRadius: 5,
                spreadRadius: 5,
                offset: const Offset(0.0, 0.0),
              )
            ]),
        child: Center(
          child: isLoading
              ? LoadingAnimationWidget.twistingDots(
                  leftDotColor: AppColors.lightTextColor,
                  rightDotColor: AppColors.lightTextColor,
                  size: 18,
                )
              : Text(
                  lable,
                  style: AppTextStyle.darkBodyLargeBold.copyWith(
                    fontSize: fontSize ?? 16,
                  ),
                ),
        ),
      ),
    );
  }
}

