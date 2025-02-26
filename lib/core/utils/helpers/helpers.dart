import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutterfly/core/utils/constants/colors.dart';

class AppHelperFunctions
{
  Widget appLoader(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LoadingAnimationWidget.flickr(
          leftDotColor: AppColors.logoPrimary,
          rightDotColor: AppColors.logoSecondary,
          size: 50.0,
        ),
      ),
    );
  }
}