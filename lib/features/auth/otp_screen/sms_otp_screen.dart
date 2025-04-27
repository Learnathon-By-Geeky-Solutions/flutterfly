import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quickdeal/core/services/auth_service/auth_service.dart'; // Adjust to your project path
import 'package:quickdeal/common/widget/custom_snackbar.dart'; // Your custom snackbar
import 'package:go_router/go_router.dart'; // For navigation
import 'package:hive/hive.dart'; // For getting vendor info

class VendorPhoneOtpScreen extends StatefulWidget {
  const VendorPhoneOtpScreen({super.key});

  @override
  State<VendorPhoneOtpScreen> createState() => _VendorPhoneOtpScreenState();
}

class _VendorPhoneOtpScreenState extends State<VendorPhoneOtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthService _authService = AuthService();

  int _secondsRemaining = 60;
  bool _isResendEnabled = false;
  Timer? _timer;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
    _startTimer();
  }

  Future<void> _fetchPhoneNumber() async {
    final vendorBox = await Hive.openBox('vendor');
    final vendorInfo = vendorBox.get('vendorInfo');
    setState(() {
      _phoneNumber = vendorInfo['phoneNumber'];
      print(_phoneNumber);
    });
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _isResendEnabled = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      CustomSnackbar.show(context, message: 'Please enter a valid 6-digit OTP', type: SnackbarType.error);
      return;
    }

    try {
      if (_phoneNumber != null) {
        await _authService.verifyVendorPhoneOtp(_phoneNumber!, otp);
        CustomSnackbar.show(context, message: 'Phone verified successfully!', type: SnackbarType.success);
        context.go('/vendorSuccess'); // Replace with your desired route
      }
    } catch (e) {
      CustomSnackbar.show(context, message: e.toString(), type: SnackbarType.error);
    }
  }

  Future<void> _resendOtp() async {
    if (_phoneNumber == null) return;
    try {
      await _authService.signupVendorWithPhone(_phoneNumber!);
      CustomSnackbar.show(context, message: 'OTP resent successfully', type: SnackbarType.success);
      _startTimer();
    } catch (e) {
      CustomSnackbar.show(context, message: 'Failed to resend OTP', type: SnackbarType.error);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Phone'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code sent to your phone number:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'OTP Code',
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text('Verify'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                _isResendEnabled
                    ? 'Didn\'t receive the code?'
                    : 'Resend available in $_secondsRemaining seconds',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _isResendEnabled ? _resendOtp : null,
                child: const Text('Resend OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
