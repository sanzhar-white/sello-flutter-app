import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

navigateTo({
  required BuildContext context,
  bool rootNavigator = false,
  required Widget screen,
  bool fullScreenDialog = false,
}) async {
  final a = await Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).push(
    CupertinoPageRoute(
      fullscreenDialog: fullScreenDialog,
      builder: (context) => screen,
    ),
  );
  return a;
}

navigateToReplacement({
  required BuildContext context,
  bool rootNavigator = false,
  required Widget screen,
  bool fullScreenDialog = false,
}) async {
  final a = await Navigator.of(
    context,
    rootNavigator: rootNavigator,
  ).pushReplacement(
    CupertinoPageRoute(
      builder: (context) => screen,
    ),
  );
  return a;
}

String currencyFormat(
  BuildContext context,
  num value,
) {
  String stringValue = NumberFormat.currency(
    locale: 'ru',
    symbol: 'тг.',
    decimalDigits: 0,
  ).format(value);

  return stringValue;
}

String dateFormatYMMMd(DateTime date) {
  final result = DateFormat.yMMMMd('ru').format(date);
  return result;
}

String dateFormatHMd(DateTime date) {
  final result = DateFormat.Hm('ru').format(date);
  return result;
}

//10:00
String dateHMFromString(BuildContext? context, String date) {
  final result = DateFormat.Hm('ru').format(DateTime.parse(date));
  return result;
}

//23.23.2024
String dateYMdFromString(BuildContext? context, String date) {
  final result = DateFormat.yMd('ru').format(DateTime.parse(date));
  return result;
}

//23 MMMM 2024
String dateYMMMdFromString(BuildContext? context, String date) {
  final result = DateFormat.yMMMMd('ru').format(DateTime.parse(date));
  return result;
}

int generateId() {
  final id = int.parse(
      DateTime.now().millisecondsSinceEpoch.toString().substring(1, 10));
  return id;
}

class MoneyTextInputFormatter extends TextInputFormatter {
  final bool needCurrencySymbol;

  MoneyTextInputFormatter({this.needCurrencySymbol = false});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedString =
        formatCurrencyStringToTextController(newValue.text, needCurrencySymbol);

    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(
        offset: formattedString.length - (needCurrencySymbol ? 2 : 0),
      ),
    );
  }
}

String formatCurrencyStringToTextController(
    String value, bool needCurrencySymbol) {
  if ((value.contains('.') || value.contains(',')) && value.length == 1) {
    value = '0$value';
  }
  if (value.contains(',')) {
    if (value.length > value.indexOf(',') + 3) {
      value = value.substring(0, value.length - 1);
    }
  } else if (value.contains('.')) {
    if (value.length > value.indexOf('.') + 3) {
      value = value.substring(0, value.length - 1);
    }
  }
  if (value.contains(',') || value.contains('.')) {
    if (value.lastIndexOf(',') != value.indexOf(',') ||
        value.lastIndexOf('.') != value.indexOf('.')) {
      value = value.substring(0, value.length - 1);
    }
  }
  if (value.contains(',') && value.contains('.')) {
    value = value.substring(0, value.length - 1);
  }
  final String newValueText = value.replaceAll('Т', '').replaceAll(' ', '');
  // Форматирование нового значения
  String formattedValue = '';
  int digitCount = 0;
  for (int i = newValueText.length - 1; i >= 0; i--) {
    if (newValueText[i] == '.' || newValueText[i] == ',') {
      digitCount = 5;
    }
    formattedValue = newValueText[i] + formattedValue;
    digitCount++;
    // Добавление пробела перед каждой третьей цифрой, кроме первой
    if (digitCount % 3 == 0 && i != 0) {
      formattedValue = ' ' + formattedValue;
      digitCount = 0; // Сброс счетчика цифр
    }
  }
  if (formattedValue.contains('.')) {
    formattedValue =
        formattedValue.substring(0, formattedValue.indexOf('.') - 1) +
            formattedValue.substring(
                formattedValue.indexOf('.'), formattedValue.length);
  } else if (formattedValue.contains(',')) {
    formattedValue =
        formattedValue.substring(0, formattedValue.indexOf(',') - 1) +
            formattedValue.substring(
                formattedValue.indexOf(','), formattedValue.length);
  }

  // Добавление символа тенге в конец строки
  if (needCurrencySymbol) formattedValue += ' т';
  return formattedValue;
}
