import 'package:flutter/material.dart';
import '../../core/utils/constants/image_strings.dart';
import '../../core/utils/helpers/helpers.dart';
import '../../core/utils/loggers/logger.dart';

Widget getLogoBasedOnTheme(
    BuildContext context, {
      double? width,
      double? height,
    }) {
  final isDarkTheme = AppHelperFunctions.isDarkTheme(context);
  Log.i(isDarkTheme ? 'Dark theme' : 'Light theme');
  return isDarkTheme
      ? Image.asset(
    ImageStrings.darkAppLogo,
    width: width,
    height: height,
  )
      : Image.asset(
    ImageStrings.lightAppLogo,
    width: width,
    height: height,
  );
}