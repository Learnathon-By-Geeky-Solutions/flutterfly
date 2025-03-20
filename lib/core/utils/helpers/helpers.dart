import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/color_palette.dart';

class AppHelperFunctions {
  Widget appLoader(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: AppColors.primaryDark,
          rightDotColor: AppColors.primaryAccent,
          size: 50.0,
        ),
      ),
    );
  }

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
