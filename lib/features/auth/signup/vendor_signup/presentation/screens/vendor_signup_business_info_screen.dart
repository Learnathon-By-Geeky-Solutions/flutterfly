import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdeal/features/auth/signup/vendor_signup/presentation/widgets/initial_appbar.dart';
import '../../../../../../core/services/routes/app_routes.dart';
import '../controllers/vendor_signup_controller.dart';
import '../widgets/business_information_form.dart';
import '../widgets/signup_progress_indicator.dart';
import '../widgets/signup_step_indicator.dart';
import '../widgets/footer.dart';

class VendorSignupBusinessInfoScreen extends ConsumerWidget {
  const VendorSignupBusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(vendorSignupControllerProvider.notifier);
    final state = ref.watch(vendorSignupControllerProvider);
    final signup = state.signup;

    return Scaffold(
      appBar: InitialAppbar(
        onHelpPressed: () {
          // Handle Help action
        },
      ),
      body: Column(
        children: [
          // Header with back button and "Vendor Registration"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                // Vendor Registration Text
                Text(
                  'Vendor Registration',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),

          // Fixed header with progress indicator
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SignupProgressIndicator(
                  currentStep: signup.currentStep,
                  totalSteps: 2,
                ),
                const SizedBox(height: 16),
                SignupStepIndicator(
                  currentStep: signup.currentStep,
                  stepLabels: const [
                    'Business Info',
                    //'Verification',
                    'Services'
                  ],
                ),
              ],
            ),
          ),

          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Show different form based on current step
                  if (signup.currentStep == 1)
                    const BusinessInfoForm(),
                  // Add other steps here when implemented
                ],
              ),
            ),
          ),

          // Footer with "Next Step" button and "Already have an account?" text
          Footer(
            onNextPressed: () async {
              if (signup.currentStep == 1) {
                final success = await controller.proceedToNextStep();
                if (success) {
                  // Navigate to next step or show next form
                  if (!context.mounted) return;
                  await context.push(AppRoutes.vendorSignupServicesScreen);
                }
              }
            },
            onLoginPressed: () {
              context.go(AppRoutes.login);
            },
            isLoading: state.isLoading,
            isLastStep: signup.currentStep == 2,
          ),
        ],
      ),
    );
  }
}