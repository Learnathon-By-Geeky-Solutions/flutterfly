import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../constants/color_palette.dart';

class AppHelperFunctions {
  static Widget appLoader(BuildContext context) {
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

  static String limitWords(String text, int wordLimit) {
    final words = text.split(' ');
    if (words.length <= wordLimit) return text;
    return '${words.take(wordLimit).join(' ')}...';
  }

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
