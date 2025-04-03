import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selo/core/theme/theme_provider.dart';
import 'package:selo/generated/l10n.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final TextAlign? textAlign;
  final String? suffixText;
  final TextStyle? style;
  final void Function()? onTap;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool autofocus;
  final void Function(String)? onChanged;
  final int? maxLength;
  final Color? fillColor;
  final Color? hintColor;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLines;
  final String? Function(String?)? validator;

  const TextFieldWidget({
    super.key,
    this.controller,
    this.labelText,
    this.keyboardType,
    this.textAlign,
    this.suffixText,
    this.inputFormatters,
    this.style,
    this.onTap,
    this.prefix,
    this.suffixIcon,
    this.readOnly = false,
    this.autofocus = false,
    this.onChanged,
    this.maxLength,
    this.prefixIcon,
    this.fillColor,
    this.enabled,
    this.focusNode,
    this.textInputAction,
    this.minLines,
    this.maxLines,
    this.validator,
    this.hintText,
    this.hintColor,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final FocusNode _textFieldFocus = FocusNode();

  @override
  void initState() {
    if (widget.focusNode != null) {
      widget.focusNode!.addListener(() {
        setState(() {});
      });
    } else {
      _textFieldFocus.addListener(() {
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.number,
      inputFormatters: widget.inputFormatters,
      textAlign: widget.textAlign ?? TextAlign.start,
      autofocus: widget.autofocus,
      cursorColor: theme.colors.green,
      minLines: widget.minLines ?? 1,
      maxLines: widget.maxLines ?? 3,
      textInputAction: widget.textInputAction,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      focusNode: widget.focusNode ?? _textFieldFocus,
      onChanged: widget.onChanged,
      validator:
          widget.validator ??
          (value) {
            if (value!.isEmpty) {
              return S.of(context).requiredField;
            } else {
              return null;
            }
          },
      style:
          widget.style ??
          TextStyle(
            fontSize: 20,
            color: theme.colors.black,
            fontWeight: FontWeight.w700,
          ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixText: widget.suffixText,
        suffixIcon: widget.suffixIcon,
        prefix: widget.prefix,
        prefixIcon: widget.prefixIcon,
        hintText: widget.hintText,
        counterText: '',
        hintStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: widget.hintColor ?? theme.colors.black.withOpacity(0.6),
        ),
        labelStyle: TextStyle(
          fontSize: 18,
          color: theme.colors.black.withOpacity(0.8),
          fontWeight: FontWeight.w700,
        ),
        border: InputBorder.none,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide.none,
        ),
        disabledBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide.none,
        ),
        errorBorder: const UnderlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
          borderSide: BorderSide.none,
        ),
        fillColor: theme.colors.black.withOpacity(0.15),
        filled: true,
      ),
    );
  }
}
