extension ToCurrency on String {
  double toDouble() {
    return double.tryParse(
          trim().replaceAll(',', '.').replaceAll(' ', ''),
        ) ??
        0;
  }
}
