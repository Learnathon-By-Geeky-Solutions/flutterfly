import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  static String limitWords(String text, int charLimit) {
    if(charLimit <= 3) {
      charLimit = 16;
    }
    if (text.length <= charLimit) return text;
    return '${text.substring(0, charLimit)}...';
  }

  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static String formatTimeLeft(String deadline) {
    final endDate = DateTime.parse(deadline);
    final now = DateTime.now();
    final difference = endDate.difference(now);

    if (difference.isNegative) return 'Deadline Passed';

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final parts = <String>[];

    if (days > 0) parts.add('${twoDigits(days)}d');
    if (hours > 0 || days > 0) parts.add('${twoDigits(hours)}h');
    parts.add('${twoDigits(minutes)}m');

    return parts.join(' ');
  }

  static String formatDate(String rawDate) {
    final date = DateTime.parse(rawDate);
    return DateFormat.yMMMEd().format(date);
  }

}
