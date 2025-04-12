library;

import 'package:flutter/material.dart';

class InputFormField extends StatefulWidget {
  const InputFormField({
    super.key,
    required this.textEditingController,
    this.style,
    this.hintText,
    this.hintTextStyle,
    this.label,
    this.labelText,
    this.labelTextStyle,
    this.errorTextStyle,
    this.floatingLabelBehavior,
    this.suffix,
    this.prefix,
    this.password,
    this.obscureText,
    this.obscuringCharacter = '•',
    this.validator,
    this.enableDefaultValidation = false,
    this.height,
    this.contentPadding,
    this.errorPadding,
    this.bottomMargin,
    this.borderType = BorderType.none,
    this.borderRadius,
    this.borderColor = Colors.transparent,
    this.fillColor,
    this.errorColor = Colors.red,
  })  : assert(obscuringCharacter.length == 1,
  'Obscuring character must be a single character.'),
        assert(!(password != null && obscureText != null),
        'Both "password" and "obscureText" cannot be used at the same time.');

  final TextEditingController textEditingController;
  final TextStyle? style;
  final Widget? label;
  final String? labelText;
  final TextStyle? labelTextStyle;
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? errorTextStyle;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final Widget? prefix;
  final Widget? suffix;
  final EnabledPassword? password;
  final bool? obscureText;
  final String obscuringCharacter;
  final String? Function(String?)? validator;
  final bool enableDefaultValidation;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? errorPadding;
  final double? bottomMargin;
  final BorderType borderType;
  final Color borderColor;
  final BorderRadiusGeometry? borderRadius;
  final Color? fillColor;
  final Color errorColor;

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  bool isError = false;
  bool _showPassword = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final bool isOutlined = widget.borderType == BorderType.outlined;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) widget.label!,
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.fillColor,
            borderRadius:
            widget.borderRadius ?? _defaultBorderRadius(isOutlined),
            border: _buildBorder(isOutlined),
          ),
          child: TextFormField(
            controller: widget.textEditingController,
            textAlignVertical: TextAlignVertical.center,
            style: widget.style,
            decoration: InputDecoration(
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              labelText: widget.labelText,
              labelStyle: widget.labelTextStyle,
              hintText: widget.hintText,
              hintStyle: widget.hintTextStyle,
              floatingLabelBehavior: widget.floatingLabelBehavior,
              errorStyle: const TextStyle(fontSize: 0.01), // suppress
              border: InputBorder.none,
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix ??
                  (widget.password != null
                      ? _buildVisibilityButton(widget.password!)
                      : null),
            ),
            obscureText: widget.password != null
                ? _showPassword
                : (widget.obscureText ?? false),
            obscuringCharacter: widget.obscuringCharacter,
            onChanged: (value) {
              if (isError) {
                setState(() {
                  isError = false;
                  _errorMessage = null;
                });
              }
            },
            validator: (value) {
              final error = _validate(value);
              setState(() {
                isError = error != null;
                _errorMessage = error;
              });
              return error;
            },
          ),
        ),
        if (isError && _errorMessage != null)
          Padding(
            padding:
            widget.errorPadding ?? const EdgeInsets.only(left: 10, top: 5),
            child: Text(
              _errorMessage!,
              style:
              widget.errorTextStyle ?? TextStyle(color: widget.errorColor),
            ),
          ),
        if (widget.bottomMargin != null)
          SizedBox(height: widget.bottomMargin),
      ],
    );
  }

  String? _validate(String? value) {
    if (widget.enableDefaultValidation && (value?.isEmpty ?? true)) {
      return "This field is required";
    }
    return widget.validator?.call(value);
  }

  Border? _buildBorder(bool isOutlined) {
    if (widget.borderType == BorderType.none) return null;
    final borderSide = BorderSide(
        color: isError ? widget.errorColor : widget.borderColor);
    return isOutlined
        ? Border.all(color: borderSide.color)
        : Border(bottom: borderSide);
  }

  BorderRadius? _defaultBorderRadius(bool isOutlined) {
    return (isOutlined || widget.fillColor != null)
        ? BorderRadius.circular(8)
        : null;
  }

  IconButton _buildVisibilityButton(EnabledPassword password) {
    return IconButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => _showPassword = !_showPassword);
          }
        });
      },
      icon: _showPassword
          ? (password.hidePasswordIcon ?? const Icon(Icons.visibility_off))
          : (password.showPasswordIcon ?? const Icon(Icons.visibility)),
      splashColor: Colors.transparent,
    );
  }
}

/// Enables password visibility toggle.
class EnabledPassword {
  const EnabledPassword({this.showPasswordIcon, this.hidePasswordIcon});
  final Widget? showPasswordIcon;
  final Widget? hidePasswordIcon;
}

enum BorderType { outlined, bottom, none }