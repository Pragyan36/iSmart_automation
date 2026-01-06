class NumberUtils {
  static String to2Decimal(dynamic value) {
    if (value == null) return "0.00";

    final double? number = double.tryParse(value.toString());
    if (number == null) return "0.00";

    return number.toStringAsFixed(2);
  }

  static double to2DecimalDouble(dynamic value) {
    if (value == null) return 0.0;

    final double? number = double.tryParse(value.toString());
    if (number == null) return 0.0;

    return double.parse(number.toStringAsFixed(2));
  }
}
