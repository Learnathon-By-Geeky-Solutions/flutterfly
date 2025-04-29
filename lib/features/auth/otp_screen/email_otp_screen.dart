
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart'; // Import your AuthService here
import 'package:quickdeal/core/services/role_manager/role_manager.dart';
import 'package:quickdeal/core/services/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../common/widget/getLogoWidget.dart';
import '../../../core/services/memory_management/hive/hive_service.dart';
import '../../../core/utils/constants/color_palette.dart';
import 'package:quickdeal/common/widget/custom_snackbar.dart';

class EmailOtpScreen extends ConsumerStatefulWidget {
  final String email;
  const EmailOtpScreen({super.key, required this.email});

  @override
  ConsumerState<EmailOtpScreen> createState() => _EmailOtpScreenState();
}

class _EmailOtpScreenState extends ConsumerState<EmailOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  String _otp = '';
  final AuthService _authService = AuthService();

  @override
  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }


  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      });
    }
    _otp = _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtp() async {
    try {
      final response = await _authService.verifyOtp(widget.email, _otp);

      if (response.user == null) {
        CustomSnackbar.show(
          context,
          message: 'Failed to verify OTP',
          type: SnackbarType.error,
        );
        return;
      }

      Future.delayed(const Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      });

      UserRole userRole = getCurrentUserRole();
      final router = GoRouter.of(context);

      if(mounted && userRole == UserRole.vendor) {
        final hiveService = HiveService();
        final box = hiveService.box('vendor');
        final servicesOffered = box.get('services_offered');
        final vendorInfo = box.get('vendorInfo');

        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;

        if (user == null) {
          CustomSnackbar.show(
            context,
            message: 'User is not authenticated!',
            type: SnackbarType.error,
          );
          return;
        }

        List<String> categoryIds = [];

        for (String serviceName in servicesOffered) {
          final categoryResponse = await supabase
              .from('categories')
              .select('category_id')
              .eq('name', serviceName)
              .maybeSingle();

          if (categoryResponse != null) {
            categoryIds.add(categoryResponse['category_id']);
          }
        }

        // Now categoryIds contains the category_id for each service name.

        await supabase.from('vendors').update({
          'business_name': vendorInfo['businessName'],
          'business_type': vendorInfo['businessType'],
          'address': {
            'streetAddress': vendorInfo['streetAddress'],
            'city': vendorInfo['city'],
            'state': vendorInfo['state'],
            'zipCode': vendorInfo['zipCode'],
          },
          'contact_number': vendorInfo['phoneNumber'],
          'tin': vendorInfo['taxIdNumber'],
          'services_offered': categoryIds, // <-- now it's category IDs, not names
        }).eq('vendor_id', user.id);


        router.go(AppRoutes.vendorHome);
      }
      else if(mounted && userRole == UserRole.client){
        router.go(AppRoutes.clientHome);
      }

    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Failed to verify OTP: ${e.toString()}',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _resendOtp() async {
    try {
      await _authService.resendOtp(widget.email);
      CustomSnackbar.show(
        context,
        message: 'OTP resent successfully!',
        type: SnackbarType.success,
      );
    } catch (e) {
      CustomSnackbar.show(
        context,
        message: 'Failed to resend OTP: ${e.toString()}',
        type: SnackbarType.error,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  getLogoBasedOnTheme(context, width: 150, height: 50),
                  const SizedBox(height: 24),
                  Text(
                    'Enter OTP',
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We have sent a 6-digit verification code to your email.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        child: TextField(
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                            style: textTheme.headlineSmall?.copyWith(color:
                            AppColors.primaryDark),
                          cursorColor: AppColors.primaryAccent,
                          onChanged: (value) => _onOtpChanged(value, index),
                          decoration: InputDecoration(
                            counterText: '',
                            filled: true,
                            focusColor: AppColors.primaryAccent,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppColors.primaryAccent),
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _verifyOtp, // Call _verifyOtp function
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 5,
                      ),
                      child: Text(
                        'Verify',
                        style: textTheme.labelLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _resendOtp, // Call _resendOtp function
                    child: Text(
                      'Resend Code',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
