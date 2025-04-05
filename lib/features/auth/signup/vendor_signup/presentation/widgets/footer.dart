import 'package:flutter/material.dart';
import '../../../../../../core/utils/constants/color_palette.dart';

class Footer extends StatelessWidget {
  final VoidCallback? onNextPressed;
  final VoidCallback? onLoginPressed;
  final bool isLoading;
  final bool isLastStep;

  const Footer({
    super.key,
    required this.onNextPressed,
    required this.onLoginPressed,
    required this.isLoading,
    required this.isLastStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Next Step" button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onNextPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isLastStep ? 'Submit' : 'Next Step'),
                  if (!isLoading)
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  if (isLoading)
                    Container(
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(left: 8),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // "Already have an account?" text and "Log in" button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 11,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54,
                ),
              ),
              TextButton(
                onPressed: onLoginPressed,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryAccent,
                  padding: const EdgeInsets.only(left: 4),
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}