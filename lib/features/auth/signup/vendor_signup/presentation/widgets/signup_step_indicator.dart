import 'package:flutter/material.dart';

class SignupStepIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;

  const SignupStepIndicator({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final inactiveColor = isDarkMode ? Colors.white30 : Colors.black26;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        stepLabels.length,
            (index) {
          final isActive = index + 1 <= currentStep;
          return Expanded(
            child: Text(
              stepLabels[index],
              textAlign: index == 0
                  ? TextAlign.left
                  : (index == stepLabels.length - 1 ? TextAlign.right : TextAlign.center),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w400 : FontWeight.normal,
                color: isActive ? textColor : inactiveColor,
              ),
            ),
          );
        },
      ),
    );
  }
}