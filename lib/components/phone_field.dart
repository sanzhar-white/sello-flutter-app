import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:selo/core/theme/theme_provider.dart';

class PhoneFieldWidget extends StatelessWidget {
  final Function(PhoneNumber) onChanged;
  final TextEditingController controller;
  const PhoneFieldWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppThemeProvider.of(context).themeMode;

    return IntlPhoneField(
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Color(0xffD5DDE0)),
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Color(0xffD5DDE0)),
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Color(0xffD5DDE0)),
          borderRadius: BorderRadius.all(const Radius.circular(14.0)),
        ),
        filled: true,
        fillColor: theme.colors.colorText3.withOpacity(0.1),
      ),
      invalidNumberMessage: 'Не верно указан номер телефона',
      initialCountryCode: 'KZ',
      controller: controller,
      onChanged: onChanged,
    );
  }
}
