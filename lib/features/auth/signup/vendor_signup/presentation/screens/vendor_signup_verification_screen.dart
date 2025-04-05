import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/signup_progress_indicator.dart';
import '../widgets/signup_step_indicator.dart';

class QuickDealAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onHelpPressed;

  const QuickDealAppBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.onHelpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      )
          : null,
      title: title != null
          ? Text(
        title!,
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Image.asset(
          'assets/images/quickdeal_logo.png',
          height: 30,
        ),
      ),
      actions: [
        TextButton(
          onPressed: onHelpPressed,
          child: Text(
            'Need help?',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class VendorVerificationPage extends StatefulWidget {
  const VendorVerificationPage({super.key});

  @override
  State<VendorVerificationPage> createState() => _VendorVerificationPageState();
}

class _VendorVerificationPageState extends State<VendorVerificationPage> {
  File? _logoFile;
  String? _businessLicenseFileName;
  String? _taxCertificateFileName;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickLogo() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _logoFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _pickDocument(String documentType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          if (documentType == 'license') {
            _businessLicenseFileName = result.files.single.name;
          } else if (documentType == 'tax') {
            _taxCertificateFileName = result.files.single.name;
          }
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error picking document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final primaryAccent = const Color(0xFFF9446D);

    return Scaffold(
      appBar: QuickDealAppBar(
        showBackButton: true,
        title: 'Vendor Registration',
        onBackPressed: () {
          // Handle back navigation with confirmation if needed
          Navigator.of(context).pop();
        },
        onHelpPressed: () {
          // Show help dialog or navigate to help page
        },
      ),
      body: Column(
        children: [
          // Fixed header with progress indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SignupProgressIndicator(
                  currentStep: 2,
                  totalSteps: 3,
                ),
                const SizedBox(height: 16),
                const SignupStepIndicator(
                  currentStep: 2,
                  stepLabels: ['Business Info', 'Verification', 'Services'],
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
                  // Logo Upload Section
                  Text(
                    'Upload Your Business Logo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Business logos can help your clients gain more trust and make your portfolio professional.',
                    style: TextStyle(
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logo Upload Area
                  Center(
                    child: GestureDetector(
                      onTap: _pickLogo,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: _logoFile != null
                            ? ClipOval(
                          child: Image.file(
                            _logoFile!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(
                          Icons.image,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Verification Documents Section
                  Text(
                    'Verification Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Business License Upload
                  _buildDocumentUploadBox(
                    context: context,
                    title: 'Upload Business License',
                    fileName: _businessLicenseFileName,
                    onTap: () => _pickDocument('license'),
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),

                  // Tax Certificate Upload
                  _buildDocumentUploadBox(
                    context: context,
                    title: 'Upload Tax Certificate',
                    fileName: _taxCertificateFileName,
                    onTap: () => _pickDocument('tax'),
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
          ),

          // Fixed footer
          Container(
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle next step
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next Step'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 16),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontSize: 14,
                        color: subtitleColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to login
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: primaryAccent,
                        padding: const EdgeInsets.only(left: 4),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentUploadBox({
    required BuildContext context,
    required String title,
    required String? fileName,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    final borderColor = isDarkMode ? Colors.white30 : Colors.grey[300];
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor!,
            width: 1,
            //style: BorderStyle.dashed,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 32,
              color: subtitleColor,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fileName ?? 'Choose File',
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}