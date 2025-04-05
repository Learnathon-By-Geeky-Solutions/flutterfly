import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/utils/constants/color_palette.dart';
import '../controllers/vendor_signup_controller.dart';

class BusinessInfoForm extends ConsumerWidget {
  const BusinessInfoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(vendorSignupControllerProvider.notifier);
    final state = ref.watch(vendorSignupControllerProvider);
    final registration = state.signup;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Form(
      key: controller.businessInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mandatory fields note
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '* ',
                  style: TextStyle(
                    color: AppColors.errorRed,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: 'marks mandatory',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Business Name
          _buildFieldLabel(context, 'Business Name', true),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: registration.businessName,
            decoration: const InputDecoration(
              hintText: 'Enter business name',
            ),
            validator: controller.validateBusinessName,
            onSaved: (value) => controller.updateBusinessName(value ?? ''),
          ),
          const SizedBox(height: 16),

          // Business Type
          _buildFieldLabel(context, 'Business Type', true),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: registration.businessType.isNotEmpty ? registration.businessType : null,
            decoration: const InputDecoration(
              hintText: 'Select business type',
            ),
            items: controller.businessTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList(),
            validator: controller.validateBusinessType,
            onChanged: (value) {
              if (value != null) {
                controller.updateBusinessType(value);
              }
            },
            onSaved: (value) {
              if (value != null) {
                controller.updateBusinessType(value);
              }
            },
          ),
          const SizedBox(height: 16),

          // Business Address
          _buildFieldLabel(context, 'Business Address', true),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: registration.streetAddress,
            decoration: const InputDecoration(
              hintText: 'Street address',
            ),
            validator: controller.validateStreetAddress,
            onSaved: (value) => controller.updateStreetAddress(value ?? ''),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: registration.city,
            decoration: const InputDecoration(
              hintText: 'City',
            ),
            validator: controller.validateCity,
            onSaved: (value) => controller.updateCity(value ?? ''),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: registration.state,
                  decoration: const InputDecoration(
                    hintText: 'State',
                  ),
                  validator: controller.validateState,
                  onSaved: (value) => controller.updateState(value ?? ''),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  initialValue: registration.zipCode,
                  decoration: const InputDecoration(
                    hintText: 'ZIP',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: controller.validateZipCode,
                  onSaved: (value) => controller.updateZipCode(value ?? ''),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Contact Information
          _buildFieldLabel(context, 'Contact Information', true),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: registration.phoneNumber,
            decoration: const InputDecoration(
              hintText: 'Phone number',
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _PhoneNumberFormatter(),
            ],
            validator: controller.validatePhoneNumber,
            onSaved: (value) => controller.updatePhoneNumber(value ?? ''),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: registration.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Email address',
            ),
            keyboardType: TextInputType.emailAddress,
            validator: controller.validateEmailAddress,
            onSaved: (value) => controller.updateEmailAddress(value ?? ''),
          ),
          const SizedBox(height: 16),

          // Tax ID Number
          _buildFieldLabel(context, 'Tax ID Number', true),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: registration.taxIdNumber,
            decoration: const InputDecoration(
              hintText: 'Enter Tax ID',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              _TaxIdFormatter(),
            ],
            validator: controller.validateTaxIdNumber,
            onSaved: (value) => controller.updateTaxIdNumber(value ?? ''),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label, bool isRequired) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.red
            ),
          ),
      ],
    );
  }
}

// Custom formatters
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length > 10) {
      return oldValue;
    }

    String formatted = '';

    if (digitsOnly.isNotEmpty) {
      formatted = '(${digitsOnly.substring(0, min(3, digitsOnly.length))}';
    }

    if (digitsOnly.length > 3) {
      formatted += ') ${digitsOnly.substring(3, min(6, digitsOnly.length))}';
    }

    if (digitsOnly.length > 6) {
      formatted += '-${digitsOnly.substring(6)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _TaxIdFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length > 9) {
      return oldValue;
    }

    String formatted = '';

    if (digitsOnly.isNotEmpty) {
      formatted = digitsOnly.substring(0, min(2, digitsOnly.length));
    }

    if (digitsOnly.length > 2) {
      formatted += '-${digitsOnly.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Helper function
int min(int a, int b) => a < b ? a : b;