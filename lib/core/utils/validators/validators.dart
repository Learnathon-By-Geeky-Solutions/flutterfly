import 'package:quickdeal/l10n/generated/app_localizations.dart';

class Validators {

  static final RegExp _emailRegExp = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$',
  );

  /// Validates the email field.
  ///
  /// Returns an error message from [loc] if the email is empty or invalid,
  /// otherwise returns null.
  static String? validateEmail(String? value, AppLocalizations loc) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return loc.emailRequired;
    }
    if (!_emailRegExp.hasMatch(trimmedValue)) {
      return loc.invalidEmail;
    }
    return null;
  }

  /// Validates the password field.
  ///
  /// Returns an error message from [loc] if the password is empty, does not meet the
  /// minimum length requirement, or fails any of the additional criteria if specified:
  ///
  /// - [requireUppercase]: Ensures at least one uppercase letter exists.
  /// - [requireDigit]: Ensures at least one digit exists.
  /// - [requireSpecialChar]: Ensures at least one special character exists.
  /// - [disallowSpaces]: Ensures that no spaces are included.
  ///
  /// The [minLength] parameter sets the minimum length (default is 6).
  ///
  /// Customize your localized error messages accordingly.
  static String? validatePassword(
      String? value,
      AppLocalizations loc, {
        int minLength = 6,
        bool requireUppercase = false,
        bool requireDigit = false,
        bool requireSpecialChar = false,
        bool disallowSpaces = false,
      }) {
    final trimmedValue = value?.trim() ?? '';

    if (trimmedValue.isEmpty) {
      return loc.passwordRequired;
    }
    if (trimmedValue.length < minLength) {
      return loc.passwordTooShort;
    }
    if (requireUppercase && !RegExp(r'[A-Z]').hasMatch(trimmedValue)) {
      return loc.passwordRequireUppercase;
    }
    if (requireDigit && !RegExp(r'\d').hasMatch(trimmedValue)) {
      return loc.passwordRequireDigit;
    }
    if (requireSpecialChar &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmedValue)) {
      return loc.passwordRequireSpecialChar;
    }
    if (disallowSpaces && trimmedValue.contains(' ')) {
      return loc.passwordNoSpacesAllowed;
    }
    return null;
  }
}