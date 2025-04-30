import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/adapters.dart';
import '../../../../../../common/widget/custom_snackbar.dart';
import '../../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../../core/services/memory_management/hive/hive_service.dart';
import '../../../../../../core/services/routes/app_routes.dart';
import '../../../../../rfq/client_rfq/create_rfq/domain/entities/category.dart';
import '../controllers/vendor_signup_controller.dart';
import '../widgets/signup_progress_indicator.dart';
import '../widgets/signup_step_indicator.dart';

class VendorSignupServicesScreen extends ConsumerStatefulWidget {
  const VendorSignupServicesScreen({super.key});

  @override
  ConsumerState<VendorSignupServicesScreen> createState() =>
      _VendorSignupServicesScreenState();
}

class _VendorSignupServicesScreenState
    extends ConsumerState<VendorSignupServicesScreen> {
  // List to store selected categories as Category enums
  List<Category> selectedCategories = [];

  // Function to handle vendor signup and OTP
  Future<void> vendorSignup() async {
    if (mounted) {
      AuthService authService = AuthService();

      // Open Hive box and store the selected services
      final hiveService = HiveService();
      final box = hiveService.box('vendor');
      final userInfo = box.get('userInfo');

      final email = userInfo['email'];
      final fullName = userInfo['fullName'];
      final password = userInfo['password'];
      final isVendor = userInfo['isVendor'];

      await authService.signupWithEmailOtp(email, password, fullName, isVendor);

      Future.delayed(const Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent to $email'),
            backgroundColor: Colors.green,
          ),
        );
      });

      context.go(AppRoutes.emailOtpScreen, extra: email);
    } else {
      CustomSnackbar.show(
        context,
        message: 'Signup error occurred. Please try again.',
        type: SnackbarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(vendorSignupControllerProvider.notifier);
    final state = ref.watch(vendorSignupControllerProvider);
    final signup = state.signup;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Vendor Registration',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Moved indicators here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SignupProgressIndicator(
                    currentStep: 2,
                    totalSteps: 2,
                  ),
                  const SizedBox(height: 16),
                  SignupStepIndicator(
                    currentStep: 2,
                    stepLabels: const [
                      'Business Info',
                      'Services',
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Service Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You\'re at the last step! Select which services your business offers, and you\'re good to go! You can select multiple services.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Render service options using Category enum
                    ...CategoryExtension.getCategories().map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: selectedCategories.contains(category),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedCategories.add(category);
                                    } else {
                                      selectedCategories.remove(category);
                                    }
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCategories.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select at least one service.')),
                      );
                      return;
                    }

                    // Open Hive box and store the selected services
                    await Hive.openBox('vendor');
                    final hiveService = HiveService();
                    final box = hiveService.box('vendor');
                    final selectedCategoryNames =
                    selectedCategories.map((e) => e.name).toList();
                    await box.put('services_offered', selectedCategoryNames);
                    print('Selected Services: $selectedCategoryNames');

                    vendorSignup();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4D79),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Complete Registration',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
